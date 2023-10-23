import 'dart:async';

import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareLocationScreen extends StatefulWidget {
  const ShareLocationScreen({Key? key}) : super(key: key);

  @override
  State<ShareLocationScreen> createState() => _ShareLocationScreenState();
}

class _ShareLocationScreenState extends State<ShareLocationScreen> {

  final Completer<GoogleMapController> _controller =Completer<GoogleMapController>();

  Position? currentLocation;
  Set<Marker> _markers = {};
  late GoogleMapController _mapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  bool hasPermission = false;

  void _handleShareLocationClick() async {
    var permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
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
      setState(() {
        currentLocation = position;
      });
      _handleNewLocation(position);
    });
  }

  void _handleNewLocation(Position position) {
    var latitude = position.latitude;
    var longitude = position.longitude;

    // Update the marker position on the map
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('liveLocation'),
          position: LatLng(latitude, longitude),
        ),
      };
    });

    if (_mapController != null) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 14.0,
          ),
        ),
      );
    }
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
    _checkPermissionStatus();
    hasPermission == false? _handleShareLocationClick() : '';
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarLogo(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.1),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.09, right: MediaQuery.of(context).size.width * 0.08,
              top: MediaQuery.of(context).size.height * 0.05, bottom: MediaQuery.of(context).size.height * 0.05
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
                    'Inicio > Localización',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_sharp, color: Colors.black),
              ),
              const Text(
                'Location Sharing',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              IconButton(
                onPressed: (){},
                icon: const Icon(Icons.more_vert, color: Colors.black),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.height * 0.02,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  setState(() {
                    _mapController = controller;
                  });
                },
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),
          ),
          Center(
            child: MyButton(
              name: "Volver",
              whenPress: (){
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          // Padding(
          //   padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
          //   child: const Align(
          //     alignment: Alignment.centerRight,
          //     child: HelpButton(),
          //   ),
          // )
        ],
      ),
    );
  }
}
