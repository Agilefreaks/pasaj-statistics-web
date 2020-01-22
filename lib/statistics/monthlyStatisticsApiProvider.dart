import 'package:http/http.dart' as http;
import 'package:pasaj_statistics/models/dailyOrders.dart';

class MonthlyStatisticsApiProvider {

  String url =
      "https://dev-deliverypasaj.herokuapp.com/api/orders/monthlyCount?month=";

  Future<List<DailyOrders>> fetchMonthlyOrder(DateTime currentDate) async {
    final response = await http.get("$url$currentDate");

    if (response.statusCode == 200) {
      return monthlyOrderFromJson(response.body);
    } else {
      //handle error
      throw Exception('Failed to load post');
    }
  }
}
