import 'package:dig_app_launcher/APIModel/get_specific_elderly_request.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddEmergencyContact/add_emergency_contact.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddFavourite/add_favourite.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddMedicine/medicine.dart';
import 'package:dig_app_launcher/Screens/Configuration/Leisure/leisure.dart';
import 'package:dig_app_launcher/Screens/Configuration/LetterSize/letter_size.dart';
import 'package:dig_app_launcher/Screens/Configuration/Location/location.dart';
import 'package:dig_app_launcher/Screens/Configuration/Sound/sound.dart';
import 'package:dig_app_launcher/Screens/Configuration/change_configuration_password.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/elderly_home.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Utils/app_images.dart';
import 'package:dig_app_launcher/Widgets/admin_menu_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:dig_app_launcher/Widgets/user_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigurationScreen extends StatefulWidget {

  final String elderlyId, userRole;
  ConfigurationScreen({Key? key, required this.elderlyId , required this.userRole}) : super(key: key);

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {

  bool hasPermission = false;
  String? userRole;
  bool isLoading = false;

  int? titleFont, textFont, volume;
  bool? isWhatsApp, isVoiceCall, isVideoCall, isBluetooth;
  List<PhoneContact?> elderlyFavoritesContacts = [];
  List<Photo?> elderlyFavoritesContactPhoto = [];

  List<FavoriteContactModel> favoriteContacts = [];


  // void _checkPermissionStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isPermissionGranted = prefs.getBool('isPermissionGranted') ?? false;
  //   setState(() {
  //     hasPermission = isPermissionGranted;
  //   });
  // }

  // void _handleShareLocationClick() async {
  //   var permissionStatus = await Permission.location.request();
  //
  //   if (permissionStatus.isGranted) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setBool('isPermissionGranted', true);
  //     setState(() {
  //       hasPermission = true;
  //     });
  //     _startLocationUpdates();
  //   } else if (permissionStatus.isDenied) {
  //     // _showPermissionDeniedError();
  //   } else if (permissionStatus.isPermanentlyDenied) {
  //     // _openAppSettings();
  //   }
  // }

  void _startLocationUpdates() {
    var geolocator = GeolocatorPlatform.instance;

    var locationStream = geolocator.getPositionStream();
    locationStream.listen((Position position) {
      _handleNewLocation(position);
    });
  }

  void _handleNewLocation(Position position) {
    // var latitude = position.latitude;
    // var longitude = position.longitude;

    // Implement your logic to share live location using latitude and longitude
    // For example, send the location data to a server or update it in real-time on the UI

    // http.post('https://your-api-endpoint.com/location', body: {
    //   'latitude': latitude.toString(),
    //   'longitude': longitude.toString(),
    // });
  }

  Future<void> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('IsLogin', true);
  }

  @override
  void initState() {
    super.initState();
    // isLogin();
    userRole = widget.userRole;
    if(userRole == 'administrator'){
      setState(() {
        isLoading = true;
      });
      requestGetSpecificElderly(widget.elderlyId).then((value) {
        if(value != null && value.status == true){

          setState(() async {
            favoriteContacts = value.data.elderlyFavoritesContacts;
            titleFont = value.data.userTitleSize;
            textFont = value.data.userTextSize;
            volume = value.data.userVolume;
            isBluetooth = value.data.userBluetooth;
            for(int i=0;i<value.data.elderlyFavoritesContacts.length;i++){
              FavoriteContactModel contact = value.data.elderlyFavoritesContacts[i];
              elderlyFavoritesContacts.add(PhoneContact(contact.personName, PhoneNumber(contact.personPhoneNumber, '')));
              // final http.Response responseData = await http.get(Uri.parse(contact.personImage));
              // var uint8list = responseData.bodyBytes;
              // var buffer = uint8list.buffer;
              // ByteData byteData = ByteData.view(buffer);
              // var tempDir = await getTemporaryDirectory();
              // File file = await File('${tempDir.path}/img').writeAsBytes(
              //   buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
              // );
              // elderlyFavoritesContactPhoto.add(contact.personImage);
              isWhatsApp = contact.isWhatsApp;
              isVoiceCall = contact.isVoice;
              isVideoCall = contact.isVideo;
            }
            print("Contacts on Configuration Screen are: ${elderlyFavoritesContacts}");
          });
        }
      }).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarLogo(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: userRole == 'elderly'? MyButton(
        name: 'Salir de la configuración',
        whenPress: (){
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => ElderlyHomeScreen()
            ), (Route<dynamic> route) => false
          );
        },
      ) : const SizedBox(),
      body: isLoading ?
        const Loader() :
        Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.2),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.03, top: MediaQuery.of(context).size.height * 0.02
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    userRole == 'elderly'? UserMenuButton(onMyAccountPress: true, onAdministratorPress: false, onConfigurationPress: true) : AdminMenuButton(onMyAccountPress: true, onSupervisorsPress: true, elderlyId: widget.elderlyId),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.56,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
                            child: const Text(
                              'Configuración',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
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
                  indent: MediaQuery.of(context).size.width * 0.27,
                  endIndent: MediaQuery.of(context).size.width * 0.03,
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
                      width: MediaQuery.of(context).size.width * 0.28,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffF5F5F5),
                          border: Border.all(
                              color: const Color(0xffA8A8A8)
                          )
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => LetterSizeScreen(elderlyId: widget.elderlyId, titleSize: titleFont, textSize: textFont),
                            ),
                          ).then((value) {
                            if(userRole == 'administrator') {
                              requestGetSpecificElderly(widget.elderlyId).then((value) {
                                if(value != null && value.status == true){
                                  setState(() {
                                    titleFont = value.data.userTitleSize;
                                    textFont = value.data.userTextSize;
                                  });
                                }
                              });
                            }
                          });
                        },
                        child: Column(
                          children: [
                            const Text(
                              'LETRA',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            SvgPicture.asset(
                              AppImages.letra,
                              height: MediaQuery.of(context).size.height * 0.08,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
                      width: MediaQuery.of(context).size.width * 0.28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xffF5F5F5),
                        border: Border.all(
                            color: const Color(0xffA8A8A8)
                        )
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => FavouriteScreen(elderlyId: widget.elderlyId, elderlyFavoritesContacts: elderlyFavoritesContacts, isWhatsApp: isWhatsApp, isVoiceCall: isVoiceCall, isVideoCall: isVideoCall, phoneContacts: favoriteContacts,),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            const Text(
                              'FAVORITOS',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            SvgPicture.asset(
                              AppImages.favoritos,
                              height: MediaQuery.of(context).size.height * 0.08,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
                      width: MediaQuery.of(context).size.width * 0.28,
                      // height: MediaQuery.of(context).size.height * 0.055,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xffF5F5F5),
                        border: Border.all(
                          color: const Color(0xffA8A8A8)
                        )
                      ),
                      child: InkWell(
                        onTap: (){
                          // _checkPermissionStatus();
                          // hasPermission == false? _handleShareLocationClick() : '';
                          // hasPermission?
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const ShareLocationScreen(),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            const Text(
                              'LOCALIZAR',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            SvgPicture.asset(
                              AppImages.localizer,
                              height: MediaQuery.of(context).size.height * 0.08,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
                        width: MediaQuery.of(context).size.width * 0.28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffF5F5F5),
                          border: Border.all(
                            color: const Color(0xffA8A8A8)
                          )
                        ),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const EmergencyContactScreen(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              const Text(
                                'SOS',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              SvgPicture.asset(
                                AppImages.sos,
                                height: MediaQuery.of(context).size.height * 0.08,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
                        width: MediaQuery.of(context).size.width * 0.28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffF5F5F5),
                          border: Border.all(
                            color: const Color(0xffA8A8A8)
                          )
                        ),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => SoundScreen(elderlyId: widget.elderlyId, volume: volume, isBluetooth: isBluetooth, userRole: widget.userRole),
                              ),
                            ).then((value) {
                              if(userRole == 'administrator') {
                                requestGetSpecificElderly(widget.elderlyId).then((value) {
                                  if(value != null && value.status == true){
                                    setState(() {
                                      volume = value.data.userVolume;
                                      isBluetooth = value.data.userBluetooth;
                                    });
                                  }
                                });
                              }
                            });
                          },
                          child: Column(
                            children: [
                              const Text(
                                'SONIDO',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              SvgPicture.asset(
                                AppImages.sonido,
                                height: MediaQuery.of(context).size.height * 0.08,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
                        width: MediaQuery.of(context).size.width * 0.28,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xffF5F5F5),
                            border: Border.all(
                                color: const Color(0xffA8A8A8)
                            )
                        ),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const MedicineScreen(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              const Text(
                                'PASTILLAS',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              SvgPicture.asset(
                                AppImages.capsules,
                                height: MediaQuery.of(context).size.height * 0.08,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: userRole == 'elderly'? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
                      width: MediaQuery.of(context).size.width * 0.28,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffF5F5F5),
                          border: Border.all(
                              color: const Color(0xffA8A8A8)
                          )
                      ),
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => LeisureScreen(elderlyId: widget.elderlyId),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            const Text(
                              'OCIO',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            SvgPicture.asset(
                              AppImages.ocio,
                              height: MediaQuery.of(context).size.height * 0.08,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: userRole == 'elderly',
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                        width: MediaQuery.of(context).size.width * 0.57,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xffF5F5F5),
                            border: Border.all(
                                color: const Color(0xffA8A8A8)
                            )
                        ),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const ChangeConfigurationPasswordScreen(),
                              ),
                            );
                          },
                          child: const Center(
                            child: Text(
                              'Cambiar contraseña acceso',
                              style: TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}