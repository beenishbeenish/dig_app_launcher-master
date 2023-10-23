import 'package:dig_app_launcher/Popup/user_mode_selection_popup.dart';
import 'package:dig_app_launcher/Screens/Authentication/login.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserModeSelectionScreen extends StatefulWidget {
  const UserModeSelectionScreen({Key? key}) : super(key: key);

  @override
  State<UserModeSelectionScreen> createState() => _UserModeSelectionScreenState();
}

class _UserModeSelectionScreenState extends State<UserModeSelectionScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarLogo(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.22),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: Column(
              children: [
                SizedBox(
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
                      // Fluttertoast.showToast(
                      //   msg: "Estará disponible pronto",
                      //   toastLength: Toast.LENGTH_SHORT,
                      //   gravity: ToastGravity.BOTTOM,
                      //   timeInSecForIosWeb: 1,
                      //   backgroundColor: Colors.grey,
                      //   textColor: Colors.white,
                      //   fontSize: 16.0,
                      // );
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(isSupervisor: true)
                        ), (Route<dynamic> route) => false
                      );
                    },
                    child: const Text(
                      '¿Quieres supervisar a alguien?',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                SizedBox(
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
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen(isSupervisor: false)),
                          (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text(
                      'Lo voy a usar yo',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Padding(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.075),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: HelpButton(widget: const UserModeSelectionPopup()),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}