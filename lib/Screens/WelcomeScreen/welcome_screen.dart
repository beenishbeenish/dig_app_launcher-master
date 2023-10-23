import 'package:dig_app_launcher/Popup/application_uses_popup.dart';
import 'package:dig_app_launcher/Screens/UserModeSelection/user_mode_selection.dart';
import 'package:dig_app_launcher/Utils/app_images.dart';
import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
                child: ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.22),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.06),
                child: SvgPicture.asset(
                  AppImages.logo,
                  height: MediaQuery.of(context).size.height * 0.11,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Column(
            children: [
              const Text(
                'Bienvenido a Digabú',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const Text(
                '“slogan”',
                style: TextStyle(fontSize: 18, color: Colors.black, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kColorPrimary,
                    shape: RoundedRectangleBorder( //to set border radius to button
                      borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('firstLaunch', false);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const UserModeSelectionScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Acceder a la aplicación',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffCBF357),
                    shape: RoundedRectangleBorder( //to set border radius to button
                      borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                  onPressed: (){
                    Fluttertoast.showToast(
                      msg: "Estará disponible pronto",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  child: const Text(
                    '¡Ver demo!',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.075),
              Padding(
                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.075),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: HelpButton(widget: const ApplicationUsesPopup()),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}