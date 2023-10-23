import 'package:dig_app_launcher/APIModel/get_elderlies_request.dart';
import 'package:dig_app_launcher/APIModel/get_supervisor_elderly_request.dart';
import 'package:dig_app_launcher/Screens/Configuration/configuration_screen.dart';
import 'package:dig_app_launcher/Screens/Supervisor/supervisor_configuration.dart';
import 'package:dig_app_launcher/Utils/api_services.dart';
import 'package:dig_app_launcher/Utils/app_global.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';

class ShowElderlyScreen extends StatefulWidget {
  const ShowElderlyScreen({Key? key}) : super(key: key);

  @override
  State<ShowElderlyScreen> createState() => _ShowElderlyScreenState();
}

class _ShowElderlyScreenState extends State<ShowElderlyScreen> {

  bool isLoading = false;
  String? userRole;
  List<Elderly> elderlyList = [];
  Elderly? selectedElderly;
  List<SupervisorElderly> supervisorElderlyList = [];
  SupervisorElderly? selectedSupervisorElderly;

  Future<void> _getUserRole() async {
    final appGlobal = AppGlobal();
    final role = await appGlobal.getUserRole();
    setState(() {
      userRole = role;
      isLoading = false;
    });
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    if(userRole == 'administrator'){
      GetElderlyRequest? elderlyRequest = await requestGetElderly();

      setState(() {
        if (elderlyRequest != null) {
          elderlyList = elderlyRequest.data.elderly;
        }
        isLoading = false;
      });
    }
    else if (userRole == 'supervisor'){
      GetSupervisorElderlyRequest? elderlyRequest = await requestGetSupervisorElderly();

      setState(() {
        if (elderlyRequest != null) {
          supervisorElderlyList = elderlyRequest.data.supervisorElderly;
        }
        isLoading = false;
      });
    }

  }

  @override
  void initState() {
    _getUserRole().whenComplete(() {
      fetchData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: Scaffold(
        appBar: const AppbarLogo(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.04),
                    child: const Text(
                      '¡Hola!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.07, vertical: MediaQuery.of(context).size.height * 0.025),
                    child: Column(
                      children: [
                        const Text(
                          'Gracias por usar Digabú\n\nServicios para hacer tu vida más fácil y tranquila mientras cuidas de tus familiares.',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.025),
                          child: const Text(
                            '¿A quién deseas cuidar?',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        userRole == 'administrator'?
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02, bottom: MediaQuery.of(context).size.height * 0.05),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<Elderly>(
                                  dropdownColor: Colors.white,
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                                  value: selectedElderly,
                                  onChanged: (Elderly? newValue) {
                                    setState(() {
                                      selectedElderly = newValue;
                                    });
                                  },
                                  items: elderlyList.map<DropdownMenuItem<Elderly>>((Elderly elderlyItem) {
                                    return DropdownMenuItem<Elderly>(
                                      value: elderlyItem,
                                      child: Container(
                                        padding: EdgeInsets.zero,
                                        margin: EdgeInsets.zero,
                                        child: Text(
                                          elderlyItem.userFullName,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ) :
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02, bottom: MediaQuery.of(context).size.height * 0.05),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<SupervisorElderly>(
                                  dropdownColor: Colors.white,
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                                  value: selectedSupervisorElderly,
                                  onChanged: (SupervisorElderly? newValue) {
                                    setState(() {
                                      selectedSupervisorElderly = newValue;
                                    });
                                  },
                                  items: supervisorElderlyList.map<DropdownMenuItem<SupervisorElderly>>((SupervisorElderly elderlyItem) {
                                    return DropdownMenuItem<SupervisorElderly>(
                                      value: elderlyItem,
                                      child: Container(
                                        padding: EdgeInsets.zero,
                                        margin: EdgeInsets.zero,
                                        child: Text(
                                          elderlyItem.userFullName,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        Center(
                          child: MyButton(
                            name: "Entrar",
                            whenPress: () {
                              if (selectedElderly != null) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => ConfigurationScreen(elderlyId: selectedElderly!.id, userRole: userRole ?? ''),
                                  ), (Route<dynamic> route) => false,
                                );
                              }
                              else if(selectedSupervisorElderly != null) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => SupervisorConfigrationScreen(elderlyId: selectedSupervisorElderly!.id),
                                  ), (Route<dynamic> route) => false,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const Loader(),
          ],
        ),
      ),
    );
  }
}
