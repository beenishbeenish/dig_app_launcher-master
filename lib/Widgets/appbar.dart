import 'dart:async';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:dig_app_launcher/Helper/DBModels/emergency_contacts_model.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddEmergencyContact/EmergencyContactsBloc/emergency_contacts_bloc.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/elderly_home.dart';
import 'package:dig_app_launcher/Utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class Appbar extends StatefulWidget implements PreferredSizeWidget {

  bool onSOSPress, onInicioPress;
  Appbar({Key? key, required this.onSOSPress, required this.onInicioPress}) : super(key: key);

  @override
  _AppbarState createState() => _AppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 35);
}

class _AppbarState extends State<Appbar> {

  late Timer _timer;
  late Timer _batteryTimer;
  late DateTime _currentTime;

  Position? currentPosition;
  int batteryLevel = 0;

  late EmergencyContactsBloc _emergencyContactsBloc;
  RequestEmergencyContactsDetail? requestEmergencyContactsDetail;

  Future<void> _getBatteryLevel() async {
    _batteryTimer = Timer.periodic(
      const Duration(seconds: 1), (_) async {
        final batteryInfo = await BatteryInfoPlugin().androidBatteryInfo;
        setState(() {
          batteryLevel = batteryInfo?.batteryLevel ?? 0;
        });
      }
    );
  }

  _sendSMS(String phoneNumber, String message) async {
    List<String> recipents = [phoneNumber];
    String _result = await sendSMS(message: message, recipients: recipents, sendDirect: true)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  _callNumbersFromEmergencyContacts() async {
    if (requestEmergencyContactsDetail != null) {
      List<String> phoneNumbers = requestEmergencyContactsDetail!.emergencyContactsDetailList!
          .map((contact) => contact.personPhoneNumber)
          .toList();

      // Get current location
      try {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        String locationMessage = 'I need help. My current location is: $position, ${position.latitude}, ${position.longitude}';

        // Make phone call to each contact one by one
        await _makeSequentialCalls(phoneNumbers, locationMessage);
      } catch (e) {
        print(e);
      }
    }
  }

// Recursive function to make sequential calls to emergency contacts
  _makeSequentialCalls(List<String> phoneNumbers, String locationMessage, {int index = 0}) async {
    if (index >= phoneNumbers.length) {
      // All contacts have been called
      return;
    }

    String phoneNumber = phoneNumbers[index];
    // Send location message via SMS to the current contact
    await _sendSMS(phoneNumber, locationMessage);

    bool? callSuccess = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (callSuccess == true) {
      // Call was successful, stop making further calls
      return;
    } else {
      // Delay between calls
      await Future.delayed(const Duration(seconds: 5));

      // Make the next call to the next contact
      await _makeSequentialCalls(phoneNumbers, locationMessage, index: index + 1);
    }
  }

  @override
  void initState() {
    super.initState();
    _emergencyContactsBloc = BlocProvider.of<EmergencyContactsBloc>(context);
    _emergencyContactsBloc.add(GetAllEmergencyContactsEvent());
    _currentTime = DateTime.now();
    _startTimer();
    _getBatteryLevel();
  }

  @override
  void dispose() {
    _timer.cancel();
    _batteryTimer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1), (_) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentTime = DateFormat('HH:mm').format(_currentTime);
    return BlocConsumer<EmergencyContactsBloc, EmergencyContactsState>(
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
      else if (state is GetAllEmergencyContactsDetailState) {
        requestEmergencyContactsDetail = state.emergencyContactsDetail;
      }
    }, builder: (context, state) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.055,
            right: MediaQuery.of(context).size.height * 0.025,
            left: MediaQuery.of(context).size.width * 0.07,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentTime,
                style: const TextStyle(fontSize: 55, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.41,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: InkWell(
                        onLongPress: widget.onSOSPress? () {
                          _callNumbersFromEmergencyContacts();
                          // getCurrentLocation();
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (ctx) => const SOSScreen(),
                          //   ),
                          // );
                        } :(){},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'SOS',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            SvgPicture.asset(
                              AppImages.appbarSiren,
                              width: MediaQuery.of(context).size.width *0.13,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: InkWell(
                        onTap: widget.onInicioPress? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => ElderlyHomeScreen(),
                            ),
                          );
                        } : (){},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Inicio',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            SvgPicture.asset(
                              AppImages.appbarHome,
                              width: MediaQuery.of(context).size.width *0.11
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '$batteryLevel%',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            SvgPicture.asset(
                              AppImages.appbarBattery,
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                          ],
                        ),
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
  }
}