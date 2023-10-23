import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Popup/alert_popup.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangeConfigurationPasswordScreen extends StatefulWidget {
  const ChangeConfigurationPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangeConfigurationPasswordScreen> createState() => _ChangeConfigurationPasswordScreenState();
}

class _ChangeConfigurationPasswordScreenState extends State<ChangeConfigurationPasswordScreen> {

  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );

  bool saveVisible = false;

  final formKey = GlobalKey<FormState>();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.035),
                    child: const Text(
                      'Configuración\nCambiar contraseña',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
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
                          controller: currentPasswordController,
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
                            hintText: 'Clave actual',
                            hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        TextFormField(
                          controller: newPasswordController,
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
                            whenPress: () async {
                              if (formKey.currentState!.validate()) {
                                final currentConfigPassword = currentPasswordController.text;
                                final newConfigPassword = newPasswordController.text;
                                final confirmConfigPassword = confirmPasswordController.text;

                                final storedPassword = await storage.read(key: 'configPassword');
                                if (storedPassword == currentConfigPassword){
                                  if (newConfigPassword == confirmConfigPassword) {
                                    await storage.write(key: 'configPassword', value: newConfigPassword);
                                    setState(() {
                                      saveVisible = true;
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
                                else {
                                  showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                      insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                                      child: SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.75,
                                        child: AlertPopup(
                                          title: "Identificación\nIncorrecta",
                                          text: "El clave actual no es correcto.",
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
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Center(
                          child: MyButton(
                            name: "Volver",
                            whenPress: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),
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