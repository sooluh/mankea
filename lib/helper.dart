import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class Config {
  static var primaryColor = 0xFF55BCAB;
  static var shimmerColor = 0xFFE8E8E8;
  static var labelColor = 0xFF808080;
  static var blackColor = 0xFF333333;
}

class FontSize {
  static var h1 = 17.toDouble();
  static var h2 = 15.toDouble();
  static var h3 = 14.toDouble();
  static var h4 = 13.toDouble();
  static var h5 = 12.toDouble();
  static var h6 = 11.toDouble();
}

class PaddingSize {
  static var logo = const EdgeInsets.only(top: 20, left: 10, right: 10);
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

Future<void> openBrowser(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

void showAlert(
  BuildContext context,
  String title,
  String message,
  DialogType type,
) {
  AwesomeDialog dialog = AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    dialogType: type,
    title: title,
    titleTextStyle: TextStyle(fontSize: FontSize.h1, fontFamily: 'Poppins'),
    desc: message,
    descTextStyle: TextStyle(fontSize: FontSize.h3, fontFamily: 'Poppins'),
    btnOkOnPress: () {},
    btnOkColor: Color(Config.primaryColor),
  );

  dialog.show();
}
