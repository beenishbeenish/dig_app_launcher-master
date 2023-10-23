import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:flutter/material.dart';

class UpdateMedicinePopup extends StatefulWidget {
  const UpdateMedicinePopup({Key? key}) : super(key: key);

  @override
  State<UpdateMedicinePopup> createState() => _UpdateMedicinePopupState();
}

class _UpdateMedicinePopupState extends State<UpdateMedicinePopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: MediaQuery.of(context).size.height * 0.075,
        width: MediaQuery.of(context).size.width * 0.75,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorPrimary,
            shape: RoundedRectangleBorder( //to set border radius to button
                borderRadius: BorderRadius.circular(8)
            ),
          ),
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text(
            'Volver',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Ayuda',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                const Text(
                  'Pastillas',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                  child: const Text(
                    'Eliminar pastilla',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const Text(
                  'Si desea eliminar la pastilla pulse el botón SÍ, por el contrario pulse NO.',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.05),
                  child: const Text(
                    'Al eliminar la pastilla se desactiva la alarma correspondiente, siempre y cuando no tenga otra pastilla activa a la misma hora.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const Text(
                  'Podrá volver a añadirla en el momento que desee.',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}