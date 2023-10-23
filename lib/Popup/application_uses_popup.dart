import 'package:dig_app_launcher/Screens/UserModeSelection/user_mode_selection.dart';
import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationUsesPopup extends StatefulWidget {
  const ApplicationUsesPopup({Key? key}) : super(key: key);

  @override
  State<ApplicationUsesPopup> createState() => _ApplicationUsesPopupState();
}

class _ApplicationUsesPopupState extends State<ApplicationUsesPopup> {
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.075),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Ayuda',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const Center(
                  child: Text(
                    'Usos de la aplicación',
                    style: TextStyle(fontSize: 17, color: Colors.black, fontStyle: FontStyle.italic),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.075),
                const Text(
                  'Acceder a la aplicación',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
                const Text(
                  'Modo real. Validate y disfruta de\ntodas las ventajas de Digabú.',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColorPrimary,
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                const Text(
                  'Ver demo',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
                const Text(
                  'Te enseñamos en un vídeo todo lo\nque puedes hacer con Digabú',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      style: TextStyle(fontSize: 20, color: Colors.black),
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