import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonthlyStatisticsPage extends StatefulWidget {
  @override
  _MonthlyStatisticsPageState createState() => _MonthlyStatisticsPageState();
}

class _MonthlyStatisticsPageState extends State<MonthlyStatisticsPage> {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        DropdownButton<String>(
          value: dropdownValue,
          elevation: 16,
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['One', 'Two', 'Free', 'Four']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ],
    ));
  }
}
