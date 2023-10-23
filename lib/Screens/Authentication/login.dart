import 'dart:convert';

import 'package:dig_app_launcher/GetElderlyDataBloc/elderly_data_bloc.dart';
import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Popup/alert_popup.dart';
import 'package:dig_app_launcher/Popup/login_popup.dart';
import 'package:dig_app_launcher/Popup/sync_dialog_popup.dart';
import 'package:dig_app_launcher/Screens/Admin/show_elderlies.dart';
import 'package:dig_app_launcher/Screens/Authentication/forgot_password.dart';
import 'package:dig_app_launcher/Screens/Authentication/signup.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/elderly_home.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:dig_app_launcher/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {

  bool isSupervisor;
  LoginScreen({Key? key, required this.isSupervisor}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );

  bool? alreadyHaveAccount;
  bool isLoading = false;
  bool isSync = false;
  String? elderlyId;
  late ElderlyDataBloc _elderlyDataBloc;

  void checkCredentialValue() async {
    final storedValue = await storage.read(key: 'email');
    if (mounted) {
      setState(() {
        alreadyHaveAccount = storedValue != null;
      });
    }
  }

  Future<void> _storeInfo(String name, String email, String password, String id,  String accessToken, String userRole) async {
    await storage.write(key: 'name', value: name);
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'password', value: password);
    await storage.write(key: 'id', value: id);
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'user_role', value: userRole);
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> _checkCredentials(String email, String password) async {
    final storedEmail = await storage.read(key: 'email');
    final storedPassword = await storage.read(key: 'password');

    if(storedEmail != null && storedPassword != null) {
      return email == storedEmail && password == storedPassword;
    }
    else {
      return false;
    }
  }

  List<AppInfo> installedApps = [];

  Future<void> _sendApps() async {
    setState(() {
      isSync = true;
    });

    List<AppInfo> apps = await InstalledApps.getInstalledApps(true, true);
    setState(() {
      installedApps = apps;
    });

    List<Map<String, String>> getApps = [];
    for (int i = 0; i < installedApps.length; i++) {
      String appName =  installedApps[i].name  ?? '';
      String appUrl = installedApps[i].packageName ?? '';
      String appImage = installedApps[i].icon != null ? base64Encode(installedApps[i].icon!) : '';

      Map<String, String> leisureMap = {
        'appName': appName,
        'appUrl': appUrl,
        'appImage': appImage,
      };
      getApps.add(leisureMap);
    }

    print("Apps: ${getApps.length}");
    requestSendAllInstalledApps(getApps, elderlyId!).whenComplete(() {
      setState(() {
        isSync = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => ElderlyHomeScreen(elderlyId: elderlyId)
        ), (Route<dynamic> route) => false
      );
    });
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      final email = emailController.text;
      final password = passwordController.text;
      final isValid = await _checkCredentials(email, password);

      if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        requestLogin(email, password, widget.isSupervisor).then((value) {
          if(value != null && value.status == true) {
            _storeInfo(value.data.userFullName, value.data.userEmail, passwordController.text, value.data.id, value.data.accessToken, value.data.userRole);
            elderlyId = value.data.id;
            if(value.data.userRole == 'elderly'){
              requestGetSpecificElderly(elderlyId!).then((value) {
                if(value != null && value.status == true) {
                  _elderlyDataBloc.add(SaveElderlyDataToLocalDB(
                    titleSize: value.data.userTitleSize, textSize: value.data.userTextSize,
                    favoritePhoneContacts: value.data.elderlyFavoritesContacts, emergencyPhoneContacts: value.data.elderlyEmergencyContacts,
                    volumeValue: value.data.userVolume, bluetoothValue: value.data.userBluetooth,
                    elderlyMedicineModel: value.data.elderlyMedicine, elderlyAppModel: value.data.elderlyGame,
                  ));
                }
                else {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: AlertDialogPopup(
                          text: "sincronización de datos fallido. Inténtalo de nuevo",
                          isVisible: true,
                        ),
                      ),
                    ),
                  );
                }
              });
            }
            else if(value.data.userRole == 'administrator'){
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const ShowElderlyScreen()
                ), (Route<dynamic> route) => false
              );
            }
            else if(value.data.userRole == 'supervisor'){
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const ShowElderlyScreen()
                ), (Route<dynamic> route) => false
              );
            }
            else{
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: AlertDialogPopup(
                      text: "Ocurrió un error. Intentar otra vez",
                      isVisible: true,
                    ),
                  ),
                ),
              );
            }
          }
          else{
            showDialog(
              context: context,
              builder: (_) => Dialog(
                insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: AlertPopup(
                    title: "Identificación\nIncorrecta",
                    text: "El usuario o clave no es correcto.\nSi no lo recuerda haga click en Volver y en\n¿Olvidaste la contraseña?",
                    isVisible: true,
                  ),
                ),
              )
            );
          }
        }).whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
      }
      else {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: AlertPopup(
                title: "Identificación\nIncorrecta",
                text: "El usuario o clave no es correcto.\nSi no lo recuerda haga click en Volver y en\n¿Olvidaste la contraseña?",
                isVisible: true,
              ),
            ),
          )
        );
      }
    }
  }

  @override
  void initState() {
    checkCredentialValue();
    _elderlyDataBloc = BlocProvider.of<ElderlyDataBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ElderlyDataBloc, ElderlyDataState>(
      listener: (context, state) async {
        if (state is LoadingState) {}
        else if (state is ErrorState) {
          Fluttertoast.showToast(
            msg: state.error,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey.shade400,
            textColor: Colors.white,
            fontSize: 12.0
          );
        }
        else if (state is RefreshScreenState) {}
        else if (state is DataStoredState) {
          await _sendApps();
        }
      }, builder: (context, state) {
      return AbsorbPointer(
        absorbing: isLoading || isSync,
        child: Scaffold(
          appBar: const AppbarLogo(),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.2),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.08, right: MediaQuery.of(context).size.width * 0.08,
                          top: MediaQuery.of(context).size.height * 0.07
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.075, bottom: MediaQuery.of(context).size.height * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'INICIAR SESIÓN',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 1.5,
                                    color: const Color(0xffD0D0D0),
                                    endIndent: MediaQuery.of(context).size.width * 0.2,
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              controller: emailController,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                ? 'Introduzca un correo electrónico válido'
                                : null,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email, color: Colors.grey),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                hintText: 'Indica tu correo electronico',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 13)
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                              value != null && value.length < 8
                                ? 'Ingrese un mínimo de 8 caracteres'
                                : null,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.vpn_key, color: Colors.grey),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                hintText: 'Escribe tu contraseña',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025, bottom: MediaQuery.of(context).size.height * 0.05),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) => const ForgotPasswordScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        '¿Olvidaste la contraseña?',
                                        style: TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.underline),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        // if (!alreadyHaveAccount!) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) => SignUpScreen(isSupervisor: widget.isSupervisor),
                                            ),
                                          );
                                        // } else {
                                        //   showDialog(
                                        //     context: context,
                                        //     builder: (_) => Dialog(
                                        //       insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                                        //       child: SizedBox(
                                        //         height: MediaQuery.of(context).size.height * 0.5,
                                        //         child: AlertDialogPopup(
                                        //           text: "Ya te has registrado",
                                        //           isVisible: true,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   );
                                        // }
                                      },
                                      child: const Text(
                                        'No tienes cuenta. Regístrate aquí',
                                        style: TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.underline),
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: MyButton(
                                name: "Entrar",
                                whenPress: (){
                                  login();
                                  // signIn();
                                },
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                            Align(
                              alignment: Alignment.centerRight,
                              child: HelpButton(widget: const LoginPopup()),
                            )
                          ],
                        ),
                      ),
                    ),
                    // Center(child: Text(AppLocalizations.of(context).name, style: const TextStyle(color: Colors.black))),
                  ],
                ),
              ),
              if (isLoading)
                const Loader(),
              if (isSync)
                const SyncDialogPopup()
            ]
          ),
        ),
      );
    });
  }

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if(!isValid){
      showDialog(
          context: context,
          builder: (_) => Dialog(
            insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: AlertPopup(title: "Identificación\nIncorrecta",text: "El usuario o clave no es correcto.\nSi no lo recuerda haga click en Volver y en\n¿Olvidaste la contraseña?", isVisible: true,),
            ),
          )
      );
      return;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator())
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (_) => Dialog(
            insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: AlertPopup(title: "Identificación\nIncorrecta",text: "El usuario o clave no es correcto.\nSi no lo recuerda haga click en Volver y en\n¿Olvidaste la contraseña?", isVisible: true,),
            ),
          )
      );
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
