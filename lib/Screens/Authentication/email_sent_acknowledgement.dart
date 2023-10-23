import 'package:dig_app_launcher/Popup/email_sent_acknowledge_popup.dart';
import 'package:dig_app_launcher/Screens/Authentication/otp_verification.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';

class EmailSentAcknowledgementScreen extends StatefulWidget {

  String name, email, password;
  EmailSentAcknowledgementScreen({Key? key, required this.name, required this.email, required this.password}) : super(key: key);

  @override
  State<EmailSentAcknowledgementScreen> createState() => _EmailSentAcknowledgementScreenState();
}

class _EmailSentAcknowledgementScreenState extends State<EmailSentAcknowledgementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarLogo(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.2),
          SizedBox(height: MediaQuery.of(context).size.height * 0.09),
          const Text(
            'Verifica tu email',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          const Text(
            'Hemos enviado un código al email facilitado',
            style: TextStyle(fontSize: 15, color: Color(0xff262626)),
          ),
          const Text(
            'en la pantalla anterior.',
            style: TextStyle(fontSize: 15, color: Color(0xff262626)),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          const Text(
            'Si no lo has recibido comprueba la bandeja',
            style: TextStyle(fontSize: 15, color: Color(0xff262626)),
          ),
          const Text(
            'spam o contactar con nosotros.',
            style: TextStyle(fontSize: 15, color: Color(0xff262626)),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          MyButton(
            name: "Introducir código",
            whenPress: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => OTPVerification(name: widget.name, email: widget.email, password: widget.password),
                ),
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.12),
          Padding(
            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
            child: Align(
              alignment: Alignment.centerRight,
              child: HelpButton(widget: EmailSentAcknowledgementPopup(name: widget.name, email: widget.email, password: widget.password)),
            ),
          )
        ],
      ),
    );
  }
}
