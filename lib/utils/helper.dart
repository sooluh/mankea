import 'package:flutter/material.dart';
import 'package:mankea/utils/config.dart';

void showLoading(BuildContext context) {
  AlertDialog alert = AlertDialog(
    contentPadding: const EdgeInsets.all(30),
    content: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Color(AppColor.primaryColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
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
