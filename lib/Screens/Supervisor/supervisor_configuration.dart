import 'package:dig_app_launcher/Screens/Configuration/Location/location.dart';
import 'package:dig_app_launcher/Screens/Configuration/Sound/sound.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/supervisor_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupervisorConfigrationScreen extends StatefulWidget {

  String? elderlyId;
  SupervisorConfigrationScreen({Key? key, this.elderlyId}) : super(key: key);

  @override
  State<SupervisorConfigrationScreen> createState() => _SupervisorConfigrationScreenState();
}

class _SupervisorConfigrationScreenState extends State<SupervisorConfigrationScreen> {

  bool hasPermission = false;

  void _checkPermissionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isPermissionGranted = prefs.getBool('isPermissionGranted') ?? false;
    setState(() {
      hasPermission = isPermissionGranted;
    });
  }

  void _handleShareLocationClick() async {
    var permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isPermissionGranted', true);
      setState(() {
        hasPermission = true;
      });
      _startLocationUpdates();
    } else if (permissionStatus.isDenied) {
      // _showPermissionDeniedError();
    } else if (permissionStatus.isPermanentlyDenied) {
      // _openAppSettings();
    }
  }

  void _startLocationUpdates() {
    var geolocator = GeolocatorPlatform.instance;

    var locationStream = geolocator.getPositionStream();
    locationStream.listen((Position position) {
      _handleNewLocation(position);
    });
  }

  void _handleNewLocation(Position position) {
    var latitude = position.latitude;
    var longitude = position.longitude;

    // Implement your logic to share live location using latitude and longitude
    // For example, send the location data to a server or update it in real-time on the UI

    // http.post('https://your-api-endpoint.com/location', body: {
    //   'latitude': latitude.toString(),
    //   'longitude': longitude.toString(),
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarLogo(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.2),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.08, top: MediaQuery.of(context).size.height * 0.02
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SupervisorMenuButton(onMyAccountPress: true),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                            child: const Text(
                              'Supervisor',
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
                  indent: MediaQuery.of(context).size.width * 0.29,
                  endIndent: MediaQuery.of(context).size.width * 0.03,
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => SoundScreen(elderlyId: widget.elderlyId),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      const Text(
                        'SONIDO',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Transform(
                        transform: Matrix4.translationValues(0.0, -12.0, 0.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.13,
                          child: Image.asset('assets/images/speaker.png')
                        )
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    _checkPermissionStatus();
                    hasPermission == false? _handleShareLocationClick() : '';
                    hasPermission?
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const ShareLocationScreen(),
                      ),
                    ): '';
                  },
                  child: Column(
                    children: [
                      const Text(
                        'LOCALIZAR',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Transform(
                          transform: Matrix4.translationValues(0.0, -12.0, 0.0),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.13,
                              child: Image.asset('assets/images/location.png')
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}