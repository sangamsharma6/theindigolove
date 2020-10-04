import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thegood/Utilities.dart';
import 'package:thegood/cards.dart';
import 'package:thegood/detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Verses extends StatefulWidget {
  var chap_number;

  Verses({this.chap_number});

  @override
  _VersesState createState() => _VersesState();
}

class _VersesState extends State<Verses> {
  dynamic ChapterDetails;
  List verses;
  var Accesstoken;

  String language;

  saveLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      language = sharedPreferences.getString("language");
    });
    Authentication(language);
  }

  Future<void> Authentication(langugage) async {
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
        if(langugage=='hi'){
          getChapterDetailsHindi(Accesstoken);
        } else {
          getChapterDetails(Accesstoken);
        }
      }
    });
  }

  Future<void> getChapterDetails(accesstoken) async {
    var response = await http.get(Utilities.ChapterDetails +
        '${widget.chap_number}' +
        '?access_token=' +
        accesstoken);
    setState(() {
      var convertJsonData = json.decode(response.body);
      print(convertJsonData);
      ChapterDetails = convertJsonData;
      print('Chapters Details  are ${ChapterDetails}');
      getVersesList(accesstoken);
    });
  }

  Future<void> getChapterDetailsHindi(accesstoken) async {
    var response = await http.get(Utilities.ChapterDetails +
        '${widget.chap_number}' +
        '?access_token=' +
        accesstoken + '&language=hi');
    setState(() {
      var convertJsonData = json.decode(response.body);
      print(convertJsonData);
      ChapterDetails = convertJsonData;
      print('Chapters Details  are ${ChapterDetails}');
      getVersesListHindi(accesstoken);
    });
  }

  Future<void> getVersesList(accesstoken) async {
    var response = await http.get(Utilities.Verses +
        '${widget.chap_number}' +
        '/verses?access_token=' +
        accesstoken);
    setState(() {
      var convertJsonData = json.decode(response.body);
      print(convertJsonData);
      verses = convertJsonData;
      print(Utilities.Verses +
          '${widget.chap_number}' +
          '/verses?access_token=' +
          accesstoken);
    });
  }

  Future<void> getVersesListHindi(accesstoken) async {
    var response = await http.get(Utilities.Verses +
        '${widget.chap_number}' +
        '/verses?access_token=' +
        accesstoken + '&language=hi');
    setState(() {
      var convertJsonData = json.decode(response.body);
      print(convertJsonData);
      verses = convertJsonData;
      print(Utilities.Verses +
          '${widget.chap_number}' +
          '/verses?access_token=' +
          accesstoken);
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
      body: verses != null
          ? NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.of(context).pop()),
                    expandedHeight: 250,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.only(
                            top: size.height * .10,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Verses',
                                    style: TextStyle(
                                        color: Color(0xFF1A237E),
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Gilroy')),
                                RaisedButton(
                                  elevation: 5,
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).push(PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder:
                                            (BuildContext context, _, __) {
                                          return new Material(
                                            color: Colors.black54,
                                            child: Container(
                                              padding: EdgeInsets.all(30.0),
                                              child: InkWell(
                                                child: Hero(
                                                    tag: "hero-grid-${1}",
                                                    child: Container(
                                                      color: Color(0xFF1A237E),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 60),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              ChapterDetails[
                                                                  'chapter_summary'],
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xffFFD700),
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontFamily:
                                                                    'Gilroy',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        transitionDuration:
                                            Duration(milliseconds: 500)));
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  child: Text(
                                    'Summary',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A237E),
                                        fontFamily: 'Gotik'),
                                  ),
                                )
                              ],
                            ),
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
                      ),
                    ),
                  )
                ];
              },
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: verses.length,
                        itemBuilder: (context, int index) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Details(
                                          cn: widget.chap_number,
                                          vn: verses[index]['verse_number'],
                                        ))),
                            child: Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: ChapterCard(
                                name: verses[index]['meaning'],
                                tag: 'Verse ' +
                                    verses[index]['verse_number'].toString(),
                                press: () {},
                              ),
                            ),
                          );
                        }),
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
