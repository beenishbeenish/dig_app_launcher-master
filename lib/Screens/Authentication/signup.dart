import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Popup/signup_popup.dart';
import 'package:dig_app_launcher/Screens/Authentication/email_sent_acknowledgement.dart';
import 'package:dig_app_launcher/Screens/Authentication/login.dart';
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
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {

  bool isSupervisor;
  SignUpScreen({Key? key, required this.isSupervisor}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void register() {
    if (formKey.currentState!.validate() && nameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty && EmailValidator.validate(emailController.text)) {
      final name = nameController.text;
      final email = emailController.text;
      final password = passwordController.text;

      setState(() {
        isLoading = true; // Show loader
      });

      requestSignUp(name, email, password).then((value) {
        if(value?.status == true) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => EmailSentAcknowledgementScreen(name: name, email: email, password: password),
            ),
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
                  text: "Ya existe el correo electrónico",
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
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
                        top: MediaQuery.of(context).size.height * 0.02
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'REGISTRARSE',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1.5,
                            color: const Color(0xffD0D0D0),
                            endIndent: MediaQuery.of(context).size.width * 0.2,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.black),
                            textInputAction: TextInputAction.next,
                            // autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                hintText: 'Indica tu nombre completo',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 13)
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.black),
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
                                hintText: 'Un email que uses',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 13)
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
                                prefixIcon: Icon(Icons.vpn_key, color: Colors.grey),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                hintText: 'Escribe una contraseña que recuerdes',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 13)
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02, bottom: MediaQuery.of(context).size.height * 0.04),
                              child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => LoginScreen(isSupervisor: widget.isSupervisor),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    '¿Ya tienes una cuenta? Iniciar sesión',
                                    style: TextStyle(fontSize: 15, color: Colors.black),
                                  )
                              ),
                            ),
                          ),
                          Center(
                            child: MyButton(
                              name: "Registrarme",
                              whenPress: (){
                                // signUp();
                                register();
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          Align(
                            alignment: Alignment.centerRight,
                            child: HelpButton(widget: SignUpPopup(isSupervisor: widget.isSupervisor)),
                          )
                        ],
                      ),
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

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator())
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}