import 'package:dig_app_launcher/Helper/DBModels/letter_size_model.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddMedicine/MedicineBloc/medicine_bloc.dart';
import 'package:dig_app_launcher/Widgets/appbar.dart';
import 'package:dig_app_launcher/Widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MedicineAmplifierScreen extends StatefulWidget {

  String image;
  MedicineAmplifierScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<MedicineAmplifierScreen> createState() => _MedicineAmplifierScreenState();
}

class _MedicineAmplifierScreenState extends State<MedicineAmplifierScreen> {

  int titleFont = 22;

  late MedicineBloc _medicineBloc;
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
        else if (state is GetLetterSizeState) {
          requestLetterSizeDetail = state.letterSizeDetail;
          if (requestLetterSizeDetail != null && requestLetterSizeDetail!.letterSizeDetailList != null && requestLetterSizeDetail!.letterSizeDetailList!.isNotEmpty) {
            titleFont = requestLetterSizeDetail!.letterSizeDetailList!.first.titleSize;
          }
          else {
            titleFont = 22;
          }
        }
      }, builder: (context, state) {
      return Scaffold(
        appBar: Appbar(onSOSPress: true, onInicioPress: true),
        body: Column(
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
                  Text(
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
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.09, right: MediaQuery.of(context).size.width * 0.09,
                  top: 2
              ),
              child: const Text(
                '1 pastilla de 6',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.9,
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Transform.rotate(
                      angle: 90 * (3.1415926535897932 / 180),
                      child: SvgPicture.asset(
                        widget.image,
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset('assets/images/magnifier.png'),
                  const Text(
                    'Ver más de cerca',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Center(
              child: MyButton(
                name: "Cerrar Imagen",
                whenPress: (){
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
