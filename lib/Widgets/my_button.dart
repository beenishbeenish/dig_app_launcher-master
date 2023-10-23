import 'package:flutter/material.dart';

import '../Utils/colors.dart';


class MyButton extends StatelessWidget {
  final String name;
  final Function()? whenPress;

  const MyButton({Key? key, required this.name, required this.whenPress}) : super(key: key);

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
        child: Text(
          name,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
