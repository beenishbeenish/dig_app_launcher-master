import 'package:dig_app_launcher/Helper/db_helper.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/Administrator/administrator_invitation.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/MyAccount/my_account.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/Settings/enter_config_password.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/Settings/setting_permission.dart';
import 'package:dig_app_launcher/Screens/UserModeSelection/user_mode_selection.dart';
import 'package:dig_app_launcher/Utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserMenuButton extends StatelessWidget {

  bool onMyAccountPress;
  bool onConfigurationPress;
  bool onAdministratorPress;


  UserMenuButton({Key? key, required this.onMyAccountPress, required this.onConfigurationPress, required this.onAdministratorPress}) : super(key: key);

  final Uri _urlPrivacyPolicy = Uri.parse('http://digabu.es/policy');
  final Uri _urlFAQ = Uri.parse('http://digabu.es/faq');

  Future<void> _launchPrivacyPolicy() async {
    if (!await launchUrl(_urlPrivacyPolicy)) {
      throw Exception('Could not launch $_urlPrivacyPolicy');
    }
  }

  Future<void> _launchFAQ() async {
    if (!await launchUrl(_urlFAQ)) {
      throw Exception('Could not launch $_urlFAQ');
    }
  }

  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.24,
      height: MediaQuery.of(context).size.height * 0.055,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xffF5F5F5),
        border: Border.all(
          color: const Color(0xffA8A8A8)
        )
      ),
      child: PopupMenuButton<String>(
        color: const Color(0xffF5F5F5),
        offset: Offset(0, MediaQuery.of(context).size.height * 0.055),
        child: Row(
          children: const [
            Text(
              " Menú",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Icon(Icons.arrow_drop_down_outlined, color: Colors.black,)
          ],
        ),
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
              value: '1',
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04, bottom: 7),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: onMyAccountPress? (){
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const MyAccountScreen(),
                            )
                          );
                        } : (){},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: SvgPicture.asset(
                                AppImages.userAccount,
                                height: MediaQuery.of(context).size.height * 0.03,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Mi cuenta',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: const Color(0xffD0D0D0),
                        endIndent: MediaQuery.of(context).size.width * 0.25,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: '2',
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    InkWell(
                      onTap: onConfigurationPress? () async {
                        Navigator.pop(context);
                        final value = await storage.read(key: 'configPassword');
                        if (value != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const EnterConfigPasswordScreen(),
                            ),
                          );
                        }
                        else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const SettingPermissionScreen(),
                            )
                          );
                        }
                      } : (){},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: SvgPicture.asset(
                              AppImages.starRating,
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Configuración',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: const Color(0xffD0D0D0),
                      endIndent: MediaQuery.of(context).size.width * 0.25,
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: '3',
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    InkWell(
                      onTap: onAdministratorPress? (){
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const AdministratorInvitationScreen(),
                          )
                        );
                      } : (){},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: SvgPicture.asset(
                              AppImages.eye,
                              height: MediaQuery.of(context).size.height * 0.018,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Administrador',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: const Color(0xffD0D0D0),
                      endIndent: MediaQuery.of(context).size.width * 0.25,
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: '4',
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        _launchPrivacyPolicy();
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: SvgPicture.asset(
                              AppImages.privacy,
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Privacidad',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: const Color(0xffD0D0D0),
                      endIndent: MediaQuery.of(context).size.width * 0.25,
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: '5',
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        _launchFAQ();
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: SvgPicture.asset(
                              AppImages.faq,
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Ayuda',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: const Color(0xffD0D0D0),
                      endIndent: MediaQuery.of(context).size.width * 0.25,
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: '6',
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05, top: 7),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('IsLogin', false);
                          final dbHelper = DatabaseHelper.instance;
                          await dbHelper.clearLetterSize();
                          await dbHelper.clearContacts();
                          await dbHelper.clearEmergencyContacts();
                          await dbHelper.clearSound();
                          await dbHelper.clearMedicine();
                          await dbHelper.clearLeisure();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const UserModeSelectionScreen()
                            ), (Route<dynamic> route) => false
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(bottom: 3),
                              child: Icon(Icons.logout_outlined, color: Colors.black),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Cerrar sesión',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: const Color(0xffD0D0D0),
                        endIndent: MediaQuery.of(context).size.width * 0.25,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Add more items as needed
          ];
        },
        onSelected: (String value) {
          // Handle item selection
        },
      ),
    );
  }
}
