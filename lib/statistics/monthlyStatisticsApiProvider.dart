import 'dart:convert';

import 'package:http/http.dart';
import 'package:pasaj_statistics/models/monthlyOrder.dart';

class MonthlyStatisticsApiProvider {
  Client client = new Client();

  String url =
      "https://dev-deliverypasaj.herokuapp.com/api/orders/monthlyCount?month=";

  Future<MonthlyOrder> fetchMonthlyOrder({DateTime currentDate}) async {
    currentDate = DateTime.now();

    final response = await client.get("$url$currentDate");

    if (response.statusCode == 200) {
      return MonthlyOrder.fromJson(json.decode(response.body));
    } else {
      //handle error
      throw Exception('Failed to load post');
    }
  }
}
