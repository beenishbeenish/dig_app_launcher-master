import 'package:dig_app_launcher/Utils/app_images.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {

  double imageHeight;
  ImageContainer({Key? key, required this.imageHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: imageHeight,
      decoration:  BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage(AppImages.headerImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}