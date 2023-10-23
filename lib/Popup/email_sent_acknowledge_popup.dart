import 'package:dig_app_launcher/Screens/Authentication/otp_verification.dart';
import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:flutter/material.dart';

class EmailSentAcknowledgementPopup extends StatefulWidget {

  String name, email, password;
  EmailSentAcknowledgementPopup({Key? key, required this.name, required this.email, required this.password}) : super(key: key);

  @override
  State<EmailSentAcknowledgementPopup> createState() => _EmailSentAcknowledgementPopupState();
}

class _EmailSentAcknowledgementPopupState extends State<EmailSentAcknowledgementPopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: MediaQuery.of(context).size.height * 0.075,
        width: MediaQuery.of(context).size.width * 0.75,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorPrimary,
            shape: RoundedRectangleBorder( //to set border radius to button
                borderRadius: BorderRadius.circular(8)
            ),
          ),
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text(
            'Volver',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Ayuda',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06, bottom: MediaQuery.of(context).size.height * 0.0075),
                  child: const Text(
                    'Verifica tu email',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const Text(
                  'Se ha enviado un email al correo que nos ha facilitado con un código de verificación que tendrá que introducir en la siguiente pantalla.',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.05),
                  child: const Text(
                    'Si no lo ve en la bandeja de su correo mire en correo no deseado o spam.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const Text(
                  'Introduce el codigo de verificación pulsando aquí:',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.03),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF5F5F5),
                        shape: RoundedRectangleBorder( //to set border radius to button
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => OTPVerification(name: widget.name, email: widget.email, password: widget.password),
                          ),
                        );
                      },
                      child: const Text(
                        'Introducir código de verificación',
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}