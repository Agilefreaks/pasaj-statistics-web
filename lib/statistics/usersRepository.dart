import 'package:pasaj_statistics/models/user.dart';
import 'package:pasaj_statistics/statistics/monthlyStatisticsApiProvider.dart';

class UsersRepository {
  final usersApiProvider = MonthlyStatisticsApiProvider();

  Future<List<User>> fetchAllUsers() =>
      usersApiProvider.fetchUsers();
}