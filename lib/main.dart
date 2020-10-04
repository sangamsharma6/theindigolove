import 'package:flutter/material.dart';
import 'package:thegood/Home.dart';
import 'package:thegood/language.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'the Indigo Love',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
