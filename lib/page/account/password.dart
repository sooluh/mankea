import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mankea/db/service/user_service.dart';
import 'package:mankea/page/login.dart';
import 'package:mankea/utils/config.dart';
import 'package:mankea/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Password());
}

class Password extends StatefulWidget {
  Password({super.key});

  @override
  PasswordState createState() => PasswordState();
}

class PasswordState extends State<Password> {
  Map<String, String> password = {'old': '', 'new': '', 're': ''};
  Map<String, bool> secureText = {'old': true, 'new': true, 're': true};
  GlobalKey<FormState> key = GlobalKey<FormState>();

  Map<String, String> passwordLabel = {
    'old': 'Kata Sandi Lama',
    'new': 'Kata Sandi Baru',
    're': 'Konfirmasi Kata Sandi Baru',
  };

  showHide(String type) {
    setState(() {
      secureText[type] = !secureText[type]!;
      secureText = secureText;
    });
  }

  void validation() {
    FormState? form = key.currentState;

    if (form!.validate()) {
      form.save();
      updatePassword();
    }
  }

  void showError(String message) {
    Navigator.of(context, rootNavigator: true).pop();
    Toast.show(message, duration: Toast.lengthLong, gravity: Toast.bottom);
  }

  void updatePassword() async {
    showLoading(context);

    if (password['old']!.isEmpty ||
        password['new']!.isEmpty ||
        password['re']!.isEmpty) {
      return showError('Semua bidang kata sandi harus diisi');
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    int id = preferences.getInt('id')!;
    var userService = UserService();
    var user = await userService.find(id);

    if (user == null) {
      return showError('Terjadi kesalahan, pengguna tidak dapat ditemukan');
    }

    var encoded = md5.convert(utf8.encode(password['old']!)).toString();
    bool verified = encoded == user.password;

    if (!verified) {
      return showError('Kata sandi lama salah');
    }

    if (password['new']! != password['re']!) {
      return showError('Kata sandi baru tidak sama');
    }

    user.password = password['re']!;
    var updated = await userService.update(user);

    if (!updated) {
      return showError('Terjadi kesalahan, gagal mengubah kata sandi');
    }

    await preferences.clear();

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    ToastContext().init(context);

    return MaterialApp(
      title: 'Ubah Kata Sandi',
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
            'Ubah Kata Sandi',
            style: TextStyle(fontSize: FontSize.h1, color: Colors.white),
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
        body: Form(
          key: key,
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 15),
                  ...['old', 'new', 're'].expand(
                    (type) => <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: PaddingSize.label,
                          child: Text(
                            passwordLabel[type]!,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: FontSize.h3,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: PaddingSize.textForm,
                        child: TextFormField(
                          style: TextStyle(fontSize: FontSize.h3),
                          obscureText: secureText[type]!,
                          onSaved: (value) {
                            setState(() {
                              password[type] = value!;
                              password = password;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            hintText: passwordLabel[type],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide.none,
                            ),
                            labelStyle: TextStyle(
                              fontSize: FontSize.h3,
                              color: Colors.black,
                            ),
                            hintStyle: TextStyle(
                              fontSize: FontSize.h3,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              color:
                                  Color(AppColor.primaryColor).withOpacity(0.9),
                              onPressed: () {
                                showHide(type);
                              },
                              icon: Icon(secureText[type]!
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                child: InkWell(
                  onTap: () {
                    validation();
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
                        'Simpan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: FontSize.h2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
