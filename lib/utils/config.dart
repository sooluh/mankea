import 'package:flutter/material.dart';

class ApiConfig {
  static var baseUrl = Uri.parse('https://api.suluh.my.id/books');
}

class AppColor {
  static var primaryColor = 0xFFEF9C66;
  static var shimmerColor = 0xFFE8E8E8;
  static var labelColor = 0xFF808080;
  static var blackColor = 0xFF333333;
}

class FontSize {
  static var h1 = 17.0;
  static var h2 = 15.0;
  static var h3 = 14.0;
  static var h4 = 13.0;
  static var h5 = 12.0;
  static var h6 = 11.0;
}

class PaddingSize {
  static var label = const EdgeInsets.only(bottom: 2, left: 15, right: 15);
  static var textForm = const EdgeInsets.only(left: 15, right: 15, bottom: 15);
}
