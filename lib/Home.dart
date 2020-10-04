import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thegood/chapters.dart';
import 'package:thegood/language.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var isLanguageSelected = false;

  saveLanguageSession() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isLanguageSelected = sharedPreferences.getBool("ls");
    });
  }

  @override
  void initState() {
    super.initState();
    saveLanguageSession();
    Timer(
        Duration(seconds: 10),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) =>isLanguageSelected==true? Chapters():Language())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF1A237E),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotatedBox(
                      quarterTurns: 5,
                      child: Image(
                        image: AssetImage(
                          'Assets/goldenfeathertwo.png',
                        ),
                        width: 200,
                        height: 120,
                      )),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'the',
                        style: TextStyle(
                            color: Color(0xffFFD700),
                            fontSize: 26.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Gilroy')),
                    TextSpan(
                        text: ' indigo love',
                        style: TextStyle(
                            color: Color(0xffFFD700),
                            fontSize: 26.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Gilroy')),
                  ])),
                ],
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 15,
                child: Center(
                    child: Text(
                  'Developed by Sangam',
                  style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0xffFFD700),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500),
                )))
          ],
        ),
      ),
    );
  }
}
