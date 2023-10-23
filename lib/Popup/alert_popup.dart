import 'package:dig_app_launcher/Popup/invalid_login_popup.dart';
import 'package:dig_app_launcher/Utils/app_images.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AlertPopup extends StatefulWidget {

  bool isVisible;
  String title,text;
  AlertPopup({Key? key, required this.isVisible, required this.title, required this.text}) : super(key: key);

  @override
  State<AlertPopup> createState() => _AlertPopupState();
}

class _AlertPopupState extends State<AlertPopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
              child: SvgPicture.asset(
                AppImages.loginError,
                width: MediaQuery.of(context).size.width *0.16,
              ),
            ),
            Text(
              widget.text,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            MyButton(
              name: "Volver",
              whenPress: (){
                Navigator.pop(context);
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            Padding(
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05),
              child: Visibility(
                visible: widget.isVisible,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: HelpButton(widget: const InvalidLoginPopup()),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          ],
        ),
      ),
    );
  }
}