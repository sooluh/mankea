import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppColor {
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
