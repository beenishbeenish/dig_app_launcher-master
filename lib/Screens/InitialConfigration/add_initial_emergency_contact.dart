import 'dart:async';
import 'dart:convert';

import 'package:dig_app_launcher/Helper/DBModels/emergency_contacts_model.dart';
import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Popup/initial_emergency_contact_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddEmergencyContact/EmergencyContactsBloc/emergency_contacts_bloc.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/elderly_home.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Utils/app_global.dart';
import 'package:dig_app_launcher/Widgets/appbar.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class InitialEmergencyContactScreen extends StatefulWidget {
  const InitialEmergencyContactScreen({Key? key}) : super(key: key);

  @override
  State<InitialEmergencyContactScreen> createState() => _InitialEmergencyContactScreenState();
}

class _InitialEmergencyContactScreenState extends State<InitialEmergencyContactScreen> {

  final List<PhoneContact?> _phoneContacts = List.filled(1, null);
  final List<Photo?> _contactPhotos = List.filled(1, null);
  String storedId = '';
  AppGlobal appGlobal = AppGlobal();

  bool isLoading = false;

  late EmergencyContactsBloc _emergencyContactsBloc;
  RequestEmergencyContactsDetail? requestEmergencyContactsDetail;

  Future<void> retrieveStoredId() async {
    String id = await appGlobal.retrieveId();
    setState(() {
      storedId = id;
    });
    print('storedId: $storedId');
  }

  Future<void> selectContact(int index) async {
    final FullContact contact = await FlutterContactPicker.pickFullContact();
    setState(() {
      if (contact.phones.isNotEmpty) {
        final String firstName = contact.name!.firstName ?? "";
        final String lastName = contact.name!.lastName ?? "";
        _contactPhotos[index] = contact.photo;
        _phoneContacts[index] = PhoneContact('$firstName $lastName', contact.phones.first);
      } else {
        _phoneContacts[index] = null;
        _contactPhotos[index] = null;
      }
    });
  }

  void removeContact(int index) {
    setState(() {
      _phoneContacts[index] = null;
    });
  }

  // List<AppInfo> installedApps = [];

  // Future<void> _sendApps() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   List<AppInfo> apps = await InstalledApps.getInstalledApps(true, true);
  //   setState(() {
  //     installedApps = apps;
  //   });
  //
  //   List<Map<String, String>> getApps = [];
  //   for (int i = 0; i < installedApps.length; i++) {
  //     String appName =  installedApps[i].name  ?? '';
  //     String appUrl = installedApps[i].packageName ?? '';
  //     String appImage = installedApps[i].icon != null ? base64Encode(installedApps[i].icon!) : '';
  //
  //     Map<String, String> leisureMap = {
  //       'appName': appName,
  //       'appUrl': appUrl,
  //       'appImage': appImage,
  //     };
  //     getApps.add(leisureMap);
  //   }
  //
  //   print("Apps: ${getApps.length}");
  //   requestSendAllInstalledApps(getApps, storedId).whenComplete(() {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder: (context) => ElderlyHomeScreen(elderlyId: storedId)
  //       ), (Route<dynamic> route) => false
  //     );
  //   });
  // }

