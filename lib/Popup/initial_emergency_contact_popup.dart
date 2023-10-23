import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:flutter/material.dart';

class InitialEmergencyContactPopup extends StatefulWidget {
  const InitialEmergencyContactPopup({Key? key}) : super(key: key);

  @override
  State<InitialEmergencyContactPopup> createState() => _InitialEmergencyContactPopupState();
}

class _InitialEmergencyContactPopupState extends State<InitialEmergencyContactPopup> {
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
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
                  child: const Text(
                    'SOS',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.0075),
                  child: const Text(
                    'PASO 3',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05),
                  child: const Text(
                    'Tiene que seleccionar como mínimo 1 persona como llamada SOS.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const Text(
                  'Cuando se pulsa el siguiente botón se realizan las siguientes acciones: con las personas seleccionadas como SOS:',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01, bottom: MediaQuery.of(context).size.height * 0.025),
                  child: const Text(
                    '1. Se activa la llamada automática.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const Text(
                  '2. Se envía automáticamente la\n     ubicación por SMS.',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'SOS',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Container(
                        height: 60,
                        child: Image.asset('assets/images/heartbeat.png'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}