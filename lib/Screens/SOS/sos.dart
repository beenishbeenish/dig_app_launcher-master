import 'dart:async';

import 'package:dig_app_launcher/Screens/ElderlyHome/elderly_home.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({Key? key}) : super(key: key);

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {

  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight+35),
        child: Container(
          height: MediaQuery.of(context).size.height*0.2,
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.055, right: MediaQuery.of(context).size.height * 0.025,
                left: MediaQuery.of(context).size.width * 0.07),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('hh:mm').format(_currentTime),
                  style: const TextStyle(color: Colors.black, fontSize: 55, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'SOS',
                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Container(
                            height: 55,
                            child: Image.asset('assets/images/heartbeatappbar.png')
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: (){
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (ctx) => const ElderlyHomeScreen(),
                        //   ),
                        // );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Inicio',
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '',
                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.08,
            top: MediaQuery.of(context).size.height * 0.02
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SOS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Divider(
              height: 1,
              thickness: 1.5,
              color: const Color(0xffD0D0D0),
              endIndent: MediaQuery.of(context).size.width * 0.075,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.6,
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4, color: Color(0xff959595),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Llamando',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Divider(
              height: 1,
              thickness: 1.5,
              color: const Color(0xffD0D0D0),
              endIndent: MediaQuery.of(context).size.width * 0.075,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Center(
              child: MyButton(
                name: "Cancelar",
                whenPress: (){
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}