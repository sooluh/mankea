import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mankea/db/service/user_service.dart';
import 'package:mankea/page/home.dart';
import 'package:mankea/utils/config.dart';
import 'package:mankea/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Identity());
}

class Identity extends StatefulWidget {
  const Identity({super.key});

  @override
  IdentityState createState() => IdentityState();
}

class IdentityState extends State<Identity> {
  String name = '', email = '';
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (mounted) {
      init();
    }
  }

  init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      name = preferences.getString('name')!;
      email = preferences.getString('email')!;
    });
  }

  void validation() {
    FormState? form = key.currentState;

    if (form!.validate()) {
      form.save();
      updateProfile();
    }
  }

  void showError(String message) {
    Navigator.of(context, rootNavigator: true).pop();
    Toast.show(message, duration: Toast.lengthLong, gravity: Toast.bottom);
  }

  void updateProfile() async {
    showLoading(context);

    final validMail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);

    if (name.isEmpty || email.isEmpty) {
      return showError('Semua bidang profil harus diisi');
    }

    if (!validMail) {
      return showError('Alamat surel tidak valid');
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    int id = preferences.getInt('id')!;
    var userService = UserService();
    var user = await userService.find(id);

    if (user == null) {
      return showError('Terjadi kesalahan, pengguna tidak dapat ditemukan');
    }

    user.name = name;
    user.email = email;

    var updated = await userService.update(user);

    if (!updated) {
      return showError('Terjadi kesalahan, gagal mengubah profil');
    }

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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    ToastContext().init(context);

    return MaterialApp(
      title: 'Ubah Profil',
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
            'Ubah Profil',
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
                  Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: PaddingSize.label,
                      child: Text(
                        'Nama Lengkap',
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
                      onSaved: (value) => name = value!,
                      controller: TextEditingController(text: name),
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Nama Lengkap',
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
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: PaddingSize.label,
                      child: Text(
                        'Alamat Surel',
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
                      onSaved: (value) => email = value!,
                      keyboardType: TextInputType.emailAddress,
                      controller: TextEditingController(text: email),
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Alamat Surel',
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
                      ),
                    ),
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
