import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dig_app_launcher/Helper/DBModels/emergency_contacts_model.dart';
import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddEmergencyContact/EmergencyContactsBloc/emergency_contacts_bloc.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddEmergencyContactManuallyScreen extends StatefulWidget {

  final Function(FullContact addedContact) onAdded;

 const AddEmergencyContactManuallyScreen({Key? key, required this.onAdded}) : super(key: key);

  @override
  State<AddEmergencyContactManuallyScreen> createState() => _AddEmergencyContactManuallyScreenState();
}

class _AddEmergencyContactManuallyScreenState extends State<AddEmergencyContactManuallyScreen> {

  final formKey = GlobalKey<FormState>();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  bool saveVisible = false;
  File? selectedImage;
  String storedId = '';
  bool isLoading = false;


  late EmergencyContactsBloc _emergencyContactsBloc;
  RequestEmergencyContactsDetail? requestEmergencyContactsDetail;

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> retrieveStoredId() async {
    String id = await appGlobal.retrieveId();
    setState(() {
      storedId = id;
    });
    print('storedId: $storedId');
  }

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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (){
                            _pickImage();
                          },
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.height * 0.08,
                            backgroundColor: const Color(0xffF4F4F4),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: selectedImage != null?
                                Image.file(
                                    selectedImage!,
                                    fit: BoxFit.contain
                                ) :
                                const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey,
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Form(
                          key: formKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.07),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: contactNameController,
                                  style: const TextStyle(color: Colors.black),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (name) {
                                    if(name == null || name.isEmpty) {
                                      return 'Enter a valid Name';
                                    }
                                    else if(name.length >= 24) {
                                      return 'Enter max 24 characters';
                                    }
                                    else{
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: SizedBox(),
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),
                                    hintText: 'nombre de la persona',
                                    hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                                TextFormField(
                                  controller: contactNumberController,
                                  style: const TextStyle(color: Colors.black),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  validator: (name) {
                                    if(name == null || name.isEmpty) {
                                      return 'Enter a valid Name';
                                    }
                                    else if(name.length >= 20) {
                                      return 'Enter max 20 characters';
                                    }
                                    else{
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: SizedBox(),
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),
                                    hintText: 'número de persona',
                                    hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                      name: "Siguiente",
                      whenPress: (){
                        if (formKey.currentState!.validate() && contactNameController.text.isNotEmpty && contactNumberController.text.isNotEmpty){
                          PhoneNumber number = PhoneNumber(contactNumberController.text, '');
                          StructuredName name = StructuredName(contactNameController.text,'','','');
                          Photo? photo;
                          if (selectedImage != null) {
                            Uint8List imageBytes = selectedImage!.readAsBytesSync();
                            photo = Photo(imageBytes);
                          }
                          FullContact contact = FullContact([], [], [number], [], name , photo, '', '', '', [], []);
                          widget.onAdded(contact);
                          Navigator.pop(context);
                        }
                        // List<PhoneContact?> allContacts = [];
                        // List<Photo?> allPhotos = [];
                        // if (requestEmergencyContactsDetail?.emergencyContactsDetailList != null) {
                        //   allContacts.addAll(requestEmergencyContactsDetail!.emergencyContactsDetailList!.map((contact) {
                        //     PhoneNumber? phoneNumber;
                        //     phoneNumber = PhoneNumber(contact.personPhoneNumber, '');
                        //     return PhoneContact(contact.personName, phoneNumber);
                        //   }).toList());
                        //
                        //   allPhotos.addAll(requestEmergencyContactsDetail!.emergencyContactsDetailList!.map((contactPhoto) =>
                        //   contactPhoto.personImage != null ? Photo(contactPhoto.personImage!) : null));
                        // }
                        //
                        // if (formKey.currentState!.validate() && contactNameController.text.isNotEmpty && contactNumberController.text.isNotEmpty && allContacts.length < 4) {
                        //   PhoneNumber? phoneNumber;
                        //   phoneNumber = PhoneNumber(contactNumberController.text, '');
                        //   PhoneContact newContact = PhoneContact(contactNameController.text, phoneNumber);
                        //
                        //   Uint8List? imageBytes;
                        //   if (selectedImage != null) {
                        //     imageBytes = selectedImage!.readAsBytesSync();
                        //   }
                        //
                        //   allContacts.addAll([newContact]);
                        //   allPhotos.addAll([Photo(imageBytes!)]);
                        //
                        //   bool isContactSelected = allContacts.any((contact) => contact != null);
                        //
                        //   if (isContactSelected) {
                        //     setState(() {
                        //       isLoading = true;
                        //     });
                        //
                        //     List<Map<String, String>> emergencyContacts = [];
                        //
                        //     String name = contactNumberController.text;
                        //     String phoneNumber = contactNameController.text;
                        //     String base64Image = base64Encode(imageBytes);
                        //
                        //     Map<String, String> contactMap = {
                        //       'personName': name,
                        //       'personPhoneNumber': phoneNumber,
                        //       'personImage': base64Image,
                        //     };
                        //     emergencyContacts.add(contactMap);
                        //
                        //
                        //     requestAddEmergencyContact(emergencyContacts, storedId).then((value) {
                        //       if(value != null && value.status == true) {
                        //         _emergencyContactsBloc.add(SaveEmergencyContactsDetailEvent(allContacts, allPhotos));
                        //       }
                        //       else{
                        //         showDialog(
                        //             context: context,
                        //             builder: (_) => Dialog(
                        //               insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                        //               child: SizedBox(
                        //                 height: MediaQuery.of(context).size.height * 0.5,
                        //                 child: AlertDialogPopup(
                        //                   text: "El contacto no se está guardando. Comprueba tu conexión a Internet e inténtalo de nuevo.",
                        //                   isVisible: true,
                        //                 ),
                        //               ),
                        //             )
                        //         );
                        //       }
                        //     }).whenComplete(() {
                        //       setState(() {
                        //         isLoading = false;
                        //       });
                        //     });
                        //   }
                        //   else{
                        //     showDialog(
                        //         context: context,
                        //         builder: (_) => Dialog(
                        //           insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                        //           child: SizedBox(
                        //             height: MediaQuery.of(context).size.height * 0.5,
                        //             child: AlertDialogPopup(
                        //               text: "Seleccione contacto SOS",
                        //               isVisible: false,
                        //             ),
                        //           ),
                        //         )
                        //     );
                        //   }
                        // }
                      },
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