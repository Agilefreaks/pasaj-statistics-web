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

  final monthFormat = DateFormat.yMMMM('ro');

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
            padding: const EdgeInsets.only(right: 100.0),
            child: RaisedButton(
              child: Text(
                monthFormat.format(selectedDate).toString().toUpperCase(),
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
                    "Contabilitatea ${monthFormat.format(selectedDate).toString().toUpperCase()}",
                    style: TextStyle(fontSize: 35),
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
                            DailyStatisticsWidget(monthlyOrder[index]),
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

class DailyStatisticsWidget extends StatelessWidget {
  final DailyOrders dayItem;
  final dayFormat = DateFormat.MMMMd('ro');

  DailyStatisticsWidget(this.dayItem);

  Widget _buildTiles(DailyOrders dailyOrders) {
    return ExpansionTile(
      key: PageStorageKey<DailyOrders>(dailyOrders),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: Text(
            dayFormat.format(dailyOrders.date),
            style: TextStyle(fontSize: 25),
          )),
          Expanded(
            child: Text("Total de plata: ${dailyOrders.totalAmount} LEI",
                style: TextStyle(fontSize: 25), textAlign: TextAlign.end),
          ),
        ],
      ),
      children: dailyOrders.items
          .map((dayItem) => ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Text(dayItem.name, textAlign: TextAlign.start, style: TextStyle(fontSize: 18),),),
                    Expanded(
                        child: Text("Cantitate: ${dayItem.quantity}",
                            textAlign: TextAlign.center, style: TextStyle(fontSize: 18),), ),
                    Expanded(
                        child: Text("Total: ${dayItem.amount} LEI",
                            textAlign: TextAlign.end, style: TextStyle(fontSize: 18),), ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(dayItem);
  }
}
