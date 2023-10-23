import 'dart:io';
import 'dart:typed_data';

import 'package:dig_app_launcher/APIModel/upload_contact_response.dart';
import 'package:dig_app_launcher/Helper/DBModels/contacts_model.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddFavourite/ContactsBloc/contacts_bloc.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../../APIModel/get_specific_elderly_request.dart';
import '../../../Utils/app_global.dart';

class AddFavoriteContactManuallyScreen extends StatefulWidget {
  final int selectedContactIndex;
  final String elderlyId;
  final List<FavoriteContactModel?> phoneContacts;
  const AddFavoriteContactManuallyScreen({Key? key, required this.elderlyId, required this.phoneContacts, required this.selectedContactIndex}) : super(key: key);

  @override
  State<AddFavoriteContactManuallyScreen> createState() => _AddFavoriteContactManuallyScreenState();
}

class _AddFavoriteContactManuallyScreenState extends State<AddFavoriteContactManuallyScreen> {

  final formKey = GlobalKey<FormState>();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  bool saveVisible = false;
  File? selectedImage;
  bool voiceCallChecked = false;
  bool whatsappChecked = false;
  bool videoCallChecked = false;
  List<FavoriteContactModel> contacts = [];
  bool isLoading = false;

  late ContactsBloc _contactsBloc;
  RequestContactsDetail? requestContactsDetail;

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    _contactsBloc = BlocProvider.of<ContactsBloc>(context);
    for(var contact in widget.phoneContacts){
      if(contact!=null){
        contacts.add(contact);
      }
    }
    _contactsBloc.add(GetAllContactsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactsBloc, ContactsState>(
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
          Navigator.pop(context);
        }
        else if (state is GetAllContactsDetailState) {
          requestContactsDetail = state.contactsDetail;
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
                      top: MediaQuery.of(context).size.height * 0.02, bottom: MediaQuery.of(context).size.height * 0.015
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
                            'Inicio > Favoritos',
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
                  Column(
                    children: [
                      InkWell(
                        onTap: (){
                          _pickImage();
                        },
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.height * 0.07,
                          backgroundColor: const Color(0xffF4F4F4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: selectedImage != null?
                            Image.file(selectedImage!) :
                            const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            )
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.015),
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
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            checkColor: kColorPrimary,
                                            fillColor: MaterialStateColor.resolveWith((states) {
                                              if (states.contains(MaterialState.selected)) {
                                                return Colors.white; // the color when checkbox is selected;
                                              }
                                              return const Color(0xffA8A8A8); //the color when checkbox is unselected;
                                            }),
                                            value: voiceCallChecked,
                                            onChanged: (value) {
                                              setState(() {
                                                voiceCallChecked = value!;
                                              });
                                            },
                                          ),
                                          const Text(
                                            'Llamar',
                                            style: TextStyle(fontSize: 17, color: Colors.black),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Checkbox(
                                            checkColor: kColorPrimary,
                                            fillColor: MaterialStateColor.resolveWith((states) {
                                              if (states.contains(MaterialState.selected)) {
                                                return Colors.white; // the color when checkbox is selected;
                                              }
                                              return const Color(0xffA8A8A8); //the color when checkbox is unselected;
                                            }),
                                            value: videoCallChecked,
                                            onChanged: (value) {
                                              setState(() {
                                                videoCallChecked = value!;
                                              });
                                            },
                                          ),
                                          const Text(
                                            'Videollamada',
                                            style: TextStyle(fontSize: 17, color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        checkColor: kColorPrimary,
                                        fillColor: MaterialStateColor.resolveWith((states) {
                                          if (states.contains(MaterialState.selected)) {
                                            return Colors.white; // the color when checkbox is selected;
                                          }
                                          return const Color(0xffA8A8A8); //the color when checkbox is unselected;
                                        }),
                                        value: whatsappChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            whatsappChecked = value!;
                                          });
                                        },
                                      ),
                                      const Text(
                                        'Whatsapp',
                                        style: TextStyle(fontSize: 17, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                  saveVisible? SizedBox(height: MediaQuery.of(context).size.height * 0.01): const SizedBox(height: 0),
                  Center(
                    child: MyButton(
                      name: "Guardar",
                      whenPress: (){
                        List<FavoriteContactModel?> allContacts = [];
                        List<Photo?> allPhotos = [];
                        if (requestContactsDetail?.contactsDetailList != null) {
                          // allContacts.addAll(requestContactsDetail!.contactsDetailList!.map((contact) {
                          //   PhoneNumber? phoneNumber;
                          //   phoneNumber = PhoneNumber(contact.personPhoneNumber, '');
                          //   return PhoneContact(contact.personName, phoneNumber);
                          // }).toList());

                          allPhotos.addAll(requestContactsDetail!.contactsDetailList!.map((contactPhoto) =>
                          contactPhoto.personImage != null ? Photo(contactPhoto.personImage!) : null));
                        }

                        if (formKey.currentState!.validate() && contactNameController.text.isNotEmpty && contactNumberController.text.isNotEmpty) {
                          PhoneNumber? phoneNumber;
                          phoneNumber = PhoneNumber(contactNumberController.text, '');
                          // ElderlyFavoritesContacts newContact = PhoneContact(contactNameController.text, phoneNumber);
                          FavoriteContactModel newContact = FavoriteContactModel(personName: contactNameController.text, personImage: '', personPhoneNumber: contactNameController.text, isVideo: false, isVoice: false, isWhatsApp: false, elderlyId: '', id: '');


                          Uint8List? imageBytes;
                          if (selectedImage != null) {
                            imageBytes = selectedImage!.readAsBytesSync();
                          }
                          else {
                            imageBytes = null;
                          }

                          allContacts.addAll([newContact]);
                          if (imageBytes != null) {
                            allPhotos.addAll([Photo(imageBytes)]);
                          }

                          FavoriteContactModel mContact = FavoriteContactModel(personName: contactNameController.text, personImage: '', personPhoneNumber: contactNumberController.text, isVideo: videoCallChecked, isVoice: voiceCallChecked, isWhatsApp: whatsappChecked, elderlyId: widget.elderlyId, id: '');
                          try{
                            contacts[widget.selectedContactIndex] = mContact;
                          }catch(e){
                            print(e);
                            contacts.add(mContact);
                          }
                          updateContacts(contacts);


                          // _contactsBloc.add(SaveContactsDetailEvent(allContacts, allPhotos, whatsappChecked.toString(), voiceCallChecked.toString(), videoCallChecked.toString()));
                        }
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
                  SizedBox(height: MediaQuery.of(context).size.height*0.05,)
                ],
              ),
            ),
            isLoading?
                const Loader(): const SizedBox()
          ],

        ),
      );
    });
  }

  void updateContacts(List<FavoriteContactModel> contacts) async{
    setState(() {
      isLoading = true;
    });
    UploadContactResponse response = await uploadContacts(contacts);
    setState(() {
      isLoading = false;
    });
    if(response.status){
      String role = await AppGlobal().getUserRole() ?? '';
      if(role == 'elderly'){
        _contactsBloc.add(SaveContactsDetailEvent(response.data));
      }else{
        Navigator.of(context).pop(response.data);
      }

    }else{
      Fluttertoast.showToast(msg: response.message);
    }
  }
}