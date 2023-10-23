import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Widgets/admin_menu_button.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';

class SupervisorInvitationErrorScreen extends StatefulWidget {

  String email, elderlyId;
  SupervisorInvitationErrorScreen({Key? key, required this.email, required this.elderlyId}) : super(key: key);

  @override
  State<SupervisorInvitationErrorScreen> createState() => _SupervisorInvitationErrorScreenState();
}

class _SupervisorInvitationErrorScreenState extends State<SupervisorInvitationErrorScreen> {

  bool isLoading = false;

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
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07),
                  child: const Text(
                    '¡Error!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff408022)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.025),
                  child: const Text(
                    'No ha sido posible enviar la invitación',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Text(
                  'Inténtelo de nuevo',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03, bottom: MediaQuery.of(context).size.height * 0.075),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF5F5F5),
                      shape: RoundedRectangleBorder( //to set border radius to button
                          borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      requestSendAdminInvite(widget.email, widget.elderlyId).then((value) {
                        if(value != null && value.status){

                        }
                        else {

                        }
                      }).whenComplete(() {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    },
                    child: const Text(
                      'Reenviar invitación',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
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
          )
        ],
      ),
    );
  }
}