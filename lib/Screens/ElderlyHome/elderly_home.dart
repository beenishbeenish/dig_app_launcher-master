import 'package:auto_size_text/auto_size_text.dart';
import 'package:dig_app_launcher/Helper/DBModels/contacts_model.dart';
import 'package:dig_app_launcher/Helper/DBModels/letter_size_model.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/ElderlyHomeBloc/elderly_home_bloc.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/QR/qr.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/ShowLeisure/show_leisure.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/ShowMedicine/show_medicine.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/favourite_detail.dart';
import 'package:dig_app_launcher/Utils/app_global.dart';
import 'package:dig_app_launcher/Utils/app_images.dart';
import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:dig_app_launcher/Widgets/appbar.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/user_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:installed_apps/app_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ElderlyHomeScreen extends StatefulWidget {

  String? elderlyId;
  ElderlyHomeScreen({Key? key, this.elderlyId}) : super(key: key);

  @override
  State<ElderlyHomeScreen> createState() => _ElderlyHomeScreenState();
}

class _ElderlyHomeScreenState extends State<ElderlyHomeScreen> {

  int titleFont = 22;
  int textFont = 16;

  bool isLoading = false;

  late ElderlyHomeBloc _elderlyHomeBloc;
  RequestLetterSizeDetail? requestLetterSizeDetail;
  RequestContactsDetail? requestContactsDetail;
  AppGlobal appGlobal = AppGlobal();

  List<AppInfo> installedApps = [];

  void openContacts() async {
    const url = 'content://contacts/people/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('IsLogin', true);
  }

  bool hasPermission = false;

  void _handleShareLocationClick() async {
    var permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      setState(() {
        hasPermission = true;
      });
      _startLocationUpdates();
    }
  }

  void _startLocationUpdates() {
    var geolocator = GeolocatorPlatform.instance;

    var locationStream = geolocator.getPositionStream();
  }

  void _checkPermissionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isPermissionGranted = prefs.getBool('isPermissionGranted') ?? false;
    setState(() {
      hasPermission = isPermissionGranted;
    });
  }

  @override
  void initState() {
    _elderlyHomeBloc = BlocProvider.of<ElderlyHomeBloc>(context);
    _elderlyHomeBloc.add(GetLetterSizeEvent());
    _elderlyHomeBloc.add(GetAllContactsEvent());
    isLogin();
    _checkPermissionStatus();
    hasPermission == false? _handleShareLocationClick() : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ElderlyHomeBloc, ElderlyHomeState>(
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
        else if (state is GetLetterSizeState) {
          requestLetterSizeDetail = state.letterSizeDetail;

          if (requestLetterSizeDetail != null && requestLetterSizeDetail!.letterSizeDetailList != null && requestLetterSizeDetail!.letterSizeDetailList!.isNotEmpty) {
            titleFont = requestLetterSizeDetail!.letterSizeDetailList!.first.titleSize;
            textFont = requestLetterSizeDetail!.letterSizeDetailList!.first.textSize;
          }
          else {
            titleFont = 22;
            textFont = 16;
          }
        }
        else if (state is GetAllContactsDetailState) {
          requestContactsDetail = state.contactsDetail;
        }
      }, builder: (context, state) {
      return Scaffold(
        appBar: Appbar(onSOSPress: true, onInicioPress: false),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.08,
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
                      UserMenuButton(onMyAccountPress: true, onAdministratorPress: true, onConfigurationPress: true),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.46,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                              child: AutoSizeText(
                                'Inicio',
                                style: TextStyle(fontSize: titleFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                                maxLines: 1,
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  Expanded(
                    child:
                    requestContactsDetail != null && requestContactsDetail!.contactsDetailList!.isNotEmpty?
                    GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.9
                      ),
                      itemCount: requestContactsDetail!.contactsDetailList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: requestContactsDetail != null && requestContactsDetail!.contactsDetailList!.isNotEmpty? (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => FavouriteDetail(index: index, name: requestContactsDetail!.contactsDetailList![index].personName, phoneNumber: requestContactsDetail!.contactsDetailList![index].personPhoneNumber, image: requestContactsDetail!.contactsDetailList![index].personImage),
                              ),
                            );
                          } : (){},
                          child: Column(
                            children: [
                              AutoSizeText(
                                requestContactsDetail != null && requestContactsDetail!.contactsDetailList!.isNotEmpty?
                                requestContactsDetail!.contactsDetailList![index].personName : "Favorito ${index+1}",
                                style: TextStyle(fontSize: textFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                                maxLines: 1,
                              ),
                              const SizedBox(height: 5),
                              requestContactsDetail!.contactsDetailList![index].personImage != null?
                              Image.memory(
                                requestContactsDetail!.contactsDetailList![index].personImage!,
                                height: MediaQuery.of(context).size.height * 0.125,
                              ) :
                              const SizedBox(
                                child: Icon(Icons.person, color: Colors.black, size: 50),
                              )
                            ],
                          ),
                        );
                      },
                    ):
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "No hay contactos guardados todavía",
                          style: TextStyle(fontSize: textFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1.5,
                    color: const Color(0xffD0D0D0),
                    endIndent: MediaQuery.of(context).size.width * 0.03,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xffF5F5F5),
                              border: Border.all(
                                  color: const Color(0xffA8A8A8)
                              )
                          ),
                          child: InkWell(
                            onTap: () {
                              openContacts();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  'Llamadas',
                                  style: TextStyle(fontSize: textFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                                  maxLines: 1,
                                ),
                                SvgPicture.asset(
                                  AppImages.telephone,
                                  width: MediaQuery.of(context).size.width *0.14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
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
                                  builder: (ctx) => const ShowMedicineScreen(),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  'Pastillas',
                                  style: TextStyle(fontSize: textFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                                  maxLines: 1,
                                ),
                                SvgPicture.asset(
                                  AppImages.capsules,
                                  width: MediaQuery.of(context).size.width *0.12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const QRScreen(),
                            ),
                          );
                        },
                        child: ClipRRect (
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.32,
                            padding: const EdgeInsets.only(left: 5, right: 3, top: 3, bottom: 3),
                            color: kColorPrimary,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    AutoSizeText(
                                      'Leer',
                                      style: TextStyle(fontSize: textFont.toDouble(), color: Colors.black, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ),
                                    SizedBox(
                                        child: Image.asset('assets/images/qr-code-small.png')
                                    ),
                                  ],
                                ),
                                AutoSizeText(
                                  'prospecto',
                                  style: TextStyle(fontSize: textFont.toDouble(), color: Colors.black, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const ShowLeisureScreen(),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: MediaQuery.of(context).size.width * 0.32,
                              padding: const EdgeInsets.only(left: 8, top: 5, right: 10),
                              color: const Color(0xffE2FE93),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: AutoSizeText(
                                        'Ocio',
                                        style: TextStyle(fontSize: textFont.toDouble(), color: Colors.black, fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: SvgPicture.asset(
                                        AppImages.ocio,
                                        width: MediaQuery.of(context).size.width *0.07,
                                      ),
                                    ),
                                  ]
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01)
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