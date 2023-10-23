import 'package:dig_app_launcher/Popup/setting_permission_popup.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/Settings/enter_config_password.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/Settings/set_new_password.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/user_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingPermissionScreen extends StatefulWidget {
  const SettingPermissionScreen({Key? key}) : super(key: key);

  @override
  State<SettingPermissionScreen> createState() => _SettingPermissionScreenState();
}

class _SettingPermissionScreenState extends State<SettingPermissionScreen> {

  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
    )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarLogo(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.2),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.06, right: MediaQuery.of(context).size.width * 0.05,
                top: MediaQuery.of(context).size.height * 0.02
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    UserMenuButton(onMyAccountPress: true, onAdministratorPress: false, onConfigurationPress: true),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                            child: InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Inicio > Configuración',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 1,
                  thickness: 1.5,
                  color: const Color(0xffD0D0D0),
                  indent: MediaQuery.of(context).size.width * 0.29,
                  endIndent: MediaQuery.of(context).size.width * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06, bottom: MediaQuery.of(context).size.height * 0.06),
                  child: const Text(
                    'Configuración desactivada',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const Text(
                  'Para activar la configuración\ntiene que establecer una clave',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF5F5F5),
                          shape: RoundedRectangleBorder( //to set border radius to button
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                        onPressed: () async {
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
                                builder: (ctx) => const SetNewPasswordScreen(),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'SÍ',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF5F5F5),
                          shape: RoundedRectangleBorder( //to set border radius to button
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'NO',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1, right: MediaQuery.of(context).size.width * 0.05),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: HelpButton(widget: const SettingPermissionPopup()),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}