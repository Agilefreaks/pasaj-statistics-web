import 'package:pasaj_statistics/models/dailyOrders.dart';
import 'package:pasaj_statistics/statistics/monthlyStatisticsApiProvider.dart';

class MonthlyStatisticsRepository {
  final monthlyStatisticsApiProvider = MonthlyStatisticsApiProvider();

  Future<List<DailyOrders>> fetchAllOrdersPerMonth(DateTime selectedStartDate, DateTime selectedEndDate, int userId) =>
      monthlyStatisticsApiProvider.fetchMonthlyOrder(selectedStartDate, selectedEndDate, userId);
}
