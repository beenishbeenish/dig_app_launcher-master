import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';

class AlertDialogPopup extends StatefulWidget {

  bool isVisible;
  String text;
  AlertDialogPopup({Key? key, required this.isVisible, required this.text}) : super(key: key);

  @override
  State<AlertDialogPopup> createState() => _AlertDialogPopupState();
}

class _AlertDialogPopupState extends State<AlertDialogPopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Icon(
              Icons.warning_amber_rounded,
              color: kColorPrimary,
              size: MediaQuery.of(context).size.width *0.16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
              child: Text(
                widget.text,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            MyButton(
              name: "Volver",
              whenPress: (){
                Navigator.pop(context);
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
          ],
        ),
      ),
    );
  }
}