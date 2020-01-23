import 'dart:convert';

List<User> usersFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

class User {
  int id;
  String lastName;
  String firstName;

  User({
    this.lastName,
    this.id,
    this.firstName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    lastName: json["lastName"],
    id: json["id"],
    firstName: json["firstName"],
  );
}