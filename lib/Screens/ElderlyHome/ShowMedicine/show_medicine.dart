import 'package:auto_size_text/auto_size_text.dart';
import 'package:dig_app_launcher/Helper/DBModels/letter_size_model.dart';
import 'package:dig_app_launcher/Helper/DBModels/medicine_model.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddMedicine/MedicineBloc/medicine_bloc.dart';
import 'package:dig_app_launcher/Screens/ElderlyHome/ShowMedicine/medicine_amplifier.dart';
import 'package:dig_app_launcher/Utils/app_images.dart';
import 'package:dig_app_launcher/Widgets/appbar.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowMedicineScreen extends StatefulWidget {
  const  ShowMedicineScreen({Key? key}) : super(key: key);

  @override
  State<ShowMedicineScreen> createState() => _ShowMedicineScreenState();
}

class _ShowMedicineScreenState extends State<ShowMedicineScreen> {

  int titleFont = 22;
  int textFont = 16;

  int index = 0;
  late MedicineBloc _medicineBloc;
  RequestMedicineDetail? requestMedicineDetail;
  RequestLetterSizeDetail? requestLetterSizeDetail;

  @override
  void initState() {
    _medicineBloc = BlocProvider.of<MedicineBloc>(context);
    _medicineBloc.add(GetAllMedicineEvent());
    _medicineBloc.add(GetLetterSizeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicineBloc, MedicineState>(
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
        else if (state is GetAllMedicineDetailState) {
          requestMedicineDetail = state.medicineDetail;
        }
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
      }, builder: (context, state) {
      return Scaffold(
        appBar: Appbar(onSOSPress: true, onInicioPress: true),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: MyButton(
          name: "Volver",
          whenPress: (){
            Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.09, right: MediaQuery.of(context).size.width * 0.09,
                  top: MediaQuery.of(context).size.height * 0.02
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Tus Pastillas',
                      style: TextStyle(fontSize: titleFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 2),
                    Divider(
                      height: 1,
                      thickness: 1.5,
                      color: const Color(0xffD0D0D0),
                      endIndent: MediaQuery.of(context).size.width * 0.075,
                    ),
                  ],
                ),
              ),
              requestMedicineDetail != null && requestMedicineDetail!.medicineDetailList!.isNotEmpty ?
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.09, right: MediaQuery.of(context).size.width * 0.09,
                      top: 2, bottom: MediaQuery.of(context).size.height * 0.025
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        '1 pastilla de 6',
                        style: TextStyle(fontSize: textFont.toDouble(), color: Colors.black),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.22),
                        child: InkWell(
                          onTap: (){
                            index != 0?
                            setState(() {
                              print(index);
                              index--;
                            }) :
                            index = index;
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.black,
                            size: 45,
                          ),
                        ),
                      ),
                      Container(
                        // height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.75,
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            requestMedicineDetail != null && requestMedicineDetail!.medicineDetailList!.isNotEmpty ?
                            Center(
                              child: Transform.rotate(
                                angle: 90 * (3.1415926535897932 / 180),
                                child: SvgPicture.asset(
                                  requestMedicineDetail!.medicineDetailList![index].medicineImage,
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  width: MediaQuery.of(context).size.width * 0.65,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ): Container(height: MediaQuery.of(context).size.height * 0.2),
                            InkWell(
                              onTap: requestMedicineDetail != null && requestMedicineDetail!.medicineDetailList!.isNotEmpty ?(){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => MedicineAmplifierScreen(image: requestMedicineDetail!.medicineDetailList![index].medicineImage),
                                  ),
                                );
                              } : (){},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    AppImages.magnifier,
                                    height: MediaQuery.of(context).size.height * 0.02,
                                  ),
                                  const SizedBox(width: 7),
                                  const Text(
                                    'Ampliar imagen',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                            AutoSizeText(
                              requestMedicineDetail != null && requestMedicineDetail!.medicineDetailList!.isNotEmpty ? requestMedicineDetail!.medicineDetailList![index].medicineName : 'Medicine Name',
                              style: TextStyle(fontSize: textFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
                              maxLines: 1,
                            ),
                            AutoSizeText(
                              requestMedicineDetail != null && requestMedicineDetail!.medicineDetailList!.isNotEmpty ? "${requestMedicineDetail!.medicineDetailList![index].medicineHour}:${requestMedicineDetail!.medicineDetailList![index].medicineMinute} de la ${requestMedicineDetail!.medicineDetailList![index].medicineTime}" : '9:00 de la mañana',
                              style: TextStyle(fontSize: textFont.toDouble(), color: Colors.black),
                              maxLines: 1,
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                            AutoSizeText(
                              requestMedicineDetail!.medicineDetailList![index].medicineDays,
                              style: TextStyle(fontSize: textFont.toDouble(), color: Colors.black),
                              maxLines: 7,
                            ),
                            // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            // Container(
                            //   padding: const EdgeInsets.all(2),
                            //   decoration: BoxDecoration( //to set border radius to button
                            //     borderRadius: BorderRadius.circular(8),
                            //     color: Color(0xff6ECB42),
                            //   ),
                            //   child: AutoSizeText(
                            //     'Miércoles',
                            //     style: TextStyle(fontSize: textFont.toDouble(), color: Colors.black),
                            //   ),
                            // ),
                            // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            // AutoSizeText(
                            //   'Viernes',
                            //   style: TextStyle(fontSize: textFont.toDouble(), color: Colors.black),
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.22),
                        child: InkWell(
                          onTap: () {
                            index < (requestMedicineDetail!.medicineDetailList!.length - 1)?
                            setState(() {
                              print(index);
                              index++;
                            }) :
                            index = index;
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.black,
                            size: 45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ) :
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "No pastillas guardados todavía",
                    style: TextStyle(fontSize: textFont.toDouble(), fontWeight: FontWeight.bold, color: Colors.black),
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