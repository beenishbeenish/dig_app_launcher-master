import 'package:dig_app_launcher/APIModel/get_specific_elderly_request.dart';
import 'package:dig_app_launcher/Helper/DBModels/contacts_model.dart';
import 'package:dig_app_launcher/Popup/add_favorite_popup.dart';
import 'package:dig_app_launcher/Popup/delete_favorite_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddFavourite/ContactsBloc/contacts_bloc.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddFavourite/add_favorite_contact_manually.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddFavourite/show_contact_favorite.dart';
import 'package:dig_app_launcher/Utils/app_global.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FavouriteScreen extends StatefulWidget {
  final String elderlyId;
  List<PhoneContact?>? elderlyFavoritesContacts;
  List<FavoriteContactModel> phoneContacts;

  // List<Photo?>? elderlyFavoritesContactsPhoto;
  bool? isWhatsApp, isVoiceCall, isVideoCall;

  FavouriteScreen(
      {Key? key,
      required this.elderlyId,
      this.elderlyFavoritesContacts,
      this.isWhatsApp,
      this.isVoiceCall,
      this.isVideoCall,
      required this.phoneContacts})
      : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<FavoriteContactModel?> _phoneContacts = List.filled(4, null);
  List<Photo?> _contactPhotos = List.filled(4, null);

  List<FavoriteContactModel?> savedContacts = List.filled(4, null);
  List<Photo?> savedPhotos = List.filled(4, null);

  bool saveVisible = false;
  bool isLoading = true;

  late ContactsBloc _contactsBloc;
  RequestContactsDetail? requestContactsDetail;
  late AppGlobal appGlobal;

  Future<FullContact> selectContact(int index) async {
    final FullContact contact = await FlutterContactPicker.pickFullContact();
    return contact;
    setState(() {
      if (contact.phones.isNotEmpty) {
        final String firstName = contact.name!.firstName ?? "";
        final String lastName = contact.name!.lastName ?? "";
        _contactPhotos[index] = contact.photo;
        // _phoneContacts[index] = PhoneContact(, contact.phones.first);
        _phoneContacts[index] = FavoriteContactModel(
            personName: '$firstName $lastName',
            personImage: '',
            personPhoneNumber: contact.phones.first.number ?? '',
            isVideo: false,
            isVoice: false,
            isWhatsApp: false,
            elderlyId: widget.elderlyId ?? '',
            id: '');
      } else {
        _phoneContacts[index] = null;
        _contactPhotos[index] = null;
      }
      // Update savedContacts if the contact is already saved
      if (index < savedContacts.length) {
        savedContacts[index] = _phoneContacts[index];
        savedPhotos[index] = _contactPhotos[index];
      }
    });
  }

  void removeContact(int index) {
    setState(() {
      _phoneContacts[index] = null;
      // Update savedContacts when a contact is removed
      if (index < savedContacts.length) {
        savedContacts[index] = null;
        savedPhotos[index] = null;
      }
    });
  }

  void _checkUserRole() async {
    String? userRole = await appGlobal.getUserRole();

    if (userRole == 'elderly') {
      // savedContacts = _phoneContacts.map((contact) => PhoneContact(contact.personName, contact.personPhoneNumber as PhoneNumber?)).toList() ?? [];
      savedPhotos = requestContactsDetail?.contactsDetailList
              ?.map((contactPhoto) => contactPhoto.personImage as Photo?)
              .toList() ??
          [];

      _contactsBloc.add(GetAllContactsEvent());
    } else if (userRole == 'administrator' && widget.elderlyId != null) {
      for (int i = 0; i < 4; i++) {
        if (i < widget.phoneContacts.length) {
          FavoriteContactModel contact = widget.phoneContacts[i];
          _phoneContacts[i] = contact;
        } else {
          _phoneContacts[i] = null;
        }
      }

      setState(() {
        print(_phoneContacts);
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    appGlobal = AppGlobal();
    _contactsBloc = BlocProvider.of<ContactsBloc>(context);

    _checkUserRole();
    // savedContacts = requestContactsDetail?.contactsDetailList?.map((contact) => PhoneContact(contact.personName, contact.personPhoneNumber as PhoneNumber?)).toList() ?? [];
    // savedPhotos = requestContactsDetail?.contactsDetailList?.map((contactPhoto) => contactPhoto.personImage as Photo?).toList() ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactsBloc, ContactsState>(
        listener: (context, state) {
      if (state is LoadingState) {
      } else if (state is ErrorState) {
        Fluttertoast.showToast(
            msg: state.error,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey.shade400,
            textColor: Colors.white,
            fontSize: 12.0);
      } else if (state is RefreshScreenState) {
      } else if (state is DataStoredState) {
        saveVisible = true;
        _contactsBloc.add(GetAllContactsEvent());
      }
      else if (state is GetAllContactsDetailState) {
        if(requestContactsDetail != null && requestContactsDetail!.contactsDetailList != null){
          requestContactsDetail!.contactsDetailList!.clear();
          _phoneContacts = List.filled(4, null);
        }
        requestContactsDetail = state.contactsDetail;
        if (requestContactsDetail != null &&
            requestContactsDetail!.contactsDetailList != null) {
          for (int i = 0;
              i < requestContactsDetail!.contactsDetailList!.length;
              i++) {
            ContactsDetailModelLocalDB contact =
                requestContactsDetail!.contactsDetailList![i];
            if (i < 4) {
              _phoneContacts[i] = FavoriteContactModel(
                  personName: contact.personName,
                  personImage: '',
                  personPhoneNumber: contact.personPhoneNumber,
                  isVideo: contact.videoCall == '1',
                  isVoice: contact.voiceCall == '1',
                  isWhatsApp: contact.whatsapp == '1',
                  elderlyId: '',
                  id: '');
            }
          }
        }
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: const AppbarLogo(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageContainer(
                  imageHeight: MediaQuery.of(context).size.height * 0.1),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.09,
                    right: MediaQuery.of(context).size.width * 0.08,
                    top: MediaQuery.of(context).size.height * 0.02,
                    bottom: MediaQuery.of(context).size.height * 0.025),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Inicio > Favoritos',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
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
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1.1),
                itemCount: _phoneContacts.length,
                itemBuilder: (BuildContext context, int index) {
                  final FavoriteContactModel? contact = _phoneContacts[index];
                  // final bool isContactSaved = requestContactsDetail?.contactsDetailList != null &&
                  //     index < requestContactsDetail!.contactsDetailList!.length;
                  return Column(
                    children: [
                      // isContactSaved && requestContactsDetail!.contactsDetailList![index].personName.isNotEmpty?
                      contact != null
                          ? Text(
                              contact.personName,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          : Text(
                              'Favorito ${index + 1}',
                              // contact == null ? 'Favorito ${index + 1}' : (contact.fullName ?? '').toString(),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                      const SizedBox(height: 10),
                      InkWell(
                          onTap: () async {
                            // isContactSaved ?
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (ctx) => ContactFavoriteDetailScreen(phoneContact: _phoneContacts, contactPhoto: _contactPhotos, selectedContactIndex: index),
                            //   ),
                            // ) :
                            showModalBottomSheet(
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter
                                            setState /*You can rename this!*/) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 18, left: 18, right: 18),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      child: Wrap(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    FullContact
                                                        selectedContact =
                                                        await selectContact(
                                                            index);
                                                    if (selectedContact
                                                        .phones.isNotEmpty) {
                                                      final String firstName =
                                                          selectedContact.name
                                                                  ?.firstName ??
                                                              "";
                                                      final String lastName =
                                                          selectedContact.name
                                                                  ?.lastName ??
                                                              "";
                                                      _contactPhotos[index] =
                                                          selectedContact.photo;

                                                      FavoriteContactModel
                                                          contact =
                                                          FavoriteContactModel(
                                                              personName:
                                                                  '$firstName $lastName',
                                                              personImage: '',
                                                              personPhoneNumber:
                                                                  selectedContact
                                                                          .phones
                                                                          .first
                                                                          .number ??
                                                                      '',
                                                              isVideo: false,
                                                              isVoice: false,
                                                              isWhatsApp: false,
                                                              elderlyId: widget
                                                                      .elderlyId ??
                                                                  '',
                                                              id: '');
                                                      _phoneContacts[index] =
                                                          contact;
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              ContactFavoriteDetailScreen(
                                                            selectedContactIndex:
                                                                index,
                                                            contactsDetail:
                                                                requestContactsDetail,
                                                            elderlyId: widget
                                                                .elderlyId,
                                                            contact: contact,
                                                            phoneContacts:
                                                                _phoneContacts,
                                                          ),
                                                        ),
                                                      )
                                                          .then((value) {
                                                        if (value is List<
                                                            FavoriteContactModel>) {
                                                          Navigator.of(context)
                                                              .pop(value);
                                                        } else {
                                                          _contactsBloc.add(
                                                              GetAllContactsEvent());
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      });
                                                    } else {
                                                      _phoneContacts[index] =
                                                          null;
                                                      _contactPhotos[index] =
                                                          null;
                                                    }
                                                  },
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons.contacts,
                                                          color: Colors.black),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        'Desde el libro de contactos',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.025),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .push(
                                                      MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            AddFavoriteContactManuallyScreen(
                                                          elderlyId:
                                                              widget.elderlyId,
                                                          phoneContacts:
                                                              _phoneContacts,
                                                          selectedContactIndex:
                                                              index,
                                                        ),
                                                      ),
                                                    )
                                                        .then((value) {
                                                      // _contactsBloc.add(GetAllContactsEvent());
                                                      if (value is List<
                                                          FavoriteContactModel>) {
                                                        Navigator.pop(
                                                            context, value);
                                                      } else {
                                                        _contactsBloc.add(
                                                            GetAllContactsEvent());
                                                        Navigator.pop(context);
                                                      }
                                                    });
                                                  },
                                                  child: Row(
                                                    children: const [
                                                      Icon(
                                                          Icons
                                                              .contact_page_outlined,
                                                          color: Colors.black),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        'Agregar manualmente',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
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
                            ).then((value) {
                              if (value is List<FavoriteContactModel>) {
                                setState(() {
                                  for (int i = 0; i < 4; i++) {
                                    try {
                                      _phoneContacts[i] = value[i];
                                    } catch (e) {
                                      _phoneContacts[i] = null;
                                      break;
                                    }
                                  }
                                });
                              }
                            });
                            // if (isContactSaved && requestContactsDetail != null && requestContactsDetail!.contactsDetailList!.isNotEmpty) {
                            //   final contactDetail = requestContactsDetail!.contactsDetailList![index];
                            //   if (contactDetail.personName.isNotEmpty) {
                            //     // final phoneContacts = [PhoneContact(contactDetail.personName, contactDetail.personPhoneNumber as PhoneNumber?)];
                            //     final contactPhotos = [contactDetail.personImage];
                            //     Navigator.of(context).push(
                            //       MaterialPageRoute(
                            //         builder: (ctx) => ContactFavoriteDetailScreen(phoneContacts: _phoneContacts, contactPhotos: _contactPhotos, selectedContactIndex: index),
                            //       ),
                            //     );
                            //   }
                            // }
                            // else {
                            //   await selectContact(index).then((value) {
                            //     final phoneContacts = _phoneContacts.where((contact) => contact != null).toList();
                            //     Navigator.of(context).push(
                            //       MaterialPageRoute(
                            //         builder: (ctx) => ContactFavoriteDetailScreen(phoneContacts: phoneContacts, contactPhotos: _contactPhotos, selectedContactIndex: index),
                            //       ),
                            //     );
                            //     saveVisible = false;
                            //   });
                            // }
                          },
                          child: contact != null
                              ? SizedBox(
                            width: MediaQuery.of(context).size.width*0.25,
                                child: Stack(children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.25,
                                        height: MediaQuery.of(context).size.width *0.25,
                                        decoration: const BoxDecoration(
                                          color: Color(0xffF4F4F4),
                                          shape: BoxShape.circle

                                        ),

                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: contact != null &&
                                                  contact
                                                      .personImage.isNotEmpty &&
                                                  contact.personImage
                                                      .startsWith('http')
                                              ? const Icon(Icons.person,
                                                  size: 40, color: Colors.grey)
                                              : contact != null &&
                                                      contact
                                                          .personImage.isNotEmpty
                                                  ? Image.memory(
                                                      requestContactsDetail!
                                                          .contactsDetailList![
                                                              index]
                                                          .personImage!)
                                                  : const Icon(Icons.person,
                                                      size: 40,
                                                      color: Colors.grey),
                                        )),
                                    Positioned(
                                      right: 1,
                                      top: 1,
                                      child: InkWell(
                                        child: const Icon(Icons.cancel,
                                            color: Colors.black),
                                        onTap: () {
                                          setState(() {
                                            saveVisible = false;
                                            // _phoneContacts[index] = null;
                                            showDialog(
                                                context: context,
                                                builder: (_) => Dialog(
                                                      insetPadding:
                                                          EdgeInsets.only(
                                                              left: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.075,
                                                              right: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.075),
                                                      child: SizedBox(
                                                        height:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .height *
                                                                0.4,
                                                        child: DeleteFavoriteContactPopup(
                                                            name: requestContactsDetail!
                                                                .contactsDetailList![
                                                                    index]
                                                                .personName,
                                                          onYesPressed: () {
                                                            _contactsBloc.add(DeleteSpecificContactEvent(contactDetail: requestContactsDetail!, index: index));
                                                            requestContactsDetail!.contactsDetailList!.removeAt(index);
                                                            Navigator.pop(context);
                                                          },
                                                          onNoPressed: (){
                                                              Navigator.pop(context);
                                                          },
                                                        ),
                                                      ),
                                                    ));
                                          });
                                        },
                                      ),
                                    ),
                                  ]),
                              )
                              : CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width * 0.125,
                                  backgroundColor: const Color(0xffF4F4F4),
                                  child: const Icon(Icons.add),
                                )),
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
                            borderRadius: BorderRadius.circular(8)),
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
              saveVisible
                  ? SizedBox(height: MediaQuery.of(context).size.height * 0.02)
                  : SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              // Center(
              //   child: MyButton(
              //     name: "Guardar",
              //     whenPress: !saveVisible && _phoneContacts.isNotEmpty? (){
              //       List<PhoneContact?> allContacts = [];
              //       List<Photo?> allPhotos = [];
              //
              //       if (requestContactsDetail?.contactsDetailList != null) {
              //         allContacts.addAll(requestContactsDetail!.contactsDetailList!.map((contact) {
              //           PhoneNumber? phoneNumber;
              //           phoneNumber = PhoneNumber(contact.personPhoneNumber, '');
              //           return PhoneContact(contact.personName, phoneNumber);
              //         }).toList());
              //
              //         allPhotos.addAll(requestContactsDetail!.contactsDetailList!.map((contactPhoto) =>
              //           contactPhoto.personImage != null ? Photo(contactPhoto.personImage!) : null));
              //       }
              //
              //       // Add the contacts from the phoneContacts list
              //       allContacts.addAll(_phoneContacts.where((contact) => contact != null));
              //       allPhotos.addAll(_contactPhotos);
              //
              //       // Save the contacts
              //       _contactsBloc.add(SaveContactsDetailEvent(allContacts, allPhotos));
              //       // _contactsBloc.add(SaveContactsDetailEvent(_phoneContacts, _contactPhotos));
              //     } : (){},
              //   ),
              // ),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Center(
                child: MyButton(
                  name: "Volver",
                  whenPress: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.06,
                    right: MediaQuery.of(context).size.width * 0.1),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: HelpButton(widget: const AddFavoritePopup()),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.05,)
            ],
          ),
        ),
      );
    });
  }
}
