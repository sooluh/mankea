import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mankea/db/helper/user_helper.dart';
import 'package:mankea/helper.dart';
import 'package:mankea/page/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Login());
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  String username = '', password = '';
  bool secureText = true;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  void showHide() {
    setState(() {
      secureText = !secureText;
    });
  }

  void validation() {
    FormState? form = key.currentState;

    if (form!.validate()) {
      form.save();
      loginCheck();
    }
  }

  void showLoading() {
    AlertDialog alert = AlertDialog(
      contentPadding: const EdgeInsets.all(30),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(Config.primaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Harap tunggu ...',
              style: TextStyle(fontSize: FontSize.h3, fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => alert,
    );
  }

  void showError(String message) {
    Navigator.of(context, rootNavigator: true).pop();
    showAlert(context, 'Kesalahan', message, DialogType.error);
  }

  void loginCheck() async {
    showLoading();

    if (username.isEmpty || password.isEmpty) {
      showError('Nama pengguna dan kata sandi harus diisi');
      return;
    }

    var helper = UserHelper();
    var user = await helper.findBy('username', username);

    if (user == null) {
      showError('Nama pengguna atau kata sandi tidak tepat');
      return;
    }

    var encoded = md5.convert(utf8.encode(password)).toString();
    bool verified = encoded == user.password;

    if (!verified) {
      // security: pesan disamakan = biar ngga di bruteforce
      showError('Nama pengguna atau kata sandi tidak tepat');
      return;
    }

    Navigator.of(context, rootNavigator: true).pop();
    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setInt('id', user.id!);
    await preferences.setString('username', user.username);
    await preferences.setString('name', user.name);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
      (Route<dynamic> route) => false,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Image.asset(
                      'assets/images/login.png',
                      width: 200,
                    ),
                  ),
                  Text(
                    'Mankea',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(Config.primaryColor),
                    ),
                  ),
                  Text(
                    'Platform-Based Programming Final Exam',
                    style: TextStyle(color: Color(Config.primaryColor)),
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
                                color: Color(Config.primaryColor),
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
                          backgroundColor: Color(Config.primaryColor),
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
