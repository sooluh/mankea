import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mankea/service/notification_service.dart';
import 'package:mankea/service/user_service.dart';
import 'package:mankea/model/user.dart';
import 'package:mankea/splash.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  NotificationService().init();

  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  MainState createState() => MainState();
}

class MainState extends State<Main> {
  @override
  void initState() {
    super.initState();

    if (mounted) {
      init();
    }
  }

  init() async {
    await userDefault();
  }

  Future<void> userDefault() async {
    var userService = UserService();
    var user = await userService.find(1);

    if (user == null) {
      var object = User.fromMap({
        'id': 1,
        'username': 'suluh',
        'password': md5.convert(utf8.encode('suluh')).toString(),
        'name': 'Suluh Sulistiawan',
        'email': 'xor@sesulih.my.id',
      });

      await userService.insert(object);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
