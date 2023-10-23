import 'package:dig_app_launcher/Screens/Authentication/login.dart';
import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:flutter/material.dart';

class AdministratorInvitationPopup extends StatefulWidget {
  const AdministratorInvitationPopup({Key? key}) : super(key: key);

  @override
  State<AdministratorInvitationPopup> createState() => _AdministratorInvitationPopupState();
}

class _AdministratorInvitationPopupState extends State<AdministratorInvitationPopup> {
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
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05, bottom: MediaQuery.of(context).size.height * 0.0075),
                  child: const Text(
                    'Administrador',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const Text(
                  'Invitación',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.0075, bottom: MediaQuery.of(context).size.height * 0.025),
                  child: const Text(
                    'Si quiere que otra persona administre la configuración del dispositivo introduzca el email del administrador.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.justify,
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