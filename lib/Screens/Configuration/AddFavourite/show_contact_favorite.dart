import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dig_app_launcher/APIModel/get_specific_elderly_request.dart';
import 'package:dig_app_launcher/APIModel/upload_contact_response.dart';
import 'package:dig_app_launcher/Helper/DBModels/contacts_model.dart';
import 'package:dig_app_launcher/Popup/show_contact_favorite_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddFavourite/ContactsBloc/contacts_bloc.dart';
import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:dig_app_launcher/Widgets/name_with_icon_button.dart';
import 'package:dig_app_launcher/body/add_favorite_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../APIModel/login_request.dart';
import '../../../Utils/api_services.dart';
import '../../../Utils/app_global.dart';
import '../../../Utils/internet_checker.dart';

class ContactFavoriteDetailScreen extends StatefulWidget {


  int selectedContactIndex;
  RequestContactsDetail? contactsDetail;
  final FavoriteContactModel contact;
  final String elderlyId;
  final List<FavoriteContactModel?> phoneContacts;
  ContactFavoriteDetailScreen({Key? key, required this.selectedContactIndex, this.contactsDetail, required this.elderlyId, required this.contact, required this.phoneContacts, }) : super(key: key);

  @override
  State<ContactFavoriteDetailScreen> createState() => _ContactFavoriteDetailScreenState();
}

class _ContactFavoriteDetailScreenState extends State<ContactFavoriteDetailScreen> {

  bool voiceCallChecked = false;
  bool whatsappChecked = false;
  bool videoCallChecked = false;
  late FavoriteContactModel contact;
  bool saveVisible = false;
  List<FavoriteContactModel?> phoneContacts = [];

  bool isLoading = false;

  late ContactsBloc _contactsBloc;
  RequestContactsDetail? requestContactsDetail;

  @override
  void initState() {
    _contactsBloc = BlocProvider.of<ContactsBloc>(context);
    contact = widget.contact;
    phoneContacts = widget.phoneContacts;
    print("Contact : $contact");
    // contact = widget.phoneContacts.first;
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
          Navigator.of(context).pop();
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
                      top: MediaQuery.of(context).size.height * 0.02
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
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.09, right: MediaQuery.of(context).size.width * 0.08,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.star_border,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  Text(
                                    // "",
                                    // widget.phoneContacts[widget.selectedContactIndex]!.fullName.toString(),
                                    contact != null? contact!.personName.toString() : '',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, bottom: MediaQuery.of(context).size.height * 0.01),
                                  child: Text(
                                    // '',
                                    contact != null? contact!.personPhoneNumber : '',
                                    // widget.phoneContacts[widget.selectedContactIndex]!.phoneNumber!.number.toString(),
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
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
                                      value: voiceCallChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          voiceCallChecked = value!;
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Llamar',
                                      style: TextStyle(fontSize: 18, color: Colors.black),
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
                                      style: TextStyle(fontSize: 18, color: Colors.black),
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
                                      style: TextStyle(fontSize: 18, color: Colors.black),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                  // widget.phoneContact != null?
                  Center(
                    child: NameWithIconButton(
                      whenPress: (){
                        String elerlyId;
                        FavoriteContactModel mContact = FavoriteContactModel(personName: contact.personName, personImage: contact.personImage, personPhoneNumber: contact.personPhoneNumber, isVideo: videoCallChecked, isVoice: voiceCallChecked, isWhatsApp: whatsappChecked, elderlyId: '', id: '');
                        uploadContact(mContact).then((value){

                        });
                        // List<FavoriteContactModel?> allContacts = [];
                        // List<Photo?> allPhotos = [];
                        //
                        // if (requestContactsDetail?.contactsDetailList != null) {
                        //   // allContacts.addAll(requestContactsDetail!.contactsDetailList!.map((contact) {
                        //   //   PhoneNumber? phoneNumber;
                        //   //   phoneNumber = PhoneNumber(contact.personPhoneNumber, '');
                        //   //   return PhoneContact(contact.personName, phoneNumber);
                        //   // }).toList());
                        //
                        //   allPhotos.addAll(requestContactsDetail!.contactsDetailList!.map((contactPhoto) =>
                        //   contactPhoto.personImage != null ? Photo(contactPhoto.personImage!) : null));
                        // }
                        //
                        // // Add the contacts from the phoneContacts list
                        // allContacts.addAll(widget.phoneContact.where((contact) => contact != null));
                        // allPhotos.addAll(widget.contactPhoto);
                        //
                        // // Save the contacts

                      },
                      name: "Guardar",
                      icon: Icons.add_circle_outline,
                    ),
                  ) ,
                  //     :
                  // Center(
                  //   child: NameWithIconButton(
                  //     whenPress: (){
                  //       _contactsBloc.add(DeleteSpecificContactEvent(contactDetail: widget.contactsDetail!, index: widget.selectedContactIndex));
                  //       widget.contactsDetail!.contactsDetailList!.removeAt(widget.selectedContactIndex);
                  //     },
                  //     name: "Eliminar favorito",
                  //     icon: Icons.remove_circle_outline,
                  //   ),
                  // ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  Center(
                    child: MyButton(
                      name: "Volver",
                      whenPress: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05, right: MediaQuery.of(context).size.width * 0.08),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: HelpButton(widget: const ShowContactFavoritePopup()),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.05,)
                ],
              ),
            ),
            if(isLoading)
              const Loader()
          ],
        ),
      );
    });
  }

  //----------------- Upload Contact -----------------
  Future<UploadContactResponse?> uploadContact(FavoriteContactModel mContact) async {

    setState(() {
      isLoading = true;
    });

    UploadContactResponse? result;
    bool isInternetAvailable = await CommonUtil().checkInternetConnection();
    print('Adding Data');
    phoneContacts[widget.selectedContactIndex] = mContact;
    List<FavoriteContactModel> bodyContacts = [];
    for(var contact in phoneContacts){
      if(contact!=null){
        bodyContacts.add(contact);
      }
    }

    final elderlyId = await AppGlobal().retrieveId();
    AddFavoriteBody body = AddFavoriteBody(elderlyId: elderlyId, favoritesContacts: bodyContacts);


    final url = Uri.parse('${AppGlobal.baseUrl}elderly-favorites-contacts');
    print(url);
    print(jsonEncode(body));
    final accessToken = await AppGlobal().accessToken();
    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );
    print('Response: ${response}');
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      result = UploadContactResponse.fromJson(responseData);
      if(result.status){
        String role = await AppGlobal().getUserRole() ?? '';
        if(role == 'elderly'){
          _contactsBloc.add(SaveContactsDetailEvent(result.data));
        }else{
          Navigator.of(context).pop(result.data);
        }

      }else{
        setState(() {
          isLoading=false;
        });
        print(result.message);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('Response is failed : ${response.statusCode}');
    }

    if (isInternetAvailable){
      try{

      } catch (e) {
        log('Exception: ${e.toString()}');
      }
      return result;
    } else {
      print("No internet Coneection");
    }
  }
}