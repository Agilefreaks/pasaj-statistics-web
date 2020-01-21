import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

class MonthlyStatisticsPage extends StatefulWidget {
  @override
  _MonthlyStatisticsPageState createState() => _MonthlyStatisticsPageState();
}

class _MonthlyStatisticsPageState extends State<MonthlyStatisticsPage> {
  DateTime currentDate = new DateTime.now();
  DateTime selectedDateTime;

  final dateFormat = DateFormat.MMMM('ro');

  @override
  void initState() {
    Intl.defaultLocale = 'ro';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        RaisedButton(
          child: Text(dateFormat.format(currentDate).toString().toUpperCase()),
          onPressed: () async {
            showMonthPicker(context: context, initialDate: currentDate)
                .then((date) {
              if (date != null) {
                setState(() {
                  currentDate = date;
                });
              }
            });
          },
        )
      ],
    ));
  }
}
