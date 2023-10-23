import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Popup/alert_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddFavourite/ContactsBloc/contacts_bloc.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Widgets/appbar.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/user_menu_button.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {

  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );

  bool saveVisible = false;
  bool isLoading = true;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController keyController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _getStoredUserInfo() async {
    final getUserName = await storage.read(key: 'name');
    final getEmail = await storage.read(key: 'email');
    final getPassword = await storage.read(key: 'password');

    if (getUserName != null) {
      nameController.text = getUserName;
    }
    if (getEmail != null) {
      emailController.text = getEmail;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getStoredUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: Scaffold(
        appBar: Appbar(onSOSPress: true, onInicioPress: true),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.08,
                  top: MediaQuery.of(context).size.height * 0.02
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        UserMenuButton(onMyAccountPress: false, onAdministratorPress: true, onConfigurationPress: true),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Inicio > Mi cuenta',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 1,
                      thickness: 1.5,
                      color: const Color(0xffD0D0D0),
                      indent: MediaQuery.of(context).size.width * 0.29,
                      endIndent: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03, bottom: MediaQuery.of(context).size.height * 0.03),
                            child: Align(
                              alignment: Alignment.center,
                              child: Visibility(
                                visible: saveVisible,
                                child: const Text(
                                  'Datos guardados',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff408022)),
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.black),
                            textInputAction: TextInputAction.next,
                            validator: (name) =>
                            name == null || name.isEmpty
                                ? 'Introduce un nombre válido'
                                : null,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30),
                            ],
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person, color: Colors.grey),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Nombre Completo',
                              hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.black),
                            textInputAction: TextInputAction.next,
                            readOnly: true,
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
                              hintText: 'Correo electrónico',
                              hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                          TextFormField(
                            controller: keyController,
                            style: const TextStyle(color: Colors.black),
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                            value != null && value.length < 8
                                ? 'Ingrese un mínimo de 8 caracteres'
                                : null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.star, color: Colors.grey),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Clave actual',
                              hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                          TextFormField(
                            controller: passwordController,
                            style: const TextStyle(color: Colors.black),
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                            value != null && value.length < 8
                                ? 'Ingrese un mínimo de 8 caracteres'
                                : null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.star, color: Colors.grey),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Nueva clave',
                              hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                          TextFormField(
                            controller: confirmPasswordController,
                            style: const TextStyle(color: Colors.black),
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                            value != null && value.length < 8
                                ? 'Ingrese un mínimo de 8 caracteres'
                                : null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.star, color: Colors.grey),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Confirmar nueva clave',
                              hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          Center(
                            child: MyButton(
                              name: "Guardar",
                              whenPress: () async {
                                final storedPassword = await storage.read(key: 'password');
                                if (storedPassword == keyController.text) {
                                  if (passwordController.text == confirmPasswordController.text) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    requestUpdateUserAccount(nameController.text, emailController.text, keyController.text, passwordController.text).then((value) async {
                                      if(value != null && value.status == true){
                                        final updatedName = nameController.text;
                                        await storage.write(key: 'name', value: updatedName);
                                        await storage.write(key: 'password', value: passwordController.text);
                                        setState(() {
                                          saveVisible = true;
                                        });
                                      }
                                    }).whenComplete(() {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
                                  }
                                  else{
                                    showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                                        child: SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.5,
                                          child: AlertDialogPopup(
                                            text: "Contraseña y Confirmar contraseña no coinciden",
                                            isVisible: true,
                                          ),
                                        ),
                                      )
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
                                            text: "La clave no coincide con la clave real",
                                            isVisible: true,
                                          ),
                                        ),
                                      )
                                  );
                                }
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                          Visibility(
                            visible: saveVisible,
                            child: Center(
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  width: MediaQuery.of(context).size.width * 0.65,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xffCBF357),
                                      shape: RoundedRectangleBorder( //to set border radius to button
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Volver inicio",
                                      style: TextStyle(fontSize: 18, color: Colors.black),
                                    ),
                                  ),
                                )
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          // const Align(
                          //   alignment: Alignment.centerRight,
                          //   child: HelpButton(),
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              const Loader(),
          ]
        ),
      ),
    );
  }
}