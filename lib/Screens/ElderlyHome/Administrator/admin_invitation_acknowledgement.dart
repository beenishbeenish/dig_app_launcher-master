import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Utils/app_global.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:dig_app_launcher/Widgets/user_menu_button.dart';
import 'package:flutter/material.dart';

class AdminInvitationAcknowledgementScreen extends StatefulWidget {

  String email;
  AdminInvitationAcknowledgementScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<AdminInvitationAcknowledgementScreen> createState() => _AdminInvitationAcknowledgementScreenState();
}

class _AdminInvitationAcknowledgementScreenState extends State<AdminInvitationAcknowledgementScreen> {

  bool isLoading = false;
  String? elderlyId;

  void getUserID() async {
    AppGlobal appGlobal = AppGlobal();
    elderlyId = await appGlobal.retrieveId();
  }

  @override
  void initState() {
    super.initState();
    getUserID(); // Call the function to get the user ID when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarLogo(),
      body: Stack(
        children: [
          Column(
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
                        UserMenuButton(onMyAccountPress: true, onAdministratorPress: true, onConfigurationPress: false),
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
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Inicio > Administrador',
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
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                      child: const Text(
                        '¡Invitación enviada!',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.025),
                      child: const Text(
                        'Se ha enviado un email al administrador/a que tiene que confirmar.',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Text(
                      'Una vez confirmado tiene que descargar la app y registrarse con el email al cual le has invitado.',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.025),
                      child: Text(
                        'Email admin: ${widget.email}',
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.065,
                      width: MediaQuery.of(context).size.width * 0.55,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff8A8A8A), // Border color
                          width: 1, // Border width
                        ),
                        borderRadius: BorderRadius.circular(8), // Border radius if needed
                      ),
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

                          requestSendAdminInvite(widget.email, elderlyId!).then((value) {
                            if(value != null && value.status){
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: AlertDialogPopup(
                                      text: "Invitación reenviada con éxito",
                                      isVisible: true,
                                    ),
                                  ),
                                )
                              );
                            }
                            else{
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: AlertDialogPopup(
                                      text: "El envío de la invitación falló",
                                      isVisible: true,
                                    ),
                                  ),
                                )
                              );
                            }
                          }).whenComplete(() {
                            setState(() {
                              isLoading = false; // Set the isLoading variable to false to hide the loader
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
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          if (isLoading)
            const Loader(),
        ]
      ),
    );
  }
}