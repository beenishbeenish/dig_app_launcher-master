import 'package:flutter/material.dart';

class HourDropDown extends StatefulWidget {

  final ValueChanged<String> onHourSelected;
  final String selectedHour;
  const HourDropDown({Key? key, required this.onHourSelected, required this.selectedHour}) : super(key: key);

  @override
  State<HourDropDown> createState() => _HourDropDownState();
}

class _HourDropDownState extends State<HourDropDown> {

  late String selectedValue;

  @override
  void initState() {
    selectedValue = widget.selectedHour;
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
        offset: Offset(0, MediaQuery.of(context).size.height * 0.055),
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
              value: '00',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '00',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '01',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '01',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '02',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '02',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '03',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '03',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '04',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '04',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '05',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '05',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '06',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '06',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '07',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '07',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '08',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '08',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '09',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '09',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '10',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '10',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '11',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '11',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '12',
              child: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Text(
                  '12',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '13',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '13',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '14',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '14',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '15',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '15',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '16',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '16',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '17',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '17',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '18',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '18',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '19',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '19',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '20',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '20',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '21',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '21',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '22',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '22',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '23',
              child: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Text(
                  '23',
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
          widget.onHourSelected(value); // Pass the selected value back to the parent widget
        },
      ),
    );
  }
}