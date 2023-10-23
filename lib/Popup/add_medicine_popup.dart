import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:flutter/material.dart';

class AddMedicinePopup extends StatefulWidget {
  const AddMedicinePopup({Key? key}) : super(key: key);

  @override
  State<AddMedicinePopup> createState() => _AddMedicinePopupState();
}

class _AddMedicinePopupState extends State<AddMedicinePopup> {
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
                    'Añadir/Editar pastilla',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const Text(
                  'Puede configurar los siguientes parámetros:',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                  child: const Text(
                    '  •  Nombre de la pastilla\n  •  Hora de toma y si es por la\n     mañana o por la tarde.\n  •  Días de la semana que tiene que\n     tomarla.\n  •  Color con el que se asocia la\n     pastilla.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const Text(
                  'Para añadirla o editarla, pulse el botón Guardar Pastilla.',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                  child: const Text(
                    'Una vez se haya dado de alta o modificado, se configuará una alarma recordatorio.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}