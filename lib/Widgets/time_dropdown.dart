import 'package:flutter/material.dart';

class TimeDropDown extends StatefulWidget {

  final ValueChanged<String> onDayTimeSelected;
  final String selectedTime;
  const TimeDropDown({Key? key, required this.onDayTimeSelected, required this.selectedTime}) : super(key: key);

  @override
  State<TimeDropDown> createState() => _TimeDropDownState();
}

class _TimeDropDownState extends State<TimeDropDown> {

  late String selectedValue;

  @override
  void initState() {
    selectedValue = widget.selectedTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffA8A8A8)
        )
      ),
      child: PopupMenuButton<String>(
        color: const Color(0xffF5F5F5),
        offset: Offset(MediaQuery.of(context).size.width * 0.045, MediaQuery.of(context).size.height * 0.04),
        child: Row(
          children: [
            Text(
              ' $selectedValue',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const Icon(Icons.arrow_drop_down_outlined, color: Colors.black,)
          ],
        ),
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem<String>(
              value: 'Mañana',
              child: Text(
                'Mañana',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'Tarde',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'Tarde',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
          ];
        },
        onSelected: (String value) {
          setState(() {
            selectedValue = value;
          });
          widget.onDayTimeSelected(value); // Pass the selected value back to the parent widget
        },
      ),
    );
  }
}