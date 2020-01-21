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
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistica lunara"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 200.0),
            child: RaisedButton(
              child: Text(
                dateFormat.format(currentDate).toString().toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              color: Colors.green,
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
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Text("Contabilitatea pe luna ${dateFormat.format(currentDate).toString().toUpperCase()}", style: TextStyle(fontSize: 30), overflow: TextOverflow.fade,),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(100.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) =>
                            EntryItem(dummyArray[index]),
                        itemCount: dummyArray.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final dummyArray = [
    Day("azi", "20 lei", [DayItem("Felul 1", "10", "15")]),
    Day("azi", "20 lei", [DayItem("Felul 1", "10", "15")]),
    Day("azi", "20 lei", [DayItem("Felul 1", "10", "15")])
  ];
}

class EntryItem extends StatelessWidget {
  final Day dayItem;

  EntryItem(this.dayItem);

  Widget _buildTiles(Day root) {
    return ExpansionTile(
      key: PageStorageKey<Day>(root),
      title: Text(root.date),
      children: root.items
          .map((dayItem) => ListTile(
                title: Text(dayItem.name),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(dayItem);
  }
}

class Day {
  String date;
  String totalAmount;
  List<DayItem> items;

  Day(this.date, this.totalAmount, this.items);
}

class DayItem {
  String name;
  String quantity;
  String amount;

  DayItem(this.name, this.quantity, this.amount);
}
