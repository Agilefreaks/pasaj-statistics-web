import 'dart:convert';

List<MonthlyOrder> monthlyOrderFromJson(String str) => List<MonthlyOrder>.from(json.decode(str).map((x) => MonthlyOrder.fromJson(x)));

class MonthlyOrder {
    double totalAmount;
    List<Item> items;
    DateTime date;

    MonthlyOrder({
        this.totalAmount,
        this.items,
        this.date,
    });

    factory MonthlyOrder.fromJson(Map<String, dynamic> json) => MonthlyOrder(
        totalAmount: json["totalAmount"].toDouble(),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        date: DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "totalAmount": totalAmount,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "date": date.toIso8601String(),
    };
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

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "name": name,
        "quantity": quantity,
    };
}
