import 'package:dig_app_launcher/Helper/DBModels/leisure_model.dart';
import 'package:dig_app_launcher/Popup/leisure_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/Leisure/LeisureBloc/leisure_bloc.dart';
import 'package:dig_app_launcher/Screens/Configuration/Leisure/add_leisure.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Utils/app_global.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:dig_app_launcher/Widgets/name_with_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LeisureScreen extends StatefulWidget {

  String? elderlyId;
  LeisureScreen({Key? key, this.elderlyId}) : super(key: key);

  @override
  State<LeisureScreen> createState() => _LeisureScreenState();
}

class _LeisureScreenState extends State<LeisureScreen> {

  bool isLoading = true;
  // bool isGetData = true;
  // String storedId = '';

  late LeisureBloc _leisureBloc;
  RequestAppData? requestAppData;
  late AppGlobal appGlobal;

  // Future<void> retrieveStoredId() async {
  //   String id = await appGlobal.retrieveId();
  //   setState(() {
  //     storedId = id;
  //   });
  // }

  void _checkUserRole() async {
    String? userRole = await appGlobal.getUserRole();

    if(userRole == 'elderly') {
      if (requestAppData != null && requestAppData!.appList != null) {
        requestAppData!.appList!.sort((a, b) => a.appName.compareTo(b.appName));
      }
      setState(() {
        isLoading = false;
        // isGetData = false;
      });
    }
    else if (userRole == 'administrator' && widget.elderlyId != null) {
      requestGetSpecificElderly(widget.elderlyId!).then((value) {

      }).whenComplete(() {
        setState(() {
          isLoading = false;
          // isGetData = false;
        });
      });
    }
  }

  @override
  void initState() {
    appGlobal = AppGlobal();
    _leisureBloc = BlocProvider.of<LeisureBloc>(context);
    _leisureBloc.add(GetAllAppEvent());
    super.initState();
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
        else if (state is GetAllAppState) {
          requestAppData = state.appDetail;
          _checkUserRole();
        }
      }, builder: (context, state) {
      return Scaffold(
        appBar: const AppbarLogo(),
        body: Stack(
          children: [
            Column(
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
                const Center(
                  child: Text(
                    'Aplicaciones seleccionadas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: requestAppData != null? requestAppData!.appList!.length : 0,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                // DeviceApps.openApp(app.packageName);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.memory(
                                    requestAppData!.appList![index].appImage,
                                    width: 45,
                                    height: 45,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    requestAppData!.appList![index].appName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12, color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: NameWithIconButton(
                    whenPress: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => AddLeisureScreen(elderlyId: widget.elderlyId),
                        ),
                      ).then((value) {
                        _leisureBloc.add(GetAllAppEvent());
                      });
                    },
                    name: "Añadir APP",
                    icon: Icons.add_circle_outline,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                    child: HelpButton(widget: const LeisurePopup()),
                  ),
                )
              ],
            ),
            if (isLoading)
              const Loader(),
          ]
        ),
      );
    });
  }
}