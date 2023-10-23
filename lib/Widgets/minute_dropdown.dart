import 'package:flutter/material.dart';

class MinuteDropDown extends StatefulWidget {

  final ValueChanged<String> onMinuteSelected;
  final String selectedMinute;
  const MinuteDropDown({Key? key, required this.onMinuteSelected, required this.selectedMinute}) : super(key: key);

  @override
  State<MinuteDropDown> createState() => _HourDropDownState();
}

class _HourDropDownState extends State<MinuteDropDown> {

  late String selectedValue;

  @override
  void initState() {
    selectedValue = widget.selectedMinute;
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
                padding: EdgeInsets.only(top: 2),
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
                padding: EdgeInsets.symmetric(vertical: 5),
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
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '23',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '24',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '24',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '25',
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  '25',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '26',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '26',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '27',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '27',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '28',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '28',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '29',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '29',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '30',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '30',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '31',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '31',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '32',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '32',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '33',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '33',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '34',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '34',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '35',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '35',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '36',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '36',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '37',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '37',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '38',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '38',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '39',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '39',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '40',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '40',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '41',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '41',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '42',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '42',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '43',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '43',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '44',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '44',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '45',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '45',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '46',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '46',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '47',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '47',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '48',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '48',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '49',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '49',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '50',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '50',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '51',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '51',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '52',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '52',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '53',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '53',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '54',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '54',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '55',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '55',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '56',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '56',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '57',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '57',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '58',
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '58',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            const PopupMenuItem<String>(
              value: '59',
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  '59',
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
          widget.onMinuteSelected(value); // Pass the selected value back to the parent widget
        },
      ),
    );
  }
}