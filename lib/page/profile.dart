import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mankea/db/model/book.dart';
import 'package:mankea/page/account/identity.dart';
import 'package:mankea/page/account/password.dart';
import 'package:mankea/page/login.dart';
import 'package:mankea/utils/config.dart';
import 'package:mankea/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Profile());
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  String? name, username, email;
  List<Book>? books;

  List<Map<String, dynamic>> menus = [
    {
      'title': 'Ubah Profil',
      'subtitle': 'Perbarui detail profil',
      'icon': Icons.person,
      'color': Colors.blueAccent,
      'target': const Identity(),
    },
    {
      'title': 'Ubah Kata Sandi',
      'subtitle': 'Perbarui kata sandi akun',
      'icon': Icons.lock,
      'color': Colors.redAccent,
      'target': const Password(),
    },
  ];

  @override
  void initState() {
    super.initState();

    if (mounted) {
      init();
    }
  }

  void init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      name = preferences.getString('name');
      username = preferences.getString('username');
      email = preferences.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Profil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Color(AppColor.primaryColor),
          elevation: 0,
          title: Text(
            'Profil',
            style: TextStyle(
              fontSize: FontSize.h1,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15),
                child: Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/mankea.png'),
                    ),
                    title: Text(
                      name ?? '',
                      maxLines: 1,
                      style: TextStyle(fontSize: FontSize.h2),
                    ),
                    subtitle: Text(
                      email ?? username ?? '',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: FontSize.h4,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Akun',
                        style: TextStyle(
                          fontSize: FontSize.h3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.separated(
                        itemCount: menus.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            color: Colors.grey.withOpacity(0.2),
                            height: 1,
                            thickness: 1,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        menus[index]['target']),
                              );
                            },
                            leading: Container(
                              decoration: BoxDecoration(
                                color: menus[index]['color'],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Icon(menus[index]['icon'],
                                  color: Colors.white),
                            ),
                            title: Text(
                              menus[index]['title'],
                              maxLines: 1,
                              style: TextStyle(fontSize: FontSize.h3),
                            ),
                            subtitle: Text(
                              menus[index]['subtitle'],
                              maxLines: 1,
                              style: TextStyle(fontSize: FontSize.h4),
                            ),
                            trailing: const Icon(Icons.navigate_next),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 15),
                      child: Text(
                        'Versi Aplikasi 1.0.0',
                        style: TextStyle(fontSize: FontSize.h3),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InkWell(
                  onTap: () async {
                    showLoading(context);

                    final preferences = await SharedPreferences.getInstance();
                    await preferences.clear();

                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true).pop();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(AppColor.primaryColor),
                          Color(AppColor.primaryColor),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Keluar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: FontSize.h2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