  @override
  void initState() {
    _emergencyContactsBloc = BlocProvider.of<EmergencyContactsBloc>(context);
    _emergencyContactsBloc.add(GetAllEmergencyContactsEvent());
    retrieveStoredId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmergencyContactsBloc, EmergencyContactsState>(
      listener: (context, state) {
        if (state is LoadingState) {}
        else if (state is ErrorState) {
          Fluttertoast.showToast(
            msg: state.error,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey.shade400,
            textColor: Colors.white,
            fontSize: 12.0
          );
        }
        else if (state is RefreshScreenState) {}
        else if (state is DataStoredState) {
          // _sendApps();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => ElderlyHomeScreen(elderlyId: storedId)
            ), (Route<dynamic> route) => false
          );
        }
        else if (state is GetAllEmergencyContactsDetailState) {
          requestEmergencyContactsDetail = state.emergencyContactsDetail;
        }
      }, builder: (context, state) {
      return Scaffold(
        appBar: Appbar(onSOSPress: false, onInicioPress: false),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.09, right: MediaQuery.of(context).size.width * 0.08,
                    top: MediaQuery.of(context).size.height * 0.02, bottom: MediaQuery.of(context).size.height * 0.025
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Paso 3 de 3 - SOS',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1.5,
                        color: const Color(0xffD0D0D0),
                        endIndent: MediaQuery.of(context).size.width * 0.1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                          ),
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            final PhoneContact? contact = _phoneContacts[index];
                            final bool isContactSaved = requestEmergencyContactsDetail?.emergencyContactsDetailList != null &&
                                index < requestEmergencyContactsDetail!.emergencyContactsDetailList!.length;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isContactSaved && requestEmergencyContactsDetail!.emergencyContactsDetailList![index].personName.isNotEmpty?
                                Text(
                                  requestEmergencyContactsDetail!.emergencyContactsDetailList![index].personName,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                ) :
                                Text(
                                  contact == null ? 'SOS ${index + 1}' : (contact.fullName ?? '').toString(),
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                                InkWell(
                                  onTap: () async {
                                    await selectContact(index);
                                  },
                                  child: isContactSaved && requestEmergencyContactsDetail != null && requestEmergencyContactsDetail!.emergencyContactsDetailList!.isNotEmpty?
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: MediaQuery.of(context).size.height * 0.09,
                                        backgroundColor: const Color(0xffF4F4F4),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: requestEmergencyContactsDetail!.emergencyContactsDetailList![index].personImage != null ?
                                          Image.memory(
                                              requestEmergencyContactsDetail!.emergencyContactsDetailList![index].personImage!
                                          ) :
                                          const Icon(
                                              Icons.person,
                                              size: 40,
                                              color: Colors.grey
                                          ),
                                        )
                                      ),
                                      Positioned(
                                        left: 85,
                                        bottom: 85,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.black
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              requestEmergencyContactsDetail!.emergencyContactsDetailList!.removeAt(index);
                                            });
                                          },
                                        ),
                                      ),
                                    ]
                                  ) :
                                  contact == null ?
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.height * 0.09,
                                    backgroundColor: const Color(0xffF4F4F4),
                                    child: const Icon(Icons.add),
                                  ) :
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: MediaQuery.of(context).size.height * 0.09,
                                        backgroundColor: const Color(0xffF4F4F4),
                                        child: _contactPhotos[index] == null ?
                                        Icon(
                                          Icons.person,
                                          size: 40,
                                          color: _contactPhotos[index] == null ? Colors.grey : Colors.transparent
                                        ) :
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: Image.memory(_contactPhotos[index]!.bytes)
                                        )
                                      ),
                                      Positioned(
                                        left: 85,
                                        bottom: 85,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.black
                                          ),
                                          onPressed: () {
                                            removeContact(index);
                                          },
                                        ),
                                      ),
                                    ]
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1.5,
                  color: const Color(0xffD0D0D0),
                  indent: MediaQuery.of(context).size.width * 0.15,
                  endIndent: MediaQuery.of(context).size.width * 0.15,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Center(
                  child: MyButton(
                    name: "Finalizar",
                    whenPress: _phoneContacts.isNotEmpty? (){
                      bool isContactSelected = _phoneContacts.any((contact) => contact != null);

                      if (isContactSelected) {
                        setState(() {
                          isLoading = true;
                        });

                        List<Map<String, String>> emergencyContacts = [];
                        for (int i = 0; i < _phoneContacts.length; i++) {
                          String name = _phoneContacts[i]?.fullName.toString() ?? '';
                          String phoneNumber = _phoneContacts[i]?.phoneNumber?.number.toString() ?? '';
                          String base64Image = _contactPhotos[i] != null
                              ? base64Encode(_contactPhotos[i]!.bytes)
                              : '';

                          Map<String, String> contactMap = {
                            'personName': name,
                            'personPhoneNumber': phoneNumber,
                            'personImage': base64Image,
                          };
                          emergencyContacts.add(contactMap);
                        }

                        requestAddEmergencyContact(emergencyContacts, storedId).then((value) {
                          if(value != null && value.status == true) {
                            _emergencyContactsBloc.add(SaveEmergencyContactsDetailEvent(_phoneContacts, _contactPhotos));
                          }
                          else{
                            showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: AlertDialogPopup(
                                      text: "El contacto no se está guardando. Comprueba tu conexión a Internet e inténtalo de nuevo.",
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
                      }
                      else{
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: AlertDialogPopup(
                                text: "Seleccione contacto SOS",
                                isVisible: false,
                              ),
                            ),
                          )
                        );
                      }
                    } : (){},
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Center(
                  child: MyButton(
                    name: "Volver",
                    whenPress: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.075),
                Padding(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.08),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: HelpButton(widget: const InitialEmergencyContactPopup()),
                  ),
                )
              ],
            ),
            if (isLoading)
              const Loader(),
          ]
        ),
      );
    });
  }
}