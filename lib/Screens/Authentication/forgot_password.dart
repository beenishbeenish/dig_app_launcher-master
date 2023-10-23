import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Screens/Authentication/forgot_password_otp.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:dig_app_launcher/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
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
                        top: MediaQuery.of(context).size.height * 0.03
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Indique su correo electrónico\npara restablecer la contraseña',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                          TextFormField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.emailAddress,
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
                                hintText: 'Introducir el email con el que te registraste',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 12)
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.03),
                            child: const Text(
                              'Si el email existe en nuestro sistema, enviaremos un código al email facilitado con la nueva contraseña',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Text(
                            'Si no lo has recibido comprueba la bandeja spam o contactar con nosotros.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.075),
                  Center(
                    child: MyButton(
                      name: "Enviar",
                      whenPress: (){
                        // resetPassword();
                        if(formKey.currentState!.validate() && emailController.text.isNotEmpty){
                          setState(() {
                            isLoading = true; // Set the isLoading variable to true to show the loader
                          });
                          requestForgotPassOTP(emailController.text).then((value) {
                            if(value?.status == true) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => ForgotPasswordOTPScreen(email: emailController.text),
                                ),
                              );
                            }
                            else {
                              showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                                    child: SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.5,
                                      child: AlertDialogPopup(
                                        text: "El correo electrónico no existe",
                                        isVisible: true,
                                      ),
                                    ),
                                  )
                              );
                            }
                          }).whenComplete(() {
                            setState(() {
                              isLoading = false; // Set the isLoading variable to false to hide the loader
                            });
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const Loader(),
          ]
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator())
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

}