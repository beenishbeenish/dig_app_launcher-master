import 'package:flutter/material.dart';

import '../Utils/colors.dart';


class NameWithIconButton extends StatelessWidget {

  final String name;
  final IconData icon;
  final Function()? whenPress;
  const NameWithIconButton({Key? key, required this.name, required this.icon, required this.whenPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kColorPrimary,
          shape: RoundedRectangleBorder( //to set border radius to button
              borderRadius: BorderRadius.circular(8)
          ),
        ),
        onPressed: whenPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black, size: MediaQuery.of(context).size.width * 0.08),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Text(
              name,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}