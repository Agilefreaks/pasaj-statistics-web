import 'dart:convert';

List<DailyOrders> monthlyOrderFromJson(String str) => List<DailyOrders>.from(
    json.decode(str).map((x) => DailyOrders.fromJson(x)));

class DailyOrders {
  double totalAmount;
  List<Item> items;
  DateTime date;

  DailyOrders({
    this.totalAmount,
    this.items,
    this.date,
  });

  factory DailyOrders.fromJson(Map<String, dynamic> json) => DailyOrders(
        totalAmount: json["totalAmount"].toDouble(),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        date: DateTime.parse(json["date"]),
      );
}

class Item {
  double amount;
  String name;
  int quantity;

  Item({
    this.amount,
    this.name,
    this.quantity,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        amount: json["amount"].toDouble(),
        name: json["name"],
        quantity: json["quantity"],
      );
}
