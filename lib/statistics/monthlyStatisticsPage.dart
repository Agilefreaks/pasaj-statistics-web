import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';
import 'package:pasaj_statistics/models/dailyOrders.dart';
import 'package:pasaj_statistics/statistics/dailyStatisticsWidget.dart';
import 'package:pasaj_statistics/statistics/monthlyStatisticsApiProvider.dart';
import 'package:pasaj_statistics/utils/sizeConfig.dart';

class MonthlyStatisticsPage extends StatefulWidget {
  @override
  _MonthlyStatisticsPageState createState() => _MonthlyStatisticsPageState();
}

class _MonthlyStatisticsPageState extends State<MonthlyStatisticsPage> {
  DateTime selectedDate = new DateTime.now();
  DateTime selectedDateTime;

  final monthAndYearFormat = DateFormat.yMMMM('ro');
  final monthFormat = DateFormat.MMMM('ro');

  bool showLoading = true;
  double totalMonthlyAmount = 0;

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
    setState(() {
      showLoading = true;
    });
    monthlyStatisticsApiProvider.fetchMonthlyOrder(date).then((result) {
      setState(() {
        monthlyOrder = result;
        totalMonthlyAmount = 0;
        monthlyOrder.forEach((dayOrder) {
          totalMonthlyAmount += dayOrder.totalAmount;
        });
        showLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Statistica lunara"),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: SizeConfig.blockSizeVertical * 6),
            child: RaisedButton(
              child: Text(
                monthAndYearFormat
                    .format(selectedDate)
                    .toString()
                    .toUpperCase(),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 3,
              vertical: SizeConfig.blockSizeVertical * 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: showLoading,
                child: Center(child: CircularProgressIndicator()),
              ),
              Visibility(
                visible: !showLoading,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Contabilitate ${monthAndYearFormat.format(selectedDate).toString().toUpperCase()}",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical * 3),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical * 3,
                          horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Center(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    DailyStatisticsWidget(monthlyOrder[index]),
                                itemCount: monthlyOrder.length,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: SizeConfig.blockSizeVertical * 3),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Total de plata ${monthFormat.format(selectedDate).toString().toUpperCase()}: $totalMonthlyAmount LEI",
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 3),
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.fade,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
