import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String name;
  String surname;
  List<String> chats;
  List<String> dogReports;
  String token;

  User({
    required this.username,
    required this.name,
    required this.surname,
    required this.chats,
    required this.dogReports,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      chats: List<String>.from(json['chats'] ?? []),
      dogReports: List<String>.from(json['dogReports'] ?? []),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'surname': surname,
      'chats': chats,
      'dogReports': dogReports,
      'token': token,
    };
  }
}
