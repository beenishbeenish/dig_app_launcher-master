import 'package:dig_app_launcher/Helper/DBModels/medicine_model.dart';
import 'package:dig_app_launcher/Screens/Configuration/AddMedicine/MedicineBloc/medicine_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeleteMedicinePopup extends StatefulWidget {

  String name;
  int index;
  RequestMedicineDetail? medicineDetail;
  DeleteMedicinePopup({Key? key, required this.name, required this.index, this.medicineDetail}) : super(key: key);

  @override
  State<DeleteMedicinePopup> createState() => _DeleteMedicinePopupState();
}

class _DeleteMedicinePopupState extends State<DeleteMedicinePopup> {

  late MedicineBloc _medicineBloc;

  @override
  void initState() {
    super.initState();
    _medicineBloc = BlocProvider.of<MedicineBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicineBloc, MedicineState>(
      listener: (context, state) {
        if (state is ErrorState) {
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
      }, builder: (context, state) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Text(
                "¿Desea eliminar la pastilla ${widget.name}?",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.075,
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF5F5F5),
                        shape: RoundedRectangleBorder( //to set border radius to button
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      onPressed: () {
                        _medicineBloc.add(DeleteMedicineEvent(medicineDetail: widget.medicineDetail!, index: widget.index));
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'SÍ',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.075,
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF5F5F5),
                        shape: RoundedRectangleBorder( //to set border radius to button
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'NO',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            ],
          ),
        ),
      );
    });
  }
}