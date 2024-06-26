import 'package:crypto/crypto.dart';
import 'dart:convert';

class User {
  late int? id;
  late String username;
  late String password;
  late String name;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.name,
  });

  Future<Map<String, dynamic>> toMap() async {
    return {
      'id': id,
      'username': username,
      'password': md5.convert(utf8.encode(password)).toString(),
      'name': name,
    };
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    username = map['username'];
    password = map['password'];
    name = map['name'];
  }
}
