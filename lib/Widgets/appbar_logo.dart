import 'package:dig_app_launcher/Utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Utils/colors.dart';

class AppbarLogo extends StatelessWidget implements PreferredSizeWidget {
  const AppbarLogo({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight+25);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kColorBG,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: MediaQuery.of(context).size.height*0.1,
      title: Transform(
        transform: Matrix4.translationValues(-60, 0.0, 0.0),
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
          child: SvgPicture.asset(
            AppImages.logo,
            height: MediaQuery.of(context).size.height * 0.07,
          ),
        ),
      ),
    );
  }
}