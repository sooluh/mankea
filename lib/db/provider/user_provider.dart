import 'package:flutter/foundation.dart';
import 'package:mankea/db/helper/user_helper.dart';
import 'package:mankea/db/model/user.dart';

class UserProvider extends ChangeNotifier {
  List<User> data = [];
  late UserHelper helper;

  List<User> get users => data;

  UserProvider() {
    helper = UserHelper();
    findAll();
  }

  Future<void> insert(User user) async {
    await helper.insert(user);
    findAll();
  }

  void findAll() async {
    data = await helper.findAll();
    notifyListeners();
  }

  Future<User?> find(int id) async {
    return helper.find(id);
  }

  Future<User?> findBy(String column, dynamic value) async {
    return helper.findBy(column, value);
  }

  void update(User user) async {
    await helper.update(user);
  }

  void delete(int id) async {
    await helper.delete(id);
    findAll();
  }
}
