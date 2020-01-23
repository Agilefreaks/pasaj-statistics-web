import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';
import 'package:pasaj_statistics/models/dailyOrders.dart';
import 'package:pasaj_statistics/models/user.dart';
import 'package:pasaj_statistics/statistics/dailyStatisticsWidget.dart';
import 'package:pasaj_statistics/statistics/monthlyStatisticsApiProvider.dart';
import 'package:pasaj_statistics/statistics/monthlyStatisticsRepository.dart';
import 'package:pasaj_statistics/statistics/usersRepository.dart';
import 'package:pasaj_statistics/utils/sizeConfig.dart';

class MonthlyStatisticsPage extends StatefulWidget {
  @override
  _MonthlyStatisticsPageState createState() => _MonthlyStatisticsPageState();
}

class _MonthlyStatisticsPageState extends State<MonthlyStatisticsPage> {
  MonthlyStatisticsRepository monthlyStatisticsRepository =
      new MonthlyStatisticsRepository();
  UsersRepository usersRepository = new UsersRepository();

  DateTime selectedDate = new DateTime.now();
  DateTime selectedDateTime;

  final monthAndYearFormat = DateFormat.yMMMM('ro');
  final monthFormat = DateFormat.MMMM('ro');

  bool showLoading = true;
  double totalMonthlyAmount = 0;

  List<DailyOrders> monthlyOrder = [];
  final agileFreaksUser = User(id: -1, firstName: "Agile", lastName: "Freaks");
  User selectedUser;
  List<User> users = [];

  @override
  void initState() {
    Intl.defaultLocale = 'ro';

    selectedUser = agileFreaksUser;
    fetchMonthlyOrder(selectedDate, selectedUser.id);
    fetchUsers();
    super.initState();
  }

  fetchUsers() {
    setState(() {
      showLoading = true;
    });
    usersRepository.fetchAllUsers().then((result) {
      setState(() {
        users = [agileFreaksUser];
        users.addAll(result);
        showLoading = false;
      });
    });
  }

  fetchMonthlyOrder(DateTime date, int userId) {
    setState(() {
      showLoading = true;
    });
    monthlyStatisticsRepository
        .fetchAllOrdersPerMonth(date, userId)
        .then((result) {
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
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Theme(
                    data: ThemeData(canvasColor: Colors.green),
                    child: DropdownButton<User>(
                      underline: Container(
                        height: 0,
                      ),
                      value: selectedUser,
                      onChanged: (User user) {
                        setState(() {
                          selectedUser = user;
                          fetchMonthlyOrder(selectedDate, selectedUser.id);
                        });
                      },
                      items: users.map<DropdownMenuItem<User>>((User user) {
                        return DropdownMenuItem<User>(
                          value: user,
                          child: Text(
                            "${user.firstName} ${user.lastName}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                RaisedButton(
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
                    showMonthPicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2018),
                            lastDate: DateTime(2030))
                        .then((date) {
                      if (date != null) {
                        fetchMonthlyOrder(date, selectedUser.id);
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    });
                  },
                ),
              ],
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
                              "Contabilitate ${selectedUser.firstName} ${selectedUser.lastName} ${monthAndYearFormat.format(selectedDate).toString().toUpperCase()}",
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 3),
                              textAlign: TextAlign.center),
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
                                textAlign: TextAlign.end),
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
