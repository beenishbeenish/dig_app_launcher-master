import 'package:dig_app_launcher/Popup/alert_popup.dart';
import 'package:dig_app_launcher/Popup/set_new_password_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/configuration_screen.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({Key? key}) : super(key: key);

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {

  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );

  final formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _storeConfigrationCredentials(String configPassword, String configConfirmPassword) async {
    await storage.write(key: 'configPassword', value: configPassword);
    await storage.write(key: 'configConfirmPassword', value: configConfirmPassword);
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04, bottom: MediaQuery.of(context).size.height * 0.05),
                    child: const Text(
                      'Configuración\nAñada clave',
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
                              ? 'Ingrese un mínimo de 8 caracteres'
                              : null,
                          decoration: const InputDecoration(
                            prefixIcon: SizedBox(),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            hintText: 'Nueva clave',
                            hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                            prefixIcon: SizedBox(),
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
                            whenPress: (){
                              if (formKey.currentState!.validate() && passwordController.text.isNotEmpty && confirmPasswordController.text.isNotEmpty) {
                                if (passwordController.text == confirmPasswordController.text) {
                                  final configPassword = passwordController.text;
                                  final configConfirmPassword = confirmPasswordController.text;
                                  _storeConfigrationCredentials(configPassword, configConfirmPassword);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => ConfigurationScreen(userRole: 'elderly', elderlyId: ''),
                                    )
                                  );
                                }
                                else{
                                  showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                                        child: SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.55,
                                          child: AlertPopup(
                                            title: "Identificación\nIncorrecta",
                                            text: "Nueva clave y Confirmar nueva clave no coinciden",
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
                            child: HelpButton(widget: const SetNewPasswordPopup()),
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