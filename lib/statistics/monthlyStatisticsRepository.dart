import 'package:pasaj_statistics/models/monthlyOrder.dart';
import 'package:pasaj_statistics/statistics/monthlyStatisticsApiProvider.dart';

class MonthlyStatisticsRepository {
  final monthlyStatisticsApiProvider = MonthlyStatisticsApiProvider();

  Future<MonthlyOrder> fetchAllOrdersPerMonth() =>
      monthlyStatisticsApiProvider.fetchMonthlyOrder();
}
