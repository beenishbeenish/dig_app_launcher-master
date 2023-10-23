import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:flutter/material.dart';

class ShowContactFavoritePopup extends StatefulWidget {
  const ShowContactFavoritePopup({Key? key}) : super(key: key);

  @override
  State<ShowContactFavoritePopup> createState() => _ShowContactFavoritePopupState();
}

class _ShowContactFavoritePopupState extends State<ShowContactFavoritePopup> {
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
                  'Favoritos',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                  child: const Text(
                    '¿Qué opciones quiere que estén disponibles para la persona favorita?',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                  child: const Text(
                    '  •  Llamar\n  •  Whatsapp\n  •  Videollamada',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01, bottom: MediaQuery.of(context).size.height * 0.05),
                  child: const Text(
                    'En el momento que activa una de las opciones y pulsa en el botón de guardar esa persona quedará marcada como favorita.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const Text(
                  'Si ya es un favorito tendrá la opcion de modificar o eliminar.',
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