import 'dart:convert';


List<DailyOrders> dailyOrdersFromJson(String str) => List<DailyOrders>.from(json.decode(str).map((x) => DailyOrders.fromJson(x)));

String dailyOrdersToJson(List<DailyOrders> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DailyOrders {
  DateTime date;
  List<Item> items;
  int totalAmount;

  DailyOrders({
    this.date,
    this.items,
    this.totalAmount,
  });

  factory DailyOrders.fromJson(Map<String, dynamic> json) => DailyOrders(
    date: DateTime.parse(json["date"]),
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "date": date.toIso8601String(),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "totalAmount": totalAmount,
  };
}

class Item {
  int amount;
  int quantity;
  String name;

  Item({
    this.amount,
    this.quantity,
    this.name,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    amount: json["amount"],
    quantity: json["quantity"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "quantity": quantity,
    "name": name,
  };
}
