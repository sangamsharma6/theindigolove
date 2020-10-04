import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thegood/Utilities.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:share/share.dart';
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';


class Details extends StatefulWidget {
  var cn;
  var vn;

  Details({this.cn, this.vn});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int idx = 1;

  var Accesstoken;
  var versedetails;

  String language;

  VoiceController _voiceController;
  String text;
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
          getVerseDetailHindi(Accesstoken);
        } else {
          getVerseDetail(Accesstoken);
        }
      }
    });
  }

  Future<void> getVerseDetail(accesstoken) async {
    print(Utilities.VerseDetails +
        widget.cn.toString() +
        '/verses/' +
        widget.vn.toString() +
        '?access_token=$accesstoken');
    var response = await http.get(Utilities.VerseDetails +
        widget.cn.toString() +
        '/verses/' +
        widget.vn.toString() +
        '?access_token=$accesstoken');
    setState(() {
      var convertJsonData = json.decode(response.body);
      print(convertJsonData);
      versedetails = convertJsonData;
      print('Verse  Details  are ${versedetails}');
      text = versedetails['transliteration'] + 'The Meaning of this is '+ versedetails['meaning'] + ' App is Developed by Sangam';
    });
  }
  Future<void> getVerseDetailHindi(accesstoken) async {
    print(Utilities.VerseDetails +
        widget.cn.toString() +
        '/verses/' +
        widget.vn.toString() +
        '?access_token=$accesstoken');
    var response = await http.get(Utilities.VerseDetails +
        widget.cn.toString() +
        '/verses/' +
        widget.vn.toString() +
        '?access_token=$accesstoken' + '&language=hi');
    setState(() {
      var convertJsonData = json.decode(response.body);
      print(convertJsonData);
      versedetails = convertJsonData;
      print('Verse  Details  are ${versedetails}');
      text = versedetails['transliteration'] + 'The Meaning of this is '+ versedetails['meaning'] + 'App is Developed by Sangam';
    });
  }



  @override
  void initState() {
    _voiceController = FlutterTextToSpeech.instance.voiceController();
    super.initState();
    saveLanguage();
  }
  @override
  void dispose() {
    super.dispose();
    _voiceController.stop();
  }

  _playVoice() {
    _voiceController.init().then((_) {
      _voiceController.speak(
        text,
        VoiceControllerOptions(),
      );
    });
  }

  _stopVoice() {
    _voiceController.stop();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return versedetails != null
        ? Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10,left: 20,right: 20),
                  width: size.width,height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      Share.share( versedetails['meaning'],subject: 'Quote From theHolyApp');
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    color: Color(0xFF1A237E),
                    child: Text(
                      'Share',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xffFFD700),
                          fontFamily: 'Gilroy'),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10,left: 20,right: 20),
                  width: size.width,height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                     _playVoice();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    color: Color(0xFF1A237E),
                    child: Text(
                      'Play',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xffFFD700),
                          fontFamily: 'Gilroy'),
                    ),
                  ),
                ),
              ],
            ),
            body: NestedScrollView(
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
                    expandedHeight: 200,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      centerTitle: true,
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Verse',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E)),
                        ),
                      ),
                      background: Container(
                        child: Hero(
                          tag: idx,
                          child: Image.asset(
                            'Assets/background.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  )
                ];
              },
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    Positioned(
                        right: 0,
                        top: 0,
                        child: Image.asset(
                          'Assets/rightpeacock.png',
                          height: 80,
                          width: 80,
                        )),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        child: Image.asset(
                          'Assets/peacock.png',
                          height: 80,
                          width: 80,
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: EdgeInsets.all(40.0),
                          child: Text(
                              versedetails['transliteration'] +
                                  '\n Meaning:' +
                                  '\n ' +
                                  versedetails['meaning'],
                              style: TextStyle(
                                  color: Color(0xFF1A237E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Gilroy')),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ))
        : Scaffold(
            body: Container(
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
