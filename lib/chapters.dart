import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thegood/Utilities.dart';
import 'package:thegood/cards.dart';
import 'package:thegood/verses.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

class Chapters extends StatefulWidget {
  @override
  _ChaptersState createState() => _ChaptersState();
}

class _ChaptersState extends State<Chapters> {
  var Accesstoken;
  List chapters;

  String language;

  saveLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      language = sharedPreferences.getString("language");
    });
    Authentication(language);

  }

  Future<void> Authentication(language) async {
    var response = await http.post(
      Utilities.Authentification,
      body: {
        'client_id': Utilities.Client_ID,
        'client_secret': Utilities.Client_Secret,
        'grant_type': 'client_credentials',
        'scope': 'verse chapter',
      },
    );
    setState(() {
      var convertJsonData = json.decode(response.body);
      print(convertJsonData);
      Accesstoken = convertJsonData['access_token'];
      print('Access token is ${Accesstoken}');
      if (Accesstoken != null) {
       if(language=='hi'){
         getChaptersHindi(Accesstoken);
       } else {
         getChapters(Accesstoken);
       }
      }
    });
  }

  Future<void> getChapters(token) async {
    var response = await http.get(Utilities.Chapters + token);
    setState(() {
      var convertJsonData = json.decode(response.body);
      print(convertJsonData);
      chapters = convertJsonData;
      print('Chapters are ${chapters}');
    });
  }
  Future<void> getChaptersHindi(token) async {
    var response = await http.get(Utilities.Chapters + token + '&language=hi');
    setState(() {
      var convertJsonData = json.decode(response.body);
      print(convertJsonData);
      chapters = convertJsonData;
      print('Chapters are ${chapters}');
    });
  }

  @override
  void initState() {
    super.initState();
    saveLanguage();

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: chapters != null
          ?  SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Stack(
        alignment: Alignment.topCenter,
        children: [
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                        top: size.height * .12,
                        left: size.width * .1,
                        right: size.width * .02),
                    height: size.height * .40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("Assets/background.png"),
                        fit: BoxFit.fitWidth,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Chapters',
                            style: TextStyle(
                                color: Color(0xFF1A237E),
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gilroy')),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(
                                image: AssetImage(
                                    'Assets/image-removebg-preview.png'),
                                height: size.height * 0.15,
                                width: size.width * .15),
                          ),
                        )
                      ],
                    ),
                  ), //size.height * .40 - 40
          ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: size.height * .40 - 40),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: chapters.length,
                    itemBuilder: (context, int index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Verses(
                                  chap_number: chapters[index]
                                  ['chapter_number'],
                                ))),
                        child: Container(
                          margin:
                          EdgeInsets.only(left: 20, right: 20),
                          child: ChapterCard(
                            name: chapters[index]['name_meaning'],
                            tag: chapters[index]['verses_count']
                                .toString() +
                                ' Verses',

                          ),
                        ),
                      );
                    })
        ],
      ),
                ],
              ),
            ),
          )
          : Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                  color: Color(0xFF1A237E),
                  borderRadius: BorderRadius.all(Radius.circular(1.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF656565).withOpacity(0.15),
                      blurRadius: 2.0,
                      spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
                    )
                  ]),
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Color(0xffFFD700),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'Assets/rightpeacock.png',
                        height: 180,
                        width: 180,
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Developed by Sangam',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: 'Gilroy',
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
