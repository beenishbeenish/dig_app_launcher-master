import 'package:dig_app_launcher/Helper/DBModels/medicine_model.dart';
import 'package:dig_app_launcher/Popup/delete_medicine_popup.dart';
import 'package:dig_app_launcher/Popup/medicine_popup.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddMedicine/MedicineBloc/medicine_bloc.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddMedicine/add_medicine.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddMedicine/update_medicine.dart';
import 'package:dig_app_launcher/Utils/app_images.dart';
import 'package:dig_app_launcher/Widgets/appbar_logo.dart';
import 'package:dig_app_launcher/Widgets/help_button.dart';
import 'package:dig_app_launcher/Widgets/image_container.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:dig_app_launcher/Widgets/name_with_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({Key? key}) : super(key: key);

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {

  late MedicineBloc _medicineBloc;
  RequestMedicineDetail? requestMedicineDetail;

  @override
  void initState() {
    _medicineBloc = BlocProvider.of<MedicineBloc>(context);
    _medicineBloc.add(GetAllMedicineEvent());
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
      }, builder: (context, state) {
      return Scaffold(
        appBar: const AppbarLogo(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageContainer(imageHeight: MediaQuery.of(context).size.height * 0.1),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.09, vertical: MediaQuery.of(context).size.height * 0.025
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                requestMedicineDetail != null && requestMedicineDetail!.medicineDetailList != null && requestMedicineDetail!.medicineDetailList!.isNotEmpty?
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: requestMedicineDetail != null? requestMedicineDetail!.medicineDetailList!.length : 0,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 18.0),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Transform.rotate(
                                    angle: 90 * (3.1415926535897932 / 180),
                                    child: SvgPicture.asset(
                                      requestMedicineDetail!.medicineDetailList![index].medicineImage,
                                      height: MediaQuery.of(context).size.height * 0.06,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      requestMedicineDetail!.medicineDetailList![index].medicineName,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                      maxLines: 2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3),
                                      child: Text(
                                        "${requestMedicineDetail!.medicineDetailList![index].medicineHour} por la ${requestMedicineDetail!.medicineDetailList![index].medicineTime}",
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.68,
                                      child: Text(
                                        requestMedicineDetail!.medicineDetailList![index].medicineDays,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                        maxLines: 3,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.52),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (ctx) => UpdateMedicineScreen(medicineName: requestMedicineDetail!.medicineDetailList![index].medicineName, timeHour: requestMedicineDetail!.medicineDetailList![index].medicineHour, timeMinute: requestMedicineDetail!.medicineDetailList![index].medicineMinute, dayTime: requestMedicineDetail!.medicineDetailList![index].medicineTime, selectedDays: [requestMedicineDetail!.medicineDetailList![index].medicineDays], selectedImage: requestMedicineDetail!.medicineDetailList![index].medicineImage),
                                                ),
                                              );
                                            },
                                            child: SvgPicture.asset(
                                              AppImages.editIcon,
                                              height: MediaQuery.of(context).size.height * 0.03,
                                            ),
                                          ),
                                          SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                                          InkWell(
                                            onTap: (){
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => Dialog(
                                                    insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.075, right: MediaQuery.of(context).size.width * 0.075),
                                                    child: SizedBox(
                                                      height: MediaQuery.of(context).size.height * 0.4,
                                                      child: DeleteMedicinePopup(name: requestMedicineDetail!.medicineDetailList![index].medicineName, medicineDetail: requestMedicineDetail, index: index),
                                                    ),
                                                  )
                                              );
                                            },
                                            child: SvgPicture.asset(
                                              AppImages.deleteIcon,
                                              height: MediaQuery.of(context).size.height * 0.03,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                              child: Divider(
                                height: 1,
                                thickness: 1.5,
                                color: const Color(0xffD0D0D0),
                                indent: MediaQuery.of(context).size.width * 0.05,
                                endIndent: MediaQuery.of(context).size.width * 0.1,
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                ) :
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: const Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "No pastillas guardados todavía",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Center(
              child: NameWithIconButton(
                whenPress: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const AddMedicineScreen(),
                    ),
                  ).then((value) {
                    _medicineBloc.add(GetAllMedicineEvent());
                  });
                },
                name: "Añadir pastilla",
                icon: Icons.add_circle_outline,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            Center(
              child: MyButton(
                whenPress: (){
                  Navigator.pop(context);
                },
                name: "Volver",
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02, right: MediaQuery.of(context).size.width * 0.1),
              child: Align(
                alignment: Alignment.centerRight,
                child: HelpButton(widget: const MedicinePopup()),
              ),
            )
          ],
        ),
      );
    });
  }
}