import 'package:flutter/material.dart';
import 'package:pasaj_statistics/models/dailyOrders.dart';
import 'package:intl/intl.dart';
import 'package:pasaj_statistics/utils/sizeConfig.dart';

class DailyStatisticsWidget extends StatelessWidget {
  final DailyOrders dayItem;
  final dayFormat = DateFormat.MMMMd('ro');

  DailyStatisticsWidget(this.dayItem);

  Widget _buildTiles(DailyOrders dailyOrders) {
    return ExpansionTile(
      key: PageStorageKey<DailyOrders>(dailyOrders),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: Text(
            dayFormat.format(dailyOrders.date),
            style: TextStyle(fontSize: SizeConfig.blockSizeVertical *2.8),
          ),),
          Expanded(
            child: Text("Total de plata: ${dailyOrders.totalAmount} LEI",
                style: TextStyle(fontSize: SizeConfig.blockSizeVertical *2.8), textAlign: TextAlign.end),
          ),
        ],
      ),
      children: dailyOrders.items
          .map((dayItem) => ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        dayItem.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical *2.4),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Cantitate: ${dayItem.quantity}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical *2.4),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Total: ${dayItem.amount} LEI",
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical *2.4),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(dayItem);
  }
}
