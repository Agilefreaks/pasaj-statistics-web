import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pasaj_statistics/models/dailyOrders.dart';
import 'package:pasaj_statistics/models/user.dart';
import 'package:pasaj_statistics/statistics/dailyStatisticsWidget.dart';
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

  DateTime selectedEndDate = new DateTime.now();
  DateTime selectedStartDate = new DateTime(DateTime.now().year, DateTime.now().month, 1);

  final dayAndMonthFormat = DateFormat.MMMMd('ro');

  bool showLoading = true;
  double totalMonthlyAmount = 0;

  List<DailyOrders> monthlyOrder = [];
  final agileFreaksUser = User(id: "agilefreaks", firstName: "Agile", lastName: "Freaks");
  User selectedUser;
  List<User> users = [];

  @override
  void initState() {
    Intl.defaultLocale = 'ro';

    selectedUser = agileFreaksUser;
    fetchMonthlyOrder(selectedStartDate, selectedEndDate, selectedUser.id);
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

  fetchMonthlyOrder(DateTime startDate, DateTime endDate, String userId) {
    setState(() {
      showLoading = true;
    });
    monthlyStatisticsRepository
        .fetchAllOrdersPerMonth(startDate, endDate, userId)
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
        title: Text(
          "Statistica lunara",
          style: TextStyle(fontSize: 20),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 6),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text("Pentru", style: TextStyle(fontSize: 20),),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Theme(
                    data: ThemeData(canvasColor: Colors.blue),
                    child: DropdownButton<User>(
                      underline: Container(
                        height: 0,
                      ),
                      value: selectedUser,
                      onChanged: (User user) {
                        setState(() {
                          selectedUser = user;
                          fetchMonthlyOrder(selectedStartDate, selectedEndDate,
                              selectedUser.id);
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
                                fontSize: 20),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text("din", style: TextStyle(fontSize: 20),),
                ),
                RaisedButton(
                  child: Text(
                    dayAndMonthFormat
                        .format(selectedStartDate)
                        .toString()
                        .toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  color: Colors.blue,
                  onPressed: () async {
                    showDatePicker(
                            context: context,
                            initialDate: selectedStartDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030))
                        .then((date) {
                      if (date != null) {
                        fetchMonthlyOrder(date, selectedEndDate,
                            selectedUser.id);
                        setState(() {
                          selectedStartDate = date;
                        });
                      }
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text("pana in", style: TextStyle(fontSize: 20),),
                ),
                RaisedButton(
                  child: Text(
                    dayAndMonthFormat
                        .format(selectedEndDate)
                        .toString()
                        .toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  color: Colors.blue,
                  onPressed: () async {
                    showDatePicker(
                            context: context,
                            initialDate: selectedEndDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030))
                        .then((date) {
                      if (date != null) {
                        fetchMonthlyOrder(selectedStartDate, date,
                            selectedUser.id);
                        setState(() {
                          selectedEndDate = date;
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
                              "Contabilitate ${selectedUser.firstName} ${selectedUser.lastName}",
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
                                "Total de plata: $totalMonthlyAmount LEI",
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
