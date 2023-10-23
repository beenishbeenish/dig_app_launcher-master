import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {

  Widget widget;
  HelpButton({Key? key, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffF5F5F5),
          shape: RoundedRectangleBorder( //to set border radius to button
            borderRadius: BorderRadius.circular(8)
          ),
        ),
        onPressed: (){
          showDialog(
            context: context,
            builder: (_) => Dialog(
              insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04, right: MediaQuery.of(context).size.width * 0.04),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: widget,
                ),
              ),
            )
          );
        },
        child: const Text(
          '¿Necesitas ayuda?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}