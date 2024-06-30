class User {
  late int? id;
  late String username;
  late String password;
  late String name;
  late String email;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.email,
  });

  Future<Map<String, dynamic>> toMap() async {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'email': email,
    };
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    username = map['username'];
    password = map['password'];
    name = map['name'];
    email = map['email'];
  }
}
