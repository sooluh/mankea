import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mankea/db/service/user_service.dart';
import 'package:mankea/utils/config.dart';
import 'package:mankea/utils/helper.dart';
import 'package:mankea/page/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  String username = '', password = '', errorMessage = '';
  bool secureText = true, isError = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  static const List<Map<String, String>> staticData = [
    {'label': 'Nama', 'value': 'Suluh Sulistiawan'},
    {'label': 'NIM', 'value': '211351143'},
    {'label': 'Kelas', 'value': 'Informatika Malam B'},
    {'label': 'Kredensial Default', 'value': 'suluh:suluh'},
  ];

  void showHide() {
    setState(() {
      secureText = !secureText;
    });
  }

  void validation() {
    FormState? form = key.currentState;

    if (form!.validate()) {
      form.save();
      checkLogin();
    }
  }

  void showError(String message) {
    Navigator.of(context, rootNavigator: true).pop();

    setState(() {
      isError = true;
      errorMessage = message;
    });
  }

  void checkLogin() async {
    setState(() {
      isError = false;
      errorMessage = '';
    });

    showLoading(context);

    if (username.isEmpty || password.isEmpty) {
      return showError('Nama pengguna dan kata sandi harus diisi');
    }

    var userService = UserService();
    var user = await userService.findBy('username', username);

    if (user == null) {
      return showError('Nama pengguna atau kata sandi salah');
    }

    var encoded = md5.convert(utf8.encode(password)).toString();
    bool verified = encoded == user.password;

    if (!verified) {
      // security: pesan disamakan = biar ngga di bruteforce
      return showError('Nama pengguna atau kata sandi salah');
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setInt('id', user.id!);
    await preferences.setString('username', user.username);
    await preferences.setString('name', user.name);
    await preferences.setString('email', user.email);

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future showAuthor(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      height: 5,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
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
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
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
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    return MaterialApp(
      title: 'Masuk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: key,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        showAuthor(context);
                      },
                      child: const Icon(Icons.info),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Image.asset(
                      'assets/images/mankea.png',
                      width: 150,
                    ),
                  ),
                  Text(
                    'Mank-Ea',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(AppColor.primaryColor),
                    ),
                  ),
                  Text(
                    'Platform-Based Programming Final Exam',
                    style: TextStyle(color: Color(AppColor.primaryColor)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25,
                      left: 15,
                      right: 15,
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
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(fontSize: FontSize.h3),
                            onSaved: (value) => username = value!,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              filled: true,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  topLeft: Radius.circular(12),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.white,
                              labelStyle: TextStyle(
                                fontSize: FontSize.h3,
                                color: Colors.grey,
                              ),
                              hintText: 'Nama Pengguna',
                              hintStyle: TextStyle(
                                fontSize: FontSize.h3,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey.withOpacity(0.2),
                            height: 1,
                            thickness: 1,
                          ),
                          TextFormField(
                            style: TextStyle(fontSize: FontSize.h3),
                            onSaved: (value) => password = value!,
                            obscureText: secureText,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              filled: true,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.white,
                              labelStyle: TextStyle(
                                fontSize: FontSize.h3,
                                color: Colors.black,
                              ),
                              hintText: 'Kata Sandi',
                              hintStyle: TextStyle(
                                fontSize: FontSize.h3,
                                color: Colors.grey,
                              ),
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                color: Color(AppColor.primaryColor),
                                icon: Icon(secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isError)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 30,
                          right: 30,
                        ),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 15,
                      right: 15,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () {
                          validation();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          shadowColor: Colors.transparent,
                          backgroundColor: Color(AppColor.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: FontSize.h2,
                            color: Colors.white,
                          ),
                        ),
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
