import 'package:mankea/db/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserHelper {
  static UserHelper? helper;
  static late Database instance;
  static const String tableName = 'users';

  UserHelper.internal() {
    helper = this;
  }

  factory UserHelper() => helper ?? UserHelper.internal();

  Future<Database> get database async {
    instance = await initialize();
    return instance;
  }

  Future<Database> initialize() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'users.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id BIGINT(20) PRIMARY KEY,
            username VARCHAR(255) NOT NULL,
            password VARCHAR(255) NOT NULL,
            name VARCHAR(255) NOT NULL
          )
          ''');
      },
      version: 1,
    );
  }

  Future<bool> insert(User user) async {
    final Database db = await database;

    try {
      var data = await user.toMap();
      await db.insert(tableName, data);

      return true;
    } catch (e) {
      // nothing
    }

    return false;
  }

  Future<List<User>> findAll() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(tableName);

    return results.map((res) => User.fromMap(res)).toList();
  }

  Future<User?> find(int id) async {
    final Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.isEmpty ? null : User.fromMap(results.first);
  }

  Future<User?> findBy(String column, dynamic value) async {
    final Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: '$column = ?',
      whereArgs: [value],
    );

    return results.isEmpty ? null : User.fromMap(results.first);
  }

  Future<bool> update(User user) async {
    final Database db = await database;

    try {
      var data = await user.toMap();
      await db.update(tableName, data, where: 'id = ?', whereArgs: [user.id]);

      return true;
    } catch (e) {
      // nothing
    }

    return false;
  }

  Future<bool> delete(int id) async {
    final Database db = await database;

    try {
      await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      //
    }

    return false;
  }
}
