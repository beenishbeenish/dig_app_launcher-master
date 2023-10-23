import 'package:dig_app_launcher/Widgets/admin_menu_button.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';

class SupervisorInvitationAcknowledgementScreen extends StatefulWidget {

  String email;
  SupervisorInvitationAcknowledgementScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<SupervisorInvitationAcknowledgementScreen> createState() => _SupervisorInvitationAcknowledgementScreenState();
}

class _SupervisorInvitationAcknowledgementScreenState extends State<SupervisorInvitationAcknowledgementScreen> {

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
                    AdminMenuButton(onMyAccountPress: true, onSupervisorsPress: false),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.54,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                            child: InkWell(
                              onTap: (){
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Inicio > Supervisores',
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
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.05),
                  child: const Text(
                    'Invitación enviada',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff408022)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.025),
                  child: const Text(
                    'Se ha enviado un email al administrador que tiene que confirmar.',
                    style: TextStyle(fontSize: 17, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Text(
                  'Una vez confirmado tiene que descargar la app y registrarse con el email al cual le has invitado.',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025, bottom: MediaQuery.of(context).size.height * 0.04),
                  child: Text(
                    'Email admin: ${widget.email}',
                    style: TextStyle(fontSize: 17, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: MyButton(
                    name: "Volver",
                    whenPress: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}