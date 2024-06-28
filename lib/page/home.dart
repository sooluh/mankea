import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mankea/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String? name, username;

  static const List<Map<String, String>> staticData = [
    {'label': 'Nama', 'value': 'Suluh Sulistiawan'},
    {'label': 'NIM', 'value': '211351143'},
    {'label': 'Kelas', 'value': 'Informatika Malam B'},
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
    });
  }

  Future<void> refresh() async {
    // TODO: refresh data from api
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Mankea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            centerTitle: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () async {
                    // TODO: open profile page
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name ?? 'Memuat ...',
                            style: TextStyle(
                              fontSize: FontSize.h3,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            username ?? 'memuat ...',
                            style: TextStyle(
                              fontSize: FontSize.h5,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            systemOverlayStyle: SystemUiOverlayStyle.light,
            backgroundColor: Color(AppColor.primaryColor),
            elevation: 0,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          key: GlobalKey<RefreshIndicatorState>(),
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 15,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ...staticData.asMap().keys.expand((i) => <Widget>[
                                if (i != 0)
                                  Divider(
                                    color: Colors.grey.withOpacity(0.2),
                                    height: 1,
                                    thickness: 1,
                                  ),
                                ListTile(
                                  title: Text(
                                    staticData[i]['label']!,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: FontSize.h2),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Text(
                                      staticData[i]['value']!,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: FontSize.h4,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
