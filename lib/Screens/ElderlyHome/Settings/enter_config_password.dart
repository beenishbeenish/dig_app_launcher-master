import 'package:dig_app_launcher/Popup/alert_popup.dart';
import 'package:dig_app_launcher/Popup/enter_config_password_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/configuration_screen.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:dig_app_launcher/Widgets/user_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EnterConfigPasswordScreen extends StatefulWidget {
  const EnterConfigPasswordScreen({Key? key}) : super(key: key);

  @override
  State<EnterConfigPasswordScreen> createState() => _EnterConfigPasswordScreenState();
}

class _EnterConfigPasswordScreenState extends State<EnterConfigPasswordScreen> {

  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );

  final formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();

  Future<bool> _checkConfigrationCredentials(String configPassword) async {
    final storedPassword = await storage.read(key: 'configPassword');

    if(storedPassword != null) {
      return configPassword == storedPassword;
    }
    else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarLogo(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.2),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.06, right: MediaQuery.of(context).size.width * 0.05,
                top: MediaQuery.of(context).size.height * 0.02
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      UserMenuButton(onMyAccountPress: true, onAdministratorPress: false, onConfigurationPress: true),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.55,
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
                                  'Inicio > Configuración',
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04, bottom: MediaQuery.of(context).size.height * 0.05),
                    child: const Text(
                      'Introduzca su clave',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: passwordController,
                          style: const TextStyle(color: Colors.black),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                          value != null && value.length < 8
                              ? 'Enter min 8 characters'
                              : null,
                          decoration: const InputDecoration(
                            prefixIcon: SizedBox(),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            hintText: '',
                            hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                        Center(
                          child: MyButton(
                            name: "Entrar",
                            whenPress: () async {
                              if (formKey.currentState!.validate()) {
                                final configPassword = passwordController.text;
                                final isValid = await _checkConfigrationCredentials(configPassword);
                                if(isValid && passwordController.text.isNotEmpty) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => ConfigurationScreen(userRole: 'elderly', elderlyId: ''),
                                    )
                                  );
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
                                          text: "El clave no es correcto.",
                                          isVisible: false,
                                        ),
                                      ),
                                    )
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1, right: MediaQuery.of(context).size.width * 0.05),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: HelpButton(widget: const EnterConfigPasswordPopup()),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}