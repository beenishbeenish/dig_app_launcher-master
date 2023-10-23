import 'dart:async';

import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ConfigureBluetoothScreen extends StatefulWidget {
  const ConfigureBluetoothScreen({Key? key}) : super(key: key);

  @override
  State<ConfigureBluetoothScreen> createState() => _ConfigureBluetoothScreenState();
}

class _ConfigureBluetoothScreenState extends State<ConfigureBluetoothScreen> {

  bool bluetoothStatus = false;
  FlutterBluePlus bluetooth = FlutterBluePlus.instance;
  // List<Map<String, dynamic>> availableDevices = [];
  List<ScanResult> availableDevices = [];
  Timer? timer;

  void refreshDevices() async {
    try {
      // Start scanning for nearby Bluetooth devices
      await bluetooth.startScan(timeout: const Duration(seconds: 2));

      // Retrieve the scan results
      List<ScanResult> scanResults = [];
      bluetooth.scanResults.listen((results) {
        setState(() {
          scanResults = results;
        });
      });

      // Wait for the scan to complete
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        availableDevices = scanResults;
      });
    } catch (e) {
      print('Error scanning devices: $e');
    } finally {
      // Stop scanning after retrieving the results
      bluetooth.stopScan();
    }
  }

  @override
  void initState() {
    super.initState();
    bluetooth.state.listen((state) {
      setState(() {
        bluetoothStatus = state == BluetoothState.on;
      });
    });
    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      refreshDevices();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
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
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1, vertical: MediaQuery.of(context).size.height * 0.04
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Inicio > Sonido',
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
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
                child: const Text(
                  'Configurar dispositivos',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Container(
                color: const Color(0xffF2F2F6),
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Bluetooth',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              FlutterSwitch(
                                activeColor: Colors.green,
                                width: MediaQuery.of(context).size.width * 0.12,
                                height: MediaQuery.of(context).size.height * 0.035,
                                toggleSize: MediaQuery.of(context).size.height * 0.034,
                                value: bluetoothStatus,
                                borderRadius: 30,
                                padding: 1,
                                showOnOff: false,
                                onToggle: (val) async {
                                  setState(() {
                                    bluetoothStatus = val;
                                  });
                                  if (val) {
                                    // Turn on Bluetooth
                                    await bluetooth.turnOn();
                                  } else {
                                    // Turn off Bluetooth
                                    await bluetooth.turnOff();
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.075),
                      child: const Text(
                        'Ahora visible como "iPhone"',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025, left: MediaQuery.of(context).size.width * 0.075),
                      child: const Text(
                        'MIS DISPOSITIVOS',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.015),
                        child: Column(
                          children: <Widget>[
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: availableDevices.length,
                              itemBuilder: (ctx, index) {
                                final device = availableDevices[index].device;
                                final isConnected = device.state == BluetoothDeviceState.connected;

                                void connectToDevice() async {
                                  if (!isConnected) {
                                    try {
                                      await device.connect(autoConnect: true);
                                    } catch (e) {
                                      print('Error connecting to device: $e');
                                    }
                                  }
                                }

                                void disconnectFromDevice() {
                                  if (isConnected) {
                                    device.disconnect();
                                  }
                                }
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: isConnected ? disconnectFromDevice : connectToDevice,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            device.name.isNotEmpty ? device.name : 'Unknown Device',
                                            style: const TextStyle(fontSize: 17, color: Colors.black),
                                          ),
                                          Text(
                                            isConnected ? 'Conectado' : 'No conectado',
                                            style: const TextStyle(fontSize: 17, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                                      child: const Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Color(0xffD0D0D0),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Center(
                child: MyButton(
                  name: "Volver",
                  whenPress: (){
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}





// import 'dart:async';
//
// import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
// import 'package:dig_app_launcher/Widgets/image_container.dart';
// import 'package:dig_app_launcher/Widgets/my_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:flutter_switch/flutter_switch.dart';

// class ConfigureBluetoothScreen extends StatefulWidget {
//   const ConfigureBluetoothScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ConfigureBluetoothScreen> createState() => _ConfigureBluetoothScreenState();
// }

// class _ConfigureBluetoothScreenState extends State<ConfigureBluetoothScreen> {
//
//   bool bluetoothStatus = false;
//   FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();
//   List<DiscoveredDevice> availableDevices = [];
//   StreamSubscription<DiscoveredDevice>? scanSubscription;
//   bool _isDisposed = false;
//
//   void refreshDevices() async {
//     try {
//       final scanningResult = flutterReactiveBle.scanForDevices(
//         withServices: [],
//         scanMode: ScanMode.lowLatency,
//         requireLocationServicesEnabled: true,
//       );
//
//       if (!_isDisposed) {
//         setState(() {
//           availableDevices = scanningResult as List<DiscoveredDevice>;
//         });
//       }
//     } catch (e) {
//       print('Error scanning devices: $e');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     startScan();
//   }
//
//   @override
//   void dispose() {
//     scanSubscription?.cancel();
//     _isDisposed = true;
//     super.dispose();
//   }
//
//   void startScan() {
//     scanSubscription = flutterReactiveBle.scanForDevices(
//       withServices: [],
//       scanMode: ScanMode.lowLatency,
//       requireLocationServicesEnabled: true,
//     ).listen((devices) {
//       if (!_isDisposed) {
//         setState(() {
//           availableDevices = devices as List<DiscoveredDevice>;
//         });
//       }
//     });
//   }
//
//   void stopScan() {
//     scanSubscription?.cancel();
//   }
//
//   void toggleBluetooth(bool value) {
//     if (!_isDisposed) {
//       setState(() {
//         bluetoothStatus = value;
//       });
//
//       if (value) {
//         startScan();
//       } else {
//         stopScan();
//       }
//     }
//   }
//
//   Future<void> connectToDevice(DiscoveredDevice device) async {
//     try {
//       flutterReactiveBle.connectToDevice(
//         id: device.id,
//         connectionTimeout: const Duration(seconds: 10),
//       );
//     } catch (e) {
//       print('Error connecting to device: $e');
//     }
//   }
//
//   // Future<void> disconnectFromDevice(DiscoveredDevice device) async {
//   //   try {
//   //     await flutterReactiveBle.disconnectDevice(
//   //       deviceId: device.id,
//   //       force: false,
//   //     );
//   //   } catch (e) {
//   //     print('Error disconnecting from device: $e');
//   //   }
//   // }
//
//   // Future<void> disconnectFromDevice(DiscoveredDevice device) async {
//   //   try {
//   //     await deviceConnector?.disconnectFromDevice(device.id);
//   //     // await connector.disconnectFromDevice(device.id);
//   //   } catch (e) {
//   //     print('Error disconnecting from device: $e');
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const AppbarLogo(),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.1),
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: MediaQuery.of(context).size.width * 0.1,
//               vertical: MediaQuery.of(context).size.height * 0.04,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.pop(context);
//                   },
//                   child: const Text(
//                     'Inicio > Sonido',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
//                   ),
//                 ),
//                 Divider(
//                   height: 1,
//                   thickness: 1.5,
//                   color: const Color(0xffD0D0D0),
//                   endIndent: MediaQuery.of(context).size.width * 0.2,
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
//                 child: const Text(
//                   'Configurar dispositivos',
//                   style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
//                 ),
//               ),
//               Container(
//                 color: const Color(0xffF2F2F6),
//                 padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       margin: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.white,
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.01),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Bluetooth',
//                               style: TextStyle(fontSize: 18, color: Colors.black),
//                             ),
//                             FlutterSwitch(
//                               activeColor: Colors.green,
//                               width: MediaQuery.of(context).size.width * 0.12,
//                               height: MediaQuery.of(context).size.height * 0.035,
//                               toggleSize: MediaQuery.of(context).size.height * 0.034,
//                               value: bluetoothStatus,
//                               borderRadius: 30,
//                               padding: 1,
//                               showOnOff: false,
//                               onToggle: toggleBluetooth,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.075),
//                       child: const Text(
//                         'Ahora visible como "iPhone"',
//                         style: TextStyle(fontSize: 14, color: Colors.grey),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025, left: MediaQuery.of(context).size.width * 0.075),
//                       child: const Text(
//                         'MIS DISPOSITIVOS',
//                         style: TextStyle(fontSize: 14, color: Colors.grey),
//                       ),
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       margin: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.white,
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.015),
//                         child: Column(
//                           children: <Widget>[
//                             ListView.builder(
//                               scrollDirection: Axis.vertical,
//                               shrinkWrap: true,
//                               physics: const BouncingScrollPhysics(),
//                               itemCount: availableDevices.length,
//                               itemBuilder: (ctx, index) {
//                                 final device = availableDevices[index];
//                                 final isConnected = device.connectable == DeviceConnectionState.connected;
//
//                                 return Column(
//                                   children: [
//                                     InkWell(
//                                       onTap: (){},//isConnected ? () => disconnectFromDevice(device) : () => connectToDevice(device),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             device.name.isNotEmpty ? device.name : 'Unknown Device',
//                                             style: const TextStyle(fontSize: 17, color: Colors.black),
//                                           ),
//                                           Text(
//                                             isConnected ? 'Conectado' : 'No conectado',
//                                             style: const TextStyle(fontSize: 17, color: Colors.grey),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
//                                       child: const Divider(
//                                         height: 1,
//                                         thickness: 1,
//                                         color: Color(0xffD0D0D0),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.04),
//               Center(
//                 child: MyButton(
//                   name: "Volver",
//                   whenPress: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }