import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class XD_splash extends StatelessWidget {
  XD_splash({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff171732),
      body: Center(
        child: Text(
          'سوق نجران',
          style: TextStyle(
            fontFamily: 'Estedad-Black',
            fontSize: 90,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
