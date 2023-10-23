import 'dart:convert';

import 'package:dig_app_launcher/APIModel/add_favorites_request.dart';
import 'package:dig_app_launcher/APIModel/get_specific_elderly_request.dart';
import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Popup/allow_contact_medium_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddFavourite/ContactsBloc/contacts_bloc.dart';
import 'package:dig_app_launcher/Screens/InitialConfigration/add_initial_emergency_contact.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Utils/app_global.dart';
import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:dig_app_launcher/Widgets/appbar.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllowContactMediumScreen extends StatefulWidget {

  List<FavoriteContactModel> phoneContacts;
  List<Photo?> contactPhotos;
  AllowContactMediumScreen({Key? key, required this.phoneContacts, required this.contactPhotos}) : super(key: key);

  @override
  State<AllowContactMediumScreen> createState() => _AllowContactMediumScreenState();
}

class _AllowContactMediumScreenState extends State<AllowContactMediumScreen> {

  bool voiceCallChecked = false;
  bool whatsappChecked = false;
  bool videoCallChecked = false;
  late FavoriteContactModel? contact;
  String storedId = '';
  AppGlobal appGlobal = AppGlobal();

  bool isLoading = false;
  AddFavoritesRequest? addFavoritesRequest;
  
  late ContactsBloc _contactsBloc;

  Future<void> retrieveStoredId() async {
    String id = await appGlobal.retrieveId();
    setState(() {
      storedId = id;
    });
    print('storedId: $storedId');
  }

  @override
  void initState() {
    _contactsBloc = BlocProvider.of<ContactsBloc>(context);
    contact = widget.phoneContacts.first;
    retrieveStoredId();
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
        else if (state is DataStoredState) {}
      }, builder: (context, state) {
      return Stack(
        children: [
          Scaffold(
            appBar: Appbar(onSOSPress: false, onInicioPress: false),
            body: Column(
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
                        'Paso 2 de 3 - Favoritos',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1.5,
                        color: const Color(0xffD0D0D0),
                        endIndent: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.04),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.star_border,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                Text(
                                  contact!.personName,
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
                                  contact?.personPhoneNumber ?? '',
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
                Center(
                  child: MyButton(
                    name: "Siguiente",
                    whenPress: () {
                      setState(() {
                        isLoading = true;
                      });

                      List<String> personImage = widget.contactPhotos.map((photo) {
                        if (photo != null) {
                          String base64Image = base64Encode(photo.bytes);
                          return base64Image;
                        } else {
                          return '';
                        }
                      }).toList();

                      requestAddFavorites(contact?.personName ?? '', contact?.personPhoneNumber ?? '', personImage.toString(), voiceCallChecked, videoCallChecked, whatsappChecked, storedId).then((value) {
                        if(value != null && value.status == true){
                          _contactsBloc.add(SaveContactsDetailEvent(widget.phoneContacts));
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const InitialEmergencyContactScreen(),
                            ),
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
                    },
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Padding(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.08),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: HelpButton(widget: const AllowContactMediumPopup()),
                  ),
                )
              ],
            ),
          ),
          if (isLoading)
            const Loader(),
        ]
      );
    });
  }
}