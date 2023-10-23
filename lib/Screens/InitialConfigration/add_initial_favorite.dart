import 'dart:async';

import 'package:dig_app_launcher/APIModel/get_specific_elderly_request.dart';
import 'package:dig_app_launcher/Helper/DBModels/contacts_model.dart';
import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Popup/initial_favorite_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddFavourite/ContactsBloc/contacts_bloc.dart';
import 'package:dig_app_launcher/Screens/InitialConfigration/allow_contact_medium.dart';
import 'package:dig_app_launcher/Widgets/appbar.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InitialFavouriteScreen extends StatefulWidget {
  const InitialFavouriteScreen({Key? key}) : super(key: key);

  @override
  State<InitialFavouriteScreen> createState() => _InitialFavouriteScreenState();
}

class _InitialFavouriteScreenState extends State<InitialFavouriteScreen> {

  final List<FavoriteContactModel?> _phoneContacts = List.filled(1, null);
  final List<Photo?> _contactPhotos = List.filled(1, null);

  late ContactsBloc _contactsBloc;
  RequestContactsDetail? requestContactsDetail;

  Future<void> selectContact(int index) async {
    final FullContact contact = await FlutterContactPicker.pickFullContact();
    setState(() {
      if (contact.phones.isNotEmpty) {
        final String firstName = contact.name!.firstName ?? "";
        final String lastName = contact.name!.lastName ?? "";
        _contactPhotos[index] = contact.photo;
        // _phoneContacts[index] = PhoneContact('$firstName $lastName', contact.phones.first);
        _phoneContacts[index] = FavoriteContactModel(personName: '$firstName $lastName', personImage: '', personPhoneNumber: contact.phones.first.number ?? '', isVideo: false, isVoice: false, isWhatsApp: false, elderlyId: '', id: '');
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

  @override
  void initState() {
    _contactsBloc = BlocProvider.of<ContactsBloc>(context);
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
        else if (state is DataStoredState) {}
        else if (state is GetAllContactsDetailState) {
          requestContactsDetail = state.contactsDetail;
        }
      }, builder: (context, state) {
      return Scaffold(
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
                    'Paso 1 de 3 - Favoritos',
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
            Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    final FavoriteContactModel? contact = _phoneContacts[index];
                    final bool isContactSaved = requestContactsDetail?.contactsDetailList != null &&
                        index < requestContactsDetail!.contactsDetailList!.length;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isContactSaved && requestContactsDetail!.contactsDetailList![index].personName.isNotEmpty?
                        Text(
                          requestContactsDetail!.contactsDetailList![index].personName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ) :
                        Text(
                          contact == null ? 'Favorito ${index + 1}' : (contact.personName ?? '').toString(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                        InkWell(
                          onTap: () async {
                            await selectContact(index);
                          },
                          child: isContactSaved && requestContactsDetail != null && requestContactsDetail!.contactsDetailList!.isNotEmpty?
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.height * 0.09,
                                backgroundColor: const Color(0xffF4F4F4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: requestContactsDetail!.contactsDetailList![index].personImage != null ?
                                  Image.memory(
                                    requestContactsDetail!.contactsDetailList![index].personImage!
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
                                      requestContactsDetail!.contactsDetailList!.removeAt(index);
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
                                  child: Image.memory(_contactPhotos[index]!.bytes),
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
              ],
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
                name: "Siguiente",
                whenPress:
                _phoneContacts.isNotEmpty? (){
                  bool isContactSelected = _phoneContacts.any((contact) => contact != null);
                  if (isContactSelected) {
                //     _contactsBloc.add(SaveContactsDetailEvent(_phoneContacts, _contactPhotos));
                    List<FavoriteContactModel> clearedContacts = [];
                    for(var contact in _phoneContacts){
                      if(contact != null){
                        clearedContacts.add(contact);
                      }

                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => AllowContactMediumScreen(phoneContacts: clearedContacts, contactPhotos: _contactPhotos),
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
                            text: "Por favor seleccione contacto favorito",
                            isVisible: false,
                          ),
                        ),
                      )
                    );
                  }
                } : (){},
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            Padding(
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.08),
              child: Align(
                alignment: Alignment.centerRight,
                child: HelpButton(widget: const InitialFavoritePopup()),
              ),
            )
          ],
        ),
      );
    });
  }
}