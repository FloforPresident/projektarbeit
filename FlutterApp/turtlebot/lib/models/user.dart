import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String username;
  String password;

  User({this.username, this.password});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(username: json['username'], password: json['password']);

  Map<String, dynamic> toJson() => {"username": username, "password": password};
}
