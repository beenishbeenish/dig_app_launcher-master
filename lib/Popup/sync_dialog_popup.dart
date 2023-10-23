import 'package:dig_app_launcher/Widgets/loader.dart';
import 'package:flutter/material.dart';

class SyncDialogPopup extends StatefulWidget {

  const SyncDialogPopup({Key? key}) : super(key: key);

  @override
  State<SyncDialogPopup> createState() => _SyncDialogPopupState();
}

class _SyncDialogPopupState extends State<SyncDialogPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              const Loader(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                child: const Text(
                  'Sincronizar datos \ncon el servidor',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}