import 'package:flutter/material.dart';
import 'package:pasaj_statistics/statistics/monthlyStatisticsPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        appBar: AppBar(title: Text("Statistica lunara")),
        body: MonthlyStatisticsPage(),
      ),
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('ro'), // Hebrew
      ],
    );
  }
}
