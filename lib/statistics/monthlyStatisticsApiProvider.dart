import 'package:http/http.dart' as http;
import 'package:pasaj_statistics/models/dailyOrders.dart';
import 'package:pasaj_statistics/models/user.dart';
import 'package:intl/intl.dart';

class MonthlyStatisticsApiProvider {

  String apiUrl =
      "https://deliverypasaj.herokuapp.com/api/";

  Future<List<DailyOrders>> fetchMonthlyOrder(DateTime selectedDate, int userId) async {
    final iso1086Date = DateFormat("yyyy-MM-dd").format(selectedDate);
    String url = "${apiUrl}orders/monthlyCount?month=$iso1086Date";

    if(userId  >= 0)  url += "&userID=$userId";

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return dailyOrdersFromJson(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<List<User>> fetchUsers() async {
    final response = await http.get("${apiUrl}users");

    if (response.statusCode == 200) {
      return usersFromJson(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }
}
