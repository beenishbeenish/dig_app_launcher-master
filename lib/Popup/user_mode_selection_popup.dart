import 'package:dig_app_launcher/Screens/Authentication/login.dart';
import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserModeSelectionPopup extends StatefulWidget {
  const UserModeSelectionPopup({Key? key}) : super(key: key);

  @override
  State<UserModeSelectionPopup> createState() => _UserModeSelectionPopupState();
}

class _UserModeSelectionPopupState extends State<UserModeSelectionPopup> {

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
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Ayuda',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                const Text(
                  '¿Quieres supervisar a alguien?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                  child: const Text(
                    'Acceso para administradores y supervisores. Para iniciar sesión tienes que ser invitado por un ABU o ADMINISTRADOR.',
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                ),
                const Text(
                  'Puedes acceder aquí:',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                  child: SizedBox(
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
                          MaterialPageRoute(builder: (context) => LoginScreen(isSupervisor: true)),
                              (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text(
                        '¿Quieres supervisar a alguien?',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Lo voy a usar yo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                  child: const Text(
                    'La aplicación solo estará instalada en el móvil del ABU. Posteriormente podrá convertila para que sea administrada por la persona que desee.',
                    style: TextStyle(fontSize: 17, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const Text(
                  'Puedes acceder aquí:',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                  child: SizedBox(
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