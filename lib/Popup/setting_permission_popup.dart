import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:flutter/material.dart';

class SettingPermissionPopup extends StatefulWidget {
  const SettingPermissionPopup({Key? key}) : super(key: key);

  @override
  State<SettingPermissionPopup> createState() => _SettingPermissionPopupState();
}

class _SettingPermissionPopupState extends State<SettingPermissionPopup> {
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
                  'Configuración',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                  child: const Text(
                    'Al activar la configuración podrá modificar los siguientes aspectos de su teléfono móvil:',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                  child: const Text(
                    '  •  Letra\n  •  Establecer favoritos\n  •  Localizar\n  •  Contactos emergencia SOS\n  •  Sonido\n  •  Recordatorio Pastilla\n  •  Accesos directos a aplicaciones',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                  child: const Text(
                    'Si desactiva la opción configuración la aplicación establecerá los valores por defecto.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}