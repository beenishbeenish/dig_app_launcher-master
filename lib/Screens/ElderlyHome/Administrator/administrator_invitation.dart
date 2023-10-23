import 'package:dig_app_launcher/Popup/administrator_invitation_popup.dart';
import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/Administrator/admin_invitation_acknowledgement.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Utils/app_global.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:dig_app_launcher/Widgets/user_menu_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class AdministratorInvitationScreen extends StatefulWidget {
  const AdministratorInvitationScreen({Key? key}) : super(key: key);

  @override
  State<AdministratorInvitationScreen> createState() => _AdministratorInvitationScreenState();
}

class _AdministratorInvitationScreenState extends State<AdministratorInvitationScreen> {

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();
  bool isLoading = false;
  String? elderlyId;

  void getUserID() async {
    AppGlobal appGlobal = AppGlobal();
    elderlyId = await appGlobal.retrieveId();
    print('Elderly Id: $elderlyId');
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
          SingleChildScrollView(
            child: Column(
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
                          'Invite al administrador/a',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.025),
                        child: const Text(
                          'Introduzca el correo electrónico del administrador/a',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: emailController,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'Introduzca un correo electrónico válido'
                                  : null,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email, color: Colors.grey),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                hintText: 'Introduzca correo electrónico',
                                hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                            TextFormField(
                              controller: confirmEmailController,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'Introduzca un correo electrónico válido'
                                  : null,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email, color: Colors.grey),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                hintText: 'Confirme correo electrónico',
                                hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                            Center(
                              child: MyButton(
                                name: "Enviar",
                                whenPress: (){
                                  if (emailController.text == confirmEmailController.text){
                                    setState(() {
                                      isLoading = true;
                                    });
                                    requestSendAdminInvite(emailController.text, elderlyId!).then((value) {
                                      if(value != null && value.status){
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) => AdminInvitationAcknowledgementScreen(email: emailController.text),
                                          ),
                                        );
                                      }
                                    }).whenComplete(() {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
                                  }
                                  else{
                                    showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                                        child: SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.5,
                                          child: AlertDialogPopup(
                                            text: "Correo electrónico y Confirmar correo electrónico no coinciden",
                                            isVisible: true,
                                          ),
                                        ),
                                      )
                                    );
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04, right: MediaQuery.of(context).size.width * 0.05),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: HelpButton(widget: const AdministratorInvitationPopup()),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (isLoading)
            const Loader(),
        ]
      ),
    );
  }
}