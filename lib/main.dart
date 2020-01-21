import 'package:flutter/material.dart';
import 'package:pasaj_statistics/statistics/monthlyStatisticsPage.dart';

void main() => runApp(PasajStatistics());

class PasajStatistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Statistica lunara',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("asda")),
        body: MonthlyStatisticsPage(),
      ),
    );
  }
}
