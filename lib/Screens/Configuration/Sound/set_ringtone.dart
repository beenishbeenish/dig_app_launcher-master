import 'package:dig_app_launcher/Popup/sound_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/Sound/configure_bluetooth.dart';
import 'package:dig_app_launcher/Screens/Configuration/Sound/set_volume.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:volume_controller/volume_controller.dart';

class SetRingtoneScreen extends StatefulWidget {
  const SetRingtoneScreen({Key? key}) : super(key: key);

  @override
  State<SetRingtoneScreen> createState() => _SetRingtoneScreenState();
}

class _SetRingtoneScreenState extends State<SetRingtoneScreen> {

  double _volumeListenerValue = 0;
  double _getVolume = 0;
  double _setVolumeValue = 0;

  Future<void> getVolume() async {
    _getVolume = await VolumeController().getVolume();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Listen to system volume change
    VolumeController().listener((volume) {
      setState(() {
        _volumeListenerValue = volume;
      });
    });
    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
    getVolume();
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
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
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.09, right: MediaQuery.of(context).size.width * 0.08,
                top: MediaQuery.of(context).size.height * 0.05, bottom: MediaQuery.of(context).size.height * 0.05
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
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
                bottom: MediaQuery.of(context).size.height * 0.15
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Image.asset('assets/images/volume_speaker.png')
                    ),
                    Transform(
                      transform: Matrix4.translationValues(-15, 0, 0.0),
                      child: Slider(
                        min: 0,
                        max: 1,
                        onChanged: (double value) {
                          _setVolumeValue = value;
                          VolumeController().setVolume(_setVolumeValue);
                          setState(() {});
                        },
                        value: _setVolumeValue,
                      ),
                    ),
                    Text(
                      '${(_setVolumeValue * 10).toInt()}',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
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
        ],
      ),
    );
  }
}