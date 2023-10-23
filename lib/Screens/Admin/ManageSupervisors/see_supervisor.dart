import 'package:dig_app_launcher/APIModel/get_supervisors_request.dart';
import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Popup/see_supervisor_popup.dart';
import 'package:dig_app_launcher/Screens/Admin/ManageSupervisors/add_supervisor.dart';
import 'package:dig_app_launcher/Screens/Admin/ManageSupervisors/delete_supervisor_permission.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Widgets/admin_menu_button.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/name_with_icon_button.dart';
import 'package:flutter/material.dart';

class SeeSupervisorScreen extends StatefulWidget {

  String elderlyId;
  SeeSupervisorScreen({Key? key, required this.elderlyId}) : super(key: key);

  @override
  State<SeeSupervisorScreen> createState() => _SeeSupervisorScreenState();
}

class _SeeSupervisorScreenState extends State<SeeSupervisorScreen> {

  bool isLoading = true;
  List<String> supervisorEmails = [];
  List<bool> supervisorIsAcceptedList = [];
  GetSupervisorsRequest? apiResponse;

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      apiResponse = await requestGetSupervisors();
      print("API Response: $apiResponse");
      if (apiResponse != null) {
        supervisorEmails = apiResponse!.data.supervisor.map((supervisor) => supervisor.userEmail).toList();

        supervisorIsAcceptedList.clear();
        for (var supervisor in apiResponse!.data.supervisor) {
          supervisorIsAcceptedList.add(supervisor.isAccepted);
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.22),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05,
                    top: MediaQuery.of(context).size.height * 0.02
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05, left: MediaQuery.of(context).size.width * 0.05),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: supervisorEmails.length,
                            itemBuilder: (ctx, index) {
                              final supervisorEmail = supervisorEmails[index];
                              final isAccepted = supervisorIsAcceptedList[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${index+1}. $supervisorEmail",
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                  if (!isAccepted)
                                  const Text(
                                    '    Pte. confirmar',
                                    style: TextStyle(fontSize: 16, color: Colors.red),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                  Row(
                                    children: [
                                      const Text(
                                        '    ',
                                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black, decoration: TextDecoration.underline),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) => DeleteSupervisorPermissionScreen(email: supervisorEmail, elderlyId: widget.elderlyId),
                                            )
                                          ).then((value) {
                                            requestGetSupervisors().then((response) {
                                              setState(() {
                                                apiResponse = response;
                                                if (apiResponse != null) {
                                                  supervisorEmails = apiResponse!.data.supervisor.map((supervisor) => supervisor.userEmail).toList();
                                                }
                                              });
                                            }).whenComplete(() {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            });
                                          });
                                        },
                                        child: const Text(
                                          'Eliminar',
                                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black, decoration: TextDecoration.underline),
                                        ),
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width * 0.075),
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            isLoading = true;
                                          });
                                          requestSendAdminInvite(supervisorEmail, widget.elderlyId).then((value) {
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
                                              isLoading = false;
                                            });
                                          });
                                        },
                                        child: const Text(
                                          'Reenviar invitación',
                                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black, decoration: TextDecoration.underline),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                          ),
                        ),
                      ),
                      Center(
                        child: NameWithIconButton(
                          whenPress: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => AddSupervisorScreen(elderlyId: widget.elderlyId),
                              ),
                            ).then((value) {
                              requestGetSupervisors().then((response) {
                                setState(() {
                                  apiResponse = response;
                                  if (apiResponse != null) {
                                    supervisorEmails = apiResponse!.data.supervisor.map((supervisor) => supervisor.userEmail).toList();
                                  }
                                });
                              }).whenComplete(() {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            });
                          },
                          name: "Añadir Supervisor",
                          icon: Icons.add_circle_outline,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.035),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: HelpButton(widget: const SeeSupervisorPopup()),
                        ),
                      )
                    ],
                  ),
                ),
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