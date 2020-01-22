import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';
import 'package:pasaj_statistics/models/dailyOrders.dart';
import 'package:pasaj_statistics/statistics/monthlyStatisticsApiProvider.dart';

class MonthlyStatisticsPage extends StatefulWidget {
  @override
  _MonthlyStatisticsPageState createState() => _MonthlyStatisticsPageState();
}

class _MonthlyStatisticsPageState extends State<MonthlyStatisticsPage> {
  DateTime selectedDate = new DateTime.now();
  DateTime selectedDateTime;

  final dateFormat = DateFormat.MMMM('ro');

  List<DailyOrders> monthlyOrder = [];
  MonthlyStatisticsApiProvider monthlyStatisticsApiProvider =
      new MonthlyStatisticsApiProvider();

  @override
  void initState() {
    Intl.defaultLocale = 'ro';

    fetchMonthlyOrder(selectedDate);
    super.initState();
  }

  fetchMonthlyOrder(DateTime date) {
    monthlyStatisticsApiProvider.fetchMonthlyOrder(date).then((result) {
      setState(() {
        monthlyOrder = result;
      });
    });
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
                dateFormat.format(selectedDate).toString().toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              color: Colors.green,
              onPressed: () async {
                showMonthPicker(context: context, initialDate: selectedDate)
                    .then((date) {
                  if (date != null) {
                    fetchMonthlyOrder(selectedDate);
                    setState(() {
                      selectedDate = date;
                    });
                  }
                });
              },
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Contabilitatea pe luna ${dateFormat.format(selectedDate).toString().toUpperCase()}",
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) =>
                            EntryItem(monthlyOrder[index]),
                        itemCount: monthlyOrder.length,
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
}

class EntryItem extends StatelessWidget {
  final DailyOrders dayItem;

  EntryItem(this.dayItem);

  Widget _buildTiles(DailyOrders root) {
    return ExpansionTile(
      key: PageStorageKey<DailyOrders>(root),
      title: Text(root.date.toString()),
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
