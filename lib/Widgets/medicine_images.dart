import 'package:dig_app_launcher/Utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MedicineImageSelector extends StatefulWidget {

  final Function(String) onImageSelected;
  final String selectedImage;
  const MedicineImageSelector({Key? key, required this.onImageSelected, required this.selectedImage}) : super(key: key);

  @override
  State<MedicineImageSelector> createState() => _MedicineImageSelectorState();
}

class _MedicineImageSelectorState extends State<MedicineImageSelector> {

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildSelectableImage(0, AppImages.bluePill),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        buildSelectableImage(1, AppImages.redPill),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        buildSelectableImage(2, AppImages.greenPill),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        buildSelectableImage(3, AppImages.yellowPill),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        buildSelectableImage(4, AppImages.greyPill),
      ],
    );
  }

  Widget buildSelectableImage(int index, String imageAsset) {
    bool isSelected = imageAsset == widget.selectedImage;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        widget.onImageSelected(imageAsset); // Call the callback function with the selected image asset
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Transform.rotate(
          angle: 90 * (3.1415926535897932 / 180),
          child: SvgPicture.asset(
            imageAsset,
            height: MediaQuery.of(context).size.height * 0.06,
          ),
        ),
      ),
    );
  }
}