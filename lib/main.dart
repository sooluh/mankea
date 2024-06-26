import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mankea/db/helper/user_helper.dart';
import 'package:mankea/db/model/user.dart';
import 'package:mankea/db/provider/user_provider.dart';
import 'package:mankea/splash.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    var helper = UserHelper();
    var user = await helper.find(1);

    if (user == null) {
      var object = User.fromMap({
        'id': 1,
        'username': 'suluh',
        'password': 'suluh',
        'name': 'Suluh Sulistiawan',
      });

      await helper.insert(object);
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
