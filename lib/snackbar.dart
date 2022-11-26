import 'package:flutter/material.dart';


class GlobalSnackBar {
  final String message;

  const GlobalSnackBar({
    required this.message,
  });

  static show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0.0,
        //behavior: SnackBarBehavior.floating,
        content: Text(message , textAlign: TextAlign.end, style: TextStyle(fontSize: 15,color: Colors.white , fontFamily: "IRANSansXFaNum"),),
        duration: new Duration(seconds: 3),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        // ),
        backgroundColor: Colors.grey,

        // action: SnackBarAction(
        //   textColor: Color(0xFFFAF2FB),
        //   label: 'OK',
        //   onPressed: () {},
        // ),
      ),
    );
  }
}