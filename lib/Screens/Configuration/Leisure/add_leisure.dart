import 'dart:convert';
import 'dart:typed_data';

import 'package:dig_app_launcher/Helper/DBModels/leisure_model.dart';
import 'package:dig_app_launcher/Popup/add_leisure_popup.dart';
import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/Leisure/LeisureBloc/leisure_bloc.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:dig_app_launcher/Widgets/name_with_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AddLeisureScreen extends StatefulWidget {

  String? elderlyId;
  AddLeisureScreen({Key? key, this.elderlyId}) : super(key: key);

  @override
  State<AddLeisureScreen> createState() => _AddLeisureScreenState();
}

class _AddLeisureScreenState extends State<AddLeisureScreen> {

  List<int> selectedAppIndexes = [];
  List<AppInfo> installedApps = [];
  List<dynamic> getAppsFromServer = [];
  List<AppModelLocalDB> selectedApps = [];
  bool isFetchingApps = true;

  bool saveVisible = false;
  bool isLoading = false;
  String storedId = '';

  String? userRole;

  late LeisureBloc _leisureBloc;
  RequestAppData? requestAppData;


  Future<void> retrieveStoredId() async {
    String id = await appGlobal.retrieveId();
    setState(() {
      storedId = id;
    });
  }

  Future<void> fetchInstalledApps() async {
    List<AppInfo> apps = await InstalledApps.getInstalledApps(true, true);
    setState(() {
      installedApps = apps;
      isFetchingApps = false;
    });
    _leisureBloc.add(GetAllAppEvent());
  }

  bool isAppSaved(AppInfo app) {
    if (requestAppData != null) {
      return requestAppData!.appList!.any((detail) => detail.appUrl == app.packageName);
    }
    return false;
  }

