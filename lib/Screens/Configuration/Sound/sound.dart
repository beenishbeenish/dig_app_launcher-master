import 'package:dig_app_launcher/Popup/sound_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/Sound/configure_bluetooth.dart';
import 'package:dig_app_launcher/Screens/Configuration/Sound/set_ringtone.dart';
import 'package:dig_app_launcher/Screens/Configuration/Sound/set_volume.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';

class SoundScreen extends StatefulWidget {

  String? elderlyId, userRole;
  int? volume;
  bool? isBluetooth;
  SoundScreen({Key? key, this.elderlyId, this.volume, this.isBluetooth, this.userRole}) : super(key: key);

  @override
  State<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {

  String? elderlyId, userRole;

  @override
  void initState() {
    userRole = widget.userRole;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarLogo(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.1),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.09, vertical: MediaQuery.of(context).size.height * 0.05
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Inicio > Sonido',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1.5,
                  color: const Color(0xffD0D0D0),
                  endIndent: MediaQuery.of(context).size.width * 0.2,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.09, right: MediaQuery.of(context).size.width * 0.08,
              bottom: MediaQuery.of(context).size.height * 0.12
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Image.asset('assets/images/volume_speaker.png')
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(5),
                        backgroundColor: const Color(0xffF5F5F5),
                        shape: RoundedRectangleBorder( //to set border radius to button
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => SetVolumeScreen(elderlyId: widget.elderlyId, volume: widget.volume, isBluetooth: widget.isBluetooth),
                          ),
                        ).then((value) {
                          if(userRole == 'administrator') {
                            requestGetSpecificElderly(widget.elderlyId!).then((value) {
                              if(value != null && value.status == true){
                                setState(() {
                                  widget.volume = value.data.userVolume;
                                });
                              }
                            });
                          }
                        });
                      },
                      child: const Text(
                        'Modificar volumen',
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.015),
                  child: Row(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Image.asset('assets/images/sonos_speaker.png')
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(5),
                          backgroundColor: const Color(0xffF5F5F5),
                          shape: RoundedRectangleBorder( //to set border radius to button
                            borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const SetRingtoneScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Hacer sonar',
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Image.asset('assets/images/bluetooth.png')
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(5),
                        backgroundColor: const Color(0xffF5F5F5),
                        shape: RoundedRectangleBorder( //to set border radius to button
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const ConfigureBluetoothScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Configurar bluetooth',
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: MyButton(
              name: "Volver",
              whenPress: (){
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07, right: MediaQuery.of(context).size.width * 0.1),
            child: Align(
              alignment: Alignment.centerRight,
              child: HelpButton(widget: const SoundPopup()),
            ),
          )
        ],
      ),
    );
  }
}