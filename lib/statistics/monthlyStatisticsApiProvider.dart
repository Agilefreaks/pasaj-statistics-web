import 'package:http/http.dart' as http;
import 'package:pasaj_statistics/models/dailyOrders.dart';
import 'package:pasaj_statistics/models/user.dart';
import 'package:intl/intl.dart';

class MonthlyStatisticsApiProvider {

  String apiUrl =
      "https://deliverypasaj.herokuapp.com/api/";

  Future<List<DailyOrders>> fetchMonthlyOrder(DateTime selectedStartDate, DateTime selectedEndDate , int userId) async {
    final iso1086StartDate = DateFormat("yyyy-MM-dd").format(selectedStartDate);
    final iso1086EndDate = DateFormat("yyyy-MM-dd").format(selectedEndDate);

    String url = "${apiUrl}orders/monthlyCount?startDate=$iso1086StartDate&endDate=$iso1086EndDate";

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
