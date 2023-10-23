import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:dig_app_launcher/Popup/add_medicine_popup.dart';
import 'package:dig_app_launcher/Popup/alert_dialog_popup.dart';
import 'package:dig_app_launcher/Popup/days_popup.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/hour_dropdown.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/medicine_images.dart';
import 'package:dig_app_launcher/Widgets/minute_dropdown.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:dig_app_launcher/Widgets/time_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'MedicineBloc/medicine_bloc.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({Key? key}) : super(key: key);

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {

  final formKey = GlobalKey<FormState>();
  TextEditingController medicineNameController = TextEditingController();
  bool isAllDaysSelected = false;
  late List<String> selectedDays;

  String timeHour = '00';
  String timeMinute = '00';
  String dayTime = 'Mañana';
  String selectedImage = '';

  late MedicineBloc _medicineBloc;

  void onDayCheckboxChanged(String day, bool value) {
    setState(() {
      if (day == 'Todos los días') {
        isAllDaysSelected = value;
        if (value) {
          selectedDays = ['Todos los días'];
          // Unselect all other checkboxes
          for (String selectedDay in selectedDays) {
            if (selectedDay != 'Todos los días') {
              selectedDays.remove(selectedDay);
            }
          }
        } else {
          selectedDays = [];
        }
      } else {
        selectedDays.remove('Todos los días');
        if (value) {
          selectedDays.add(day);
          // Unselect "Todos los días" checkbox if any other checkbox is selected
          isAllDaysSelected = false;
        } else {
          selectedDays.remove(day);
        }
      }
    });
  }

  bool _hasSpecialCharacters(String value) {
    final pattern = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return pattern.hasMatch(value);
  }

  @override
  void initState() {
    _medicineBloc = BlocProvider.of<MedicineBloc>(context);
    selectedDays = [];
    super.initState();
  }

  @override
  void dispose() {
    medicineNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicineBloc, MedicineState>(
      listener: (context, state) async {
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
        else if (state is DataStoredState) {
          String medicineName = medicineNameController.text;
          int hour = int.parse(timeHour);
          int minute = int.parse(timeMinute);

          DateTime now = DateTime.now();

          DateTime selectedTime = DateTime(
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );

          // Check if the selected time has already passed for today
          if (selectedTime.isBefore(now)) {
            // If the selected time has already passed, set the alarm for the next day
            selectedTime = selectedTime.add(const Duration(days: 1));
          }

          final alarmSettings = AlarmSettings(
            id: Random().nextInt(10000000),
            dateTime: selectedTime,
            assetAudioPath: 'assets/marimba.mp3',
            loopAudio: true,
            vibrate: true,
            fadeDuration: 3.0,
            notificationTitle: 'Hora de la medicina',
            notificationBody: 'Toma tu medicina $medicineName',
            enableNotificationOnKill: true,
          );

          // Set the alarm
          await Alarm.set(alarmSettings: alarmSettings);
          Navigator.pop(context);
        }
      }, builder: (context, state) {
      return Scaffold(
        appBar: const AppbarLogo(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.1),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.09, vertical: MediaQuery.of(context).size.height * 0.02
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
                        'Inicio > Pastillas',
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
              Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.07),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: medicineNameController,
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (name) {
                          if (name == null || name.isEmpty) {
                            return 'Introduce un nombre válido';
                          }
                          else if (name.length >= 24) {
                            return 'Introduzca un máximo de 24 caracteres';
                          }
                          else if (_hasSpecialCharacters(name)) {
                            return 'Caracteres especiales no están permitidos';
                          }
                          else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          prefixIcon: SizedBox(),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: 'Nombre pastilla',
                          hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Hora",
                              style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.035),
                            HourDropDown(onHourSelected: (value) {
                              setState(() {
                                timeHour = value;
                              });
                            },
                            selectedHour: timeHour,
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                            MinuteDropDown(onMinuteSelected: (value) {
                              setState(() {
                                timeMinute = value;
                              });
                            },
                            selectedMinute: timeMinute,
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                            TimeDropDown(onDayTimeSelected: (value) {
                              setState(() {
                                dayTime = value;
                              });
                            },
                            selectedTime: dayTime,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DaysCheckbox(day: 'Lunes', selectedDays: selectedDays, onCheckedChanged: onDayCheckboxChanged,),
                          DaysCheckbox(day: 'Martes', selectedDays: selectedDays, onCheckedChanged: onDayCheckboxChanged,),
                          DaysCheckbox(day: 'Miércoles', selectedDays: selectedDays, onCheckedChanged: onDayCheckboxChanged,),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DaysCheckbox(day: 'Jueves', selectedDays: selectedDays, onCheckedChanged: onDayCheckboxChanged,),
                          DaysCheckbox(day: 'Viernes', selectedDays: selectedDays, onCheckedChanged: onDayCheckboxChanged,),
                          DaysCheckbox(day: 'Sábado', selectedDays: selectedDays, onCheckedChanged: onDayCheckboxChanged,),
                        ],
                      ),
                      Row(
                        children: [
                          DaysCheckbox(day: 'Domingo', selectedDays: selectedDays, onCheckedChanged: onDayCheckboxChanged,),
                          DaysCheckbox(day: 'Todos los días', selectedDays: selectedDays, onCheckedChanged: onDayCheckboxChanged,),
                        ],
                      ),
                      MedicineImageSelector(onImageSelected: (value) {
                        setState(() {
                          selectedImage = value;
                        });
                      },
                      selectedImage: selectedImage,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                        child: Container(
                          color: const Color(0xffF2FFCD),
                          child: const Text(
                            'Se configurará una alarma a la hora indicada',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      Center(
                        child: MyButton(
                          whenPress: (){
                            String medicineName = medicineNameController.text;
                            if(formKey.currentState!.validate() && medicineNameController.text.isNotEmpty && timeHour.isNotEmpty && timeMinute.isNotEmpty && dayTime.isNotEmpty && selectedImage.isNotEmpty && selectedDays.isNotEmpty) {
                              _medicineBloc.add(SaveMedicineDetailEvent(name: medicineName, timeHour: timeHour, timeMinute: timeMinute, dayTime: dayTime, days: selectedDays, image: selectedImage));
                            }
                            else{
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: AlertDialogPopup(
                                      text: "No ingresó el nombre del medicamento, la hora, los días o el color",
                                      isVisible: true,
                                    ),
                                  ),
                                )
                              );
                            }
                          },
                          name: "Guardar pastilla",
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      Center(
                        child: MyButton(
                          whenPress: (){
                            Navigator.pop(context);
                          },
                          name: "Volver al listado",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.025, bottom: MediaQuery.of(context).size.height * 0.02,
                            right: MediaQuery.of(context).size.width * 0.05
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: HelpButton(widget: const AddMedicinePopup()),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}