  void _checkUserRole() async {
    userRole = await appGlobal.getUserRole();

    if(userRole == 'elderly') {
      fetchInstalledApps();
    }
    else if (userRole == 'administrator' && widget.elderlyId != null) {
      setState(() {
        isLoading = true;
      });
      requestGetSpecificElderly(widget.elderlyId!).then((value) {
        getAppsFromServer = value!.data.elderlyGame;
      }).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _leisureBloc = BlocProvider.of<LeisureBloc>(context);
    retrieveStoredId();
    _checkUserRole();
    // fetchInstalledApps();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeisureBloc, LeisureState>(
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
        else if (state is SaveAppState) {}
        else if (state is DataStoredState) {
          saveVisible = true;
        }
        else if (state is GetAllAppState){
          requestAppData = state.appDetail;
          List<AppModelLocalDB> savedApps = requestAppData!.appList ?? [];
          for(int i=0; i< savedApps.length; i++ ){
            for(int j=0; j< installedApps.length; j++){
              if(savedApps[i].appUrl == installedApps[j].packageName){
                selectedAppIndexes.add(j);
                break;
              }
            }
          }
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
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.09, vertical: MediaQuery.of(context).size.height * 0.04
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
                            'Inicio > Ocio',
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
                  isFetchingApps ?
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: const Center(
                      child: Text(
                        "Obtención de aplicaciones......",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ) :
                  userRole == 'elderly' ?
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: installedApps.length,
                            itemBuilder: (BuildContext context, int index) {
                              AppInfo app = installedApps[index];
                              bool isSelected = selectedAppIndexes.contains(index);
                              if (isAppSaved(app)) {
                                isSelected = true;

                              } else {
                                isSelected = selectedAppIndexes.contains(index);
                              }
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      if (isAppSaved(app)) {
                                        requestAppData!.appList!.removeWhere((detail) => detail.appUrl == app.packageName);
                                        // Do nothing when the app is already saved
                                      } else {
                                        // Remove the app from requestAppData!.appList! and selectedAppIndexes
                                        requestAppData!.appList!.removeWhere((detail) => detail.appUrl == app.packageName);
                                        selectedAppIndexes.remove(index);
                                        selectedApps.removeWhere((model) => model.appUrl == app.packageName);
                                      }
                                    } else {
                                      // Add the app to requestAppData!.appList! and selectedAppIndexes
                                      requestAppData!.appList!.add(AppModelLocalDB(appName: app.name!, appImage: app.icon!, appUrl: app.packageName!));
                                      selectedAppIndexes.add(index);
                                      selectedApps.add(AppModelLocalDB(appName: app.name!, appImage: app.icon!, appUrl: app.packageName!));
                                    }
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected ? Colors.black : Colors.transparent,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          Image.memory(
                                            app.icon!,
                                            width: 48,
                                            height: 48,
                                          ),
                                          Text(
                                            app.name!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(fontSize: 12, color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ) :
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: getAppsFromServer.length,
                            itemBuilder: (BuildContext context, int index) {
                              AppInfo app = getAppsFromServer[index];
                              bool isSelected = selectedAppIndexes.contains(index);
                              if (isAppSaved(app)) {
                                isSelected = true;

                              } else {
                                isSelected = selectedAppIndexes.contains(index);
                              }
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      if (isAppSaved(app)) {
                                        requestAppData!.appList!.removeWhere((detail) => detail.appUrl == app.packageName);
                                        // Do nothing when the app is already saved
                                      } else {
                                        // Remove the app from requestAppData!.appList! and selectedAppIndexes
                                        requestAppData!.appList!.removeWhere((detail) => detail.appUrl == app.packageName);
                                        selectedAppIndexes.remove(index);
                                        selectedApps.removeWhere((model) => model.appUrl == app.packageName);
                                      }
                                    } else {
                                      // Add the app to requestAppData!.appList! and selectedAppIndexes
                                      requestAppData!.appList!.add(AppModelLocalDB(appName: app.name!, appImage: app.icon!, appUrl: app.packageName!));
                                      selectedAppIndexes.add(index);
                                      selectedApps.add(AppModelLocalDB(appName: app.name!, appImage: app.icon!, appUrl: app.packageName!));
                                    }
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected ? Colors.black : Colors.transparent,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          Image.memory(
                                            app.icon!,
                                            width: 48,
                                            height: 48,
                                          ),
                                          Text(
                                            app.name!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(fontSize: 12, color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                    child: Visibility(
                      visible: saveVisible,
                      child: Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.035,
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff6ECB42),
                              shape: RoundedRectangleBorder( //to set border radius to button
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
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                    child: Center(
                      child: NameWithIconButton(
                        whenPress: (){
                          setState(() {
                            isLoading = true;
                          });

                          List<AppInfo> selectedApps = selectedAppIndexes.map((index) => installedApps[index]).toList();

                          List<Map<String, String>> leisure = [];
                          for (int i = 0; i < selectedAppIndexes.length; i++) {
                            int selectedIndex = selectedAppIndexes[i];
                            AppInfo app = installedApps[selectedIndex];
                            String appName = app.name ?? '';
                            String appUrl = app.packageName ?? '';
                            String appImage = app.icon != null ? base64Encode(app.icon!) : '';

                            Map<String, String> contactMap = {
                              'gameName': appName,
                              'gameUrl': appUrl,
                              'gameImage': appImage,
                            };
                            leisure.add(contactMap);
                          }

                          requestLeisure(leisure, storedId).then((value) {
                            if(value != null && value.status == true){
                              for (AppInfo app in selectedApps) {
                                Uint8List appIcon = app.icon!;
                                _leisureBloc.add(SaveAppEvent(appName: app.name!, appImage: appIcon, packageName: app.packageName!));
                              }
                            }
                            else{
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: AlertDialogPopup(
                                      text: "La aplicación no se guarda. Comprueba tu conexión a Internet e inténtalo de nuevo.",
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
                        name: "Guardar Selección",
                        icon: Icons.add_circle_outline,
                      ),
                    ),
                  ),
                  Center(
                    child: MyButton(
                      whenPress: (){
                        Navigator.pop(context);
                      },
                      name: "Volver",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025, right: MediaQuery.of(context).size.width * 0.1),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: HelpButton(widget: const AddLeisurePopup()),
                    ),
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