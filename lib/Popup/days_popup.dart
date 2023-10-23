import 'package:dig_app_launcher/Utils/colors.dart';
import 'package:flutter/material.dart';

class DaysCheckbox extends StatefulWidget {

  final String day;
  final void Function(String, bool) onCheckedChanged;
  final List<String> selectedDays;
  const DaysCheckbox({Key? key, required this.day, required this.onCheckedChanged, required this.selectedDays}) : super(key: key);

  @override
  State<DaysCheckbox> createState() => _DaysCheckboxState();
}

class _DaysCheckboxState extends State<DaysCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.selectedDays.contains(widget.day);
  }

  @override
  void didUpdateWidget(DaysCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDays != widget.selectedDays) {
      setState(() {
        isChecked = widget.selectedDays.contains(widget.day);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          checkColor: kColorPrimary,
          fillColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white; // the color when checkbox is selected;
            }
            return const Color(0xffA8A8A8); //the color when checkbox is unselected;
          }),
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value ?? false;
            });
            widget.onCheckedChanged(widget.day, isChecked);
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(
          widget.day,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }
}