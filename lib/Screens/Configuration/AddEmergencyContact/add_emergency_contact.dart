import 'dart:convert';

import 'package:dig_app_launcher/Helper/DBModels/emergency_contacts_model.dart';
import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Popup/delete_emergency_contact_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddEmergencyContact/EmergencyContactsBloc/emergency_contacts_bloc.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddEmergencyContact/add_contact_manually.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Utils/app_global.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmergencyContactScreen extends StatefulWidget {

  const EmergencyContactScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyContactScreen> createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {

  final List<PhoneContact?> _phoneContacts = List.filled(4, null);
  final List<Photo?> _contactPhotos = List.filled(4, null);

  // List<PhoneContact?> savedContacts = List.filled(4, null);
  // List<Photo?> savedPhotos = List.filled(4, null);

  bool saveVisible = false;
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
    setContact(contact, index);

  }

  setContact(FullContact contact, int index){
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
      // Update savedContacts if the contact is already saved
      // if (index < savedContacts.length) {
      //   savedContacts[index] = _phoneContacts[index];
      //   savedPhotos[index] = _contactPhotos[index];
      // }
    });
  }

  void removeContact(int index) {
    setState(() {
      _phoneContacts[index] = null;
      // Update savedContacts when a contact is removed
      // if (index < savedContacts.length) {
      //   savedContacts[index] = null;
      //   savedPhotos[index] = null;
      // }
    });
  }

  @override
  void initState() {
    _emergencyContactsBloc = BlocProvider.of<EmergencyContactsBloc>(context);
    _emergencyContactsBloc.add(GetAllEmergencyContactsEvent());
    // savedContacts = requestEmergencyContactsDetail?.emergencyContactsDetailList?.map((contact) => PhoneContact(contact.personName, contact.personPhoneNumber as PhoneNumber?)).toList() ?? [];
    // savedPhotos = requestEmergencyContactsDetail?.emergencyContactsDetailList?.map((contactPhoto) => contactPhoto.personImage as Photo?).toList() ?? [];
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
          saveVisible = true;
        }
        else if (state is GetAllEmergencyContactsDetailState) {
          requestEmergencyContactsDetail = state.emergencyContactsDetail;
        }
      }, builder: (context, state) {
      return Scaffold(
        appBar: const AppbarLogo(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.1),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.09, right: MediaQuery.of(context).size.width * 0.08,
                        top: MediaQuery.of(context).size.height * 0.02, bottom: MediaQuery.of(context).size.height * 0.025
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Inicio > SOS',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1.5,
                          color: const Color(0xffD0D0D0),
                          endIndent: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ],
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.1
                    ),
                    itemCount: _phoneContacts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final PhoneContact? contact = _phoneContacts[index];
                      final bool isContactSaved = requestEmergencyContactsDetail?.emergencyContactsDetailList != null &&
                          index < requestEmergencyContactsDetail!.emergencyContactsDetailList!.length;
                      return Column(
                        children: [
                          isContactSaved && requestEmergencyContactsDetail!.emergencyContactsDetailList![index].personName.isNotEmpty?
                          Text(
                            requestEmergencyContactsDetail!.emergencyContactsDetailList![index].personName,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                          ) :
                          Text(
                            contact == null ? 'SOS ${index + 1}' : (contact.fullName ?? '').toString(),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: isContactSaved? (){} : () async {
                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(builder: (BuildContext context,
                                      StateSetter setState /*You can rename this!*/) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 18, left: 18, right: 18),
                                      child: SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.15,
                                        child: Wrap(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10,bottom: 10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      await selectContact(index).then((value) {
                                                        saveVisible = false;
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: Row(
                                                      children: const [
                                                        Icon(Icons.contacts, color: Colors.black),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          'Desde el libro de contactos',
                                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                                                  InkWell(
                                                    onTap: (){
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (ctx) => AddEmergencyContactManuallyScreen(onAdded: (FullContact addedContact) {
                                                            saveVisible = false;
                                                            setContact(addedContact, index);
                                                          },),
                                                        ),
                                                      ).then((value) {
                                                        // _emergencyContactsBloc.add(GetAllEmergencyContactsEvent());
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: Row(
                                                      children: const [
                                                        Icon(Icons.contact_page_outlined, color: Colors.black),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          'Agregar manualmente',
                                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                },
                              );
                            },
                            child: isContactSaved && requestEmergencyContactsDetail != null && requestEmergencyContactsDetail!.emergencyContactsDetailList!.isNotEmpty?
                            Stack(
                                children: [
                                  CircleAvatar(
                                      radius: MediaQuery.of(context).size.height * 0.06,
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
                                    right:1,
                                    top: 1,
                                    child: InkWell(
                                      child: const Icon(
                                          Icons.cancel,
                                          color: Colors.black
                                      ),
                                      onTap: () {
                                        setState(() {
                                          saveVisible = false;
                                          showDialog(
                                              context: context,
                                              builder: (_) => Dialog(
                                                insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.075, right: MediaQuery.of(context).size.width * 0.075),
                                                child: SizedBox(
                                                  height: MediaQuery.of(context).size.height * 0.4,
                                                  child: DeleteEmergencyContactPopup(name: requestEmergencyContactsDetail!.emergencyContactsDetailList![index].personName, emergencyContactsDetail: requestEmergencyContactsDetail, index: index),
                                                ),
                                              )
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                ]
                            ) :
                            contact == null ?
                            CircleAvatar(
                              radius: MediaQuery.of(context).size.height * 0.06,
                              backgroundColor: const Color(0xffF4F4F4),
                              child: const Icon(Icons.add),
                            ) :
                            Stack(
                                children: [
                                  CircleAvatar(
                                      radius: MediaQuery.of(context).size.height * 0.06,
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
                                    right: 1,
                                    top: 1,
                                    child: InkWell(
                                      child: const Icon(
                                          Icons.cancel,
                                          color: Colors.black
                                      ),
                                      onTap: () {
                                        setState(() {
                                          saveVisible = false;
                                          showDialog(
                                              context: context,
                                              builder: (_) => Dialog(
                                                insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.075, right: MediaQuery.of(context).size.width * 0.075),
                                                child: SizedBox(
                                                  height: MediaQuery.of(context).size.height * 0.4,
                                                  child: DeleteEmergencyContactPopup(name: requestEmergencyContactsDetail!.emergencyContactsDetailList![index].personName, emergencyContactsDetail: requestEmergencyContactsDetail, index: index),
                                                ),
                                              )
                                          );
                                        });
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Visibility(
                    visible: saveVisible,
                    child: Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.035,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff6ECB42),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Cambios Guardados',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  saveVisible? SizedBox(height: MediaQuery.of(context).size.height * 0.02): SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Center(
                    child: MyButton(
                      name: "Guardar",
                      whenPress: !saveVisible && _phoneContacts.isNotEmpty? (){
                        List<PhoneContact?> allContacts = [];
                        List<Photo?> allPhotos = [];

                        if (requestEmergencyContactsDetail?.emergencyContactsDetailList != null) {
                          allContacts.addAll(requestEmergencyContactsDetail!.emergencyContactsDetailList!.map((contact) {
                            PhoneNumber? phoneNumber;
                            phoneNumber = PhoneNumber(contact.personPhoneNumber, '');
                            return PhoneContact(contact.personName, phoneNumber);
                          }).toList());

                          allPhotos.addAll(requestEmergencyContactsDetail!.emergencyContactsDetailList!.map((contactPhoto) =>
                          contactPhoto.personImage != null ? Photo(contactPhoto.personImage!) : null));
                        }

                        // Add the contacts from the phoneContacts list
                        allContacts.addAll(_phoneContacts.where((contact) => contact != null));
                        allPhotos.addAll(_contactPhotos);

                        bool isContactSelected = _phoneContacts.any((contact) => contact != null);

                        if (isContactSelected) {
                          setState(() {
                            isLoading = true;
                          });

                          List<Map<String, String>> emergencyContacts = [];
                          for (int i = 0; i < _phoneContacts.length; i++) {
                            String name = _phoneContacts[i]?.fullName.toString() ?? '';
                            String phoneNumber = _phoneContacts[i]?.phoneNumber?.number.toString() ?? '';
                            if(name.isEmpty || phoneNumber.isEmpty){
                              continue;
                            }
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
                              _emergencyContactsBloc.add(SaveEmergencyContactsDetailEvent(allContacts, allPhotos));
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
                  SizedBox(height: MediaQuery.of(context).size.height*0.05,)
                ],
              ),
            ),
            if (isLoading)
              const Loader(),
          ]
        ),
      );
    });
  }
}