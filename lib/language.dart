import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thegood/chapters.dart';
class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {

  saveLanguageSession(bool ls) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setBool("ls", ls);
    });

  }
  saveLanguage(String language) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("language", language);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A237E),
      body: Stack(
        children: [
          Positioned(left: 0,right: 0,top: 50,child: Center(child: Text('Select Your Language',style: TextStyle(color: Color(0xffFFD700),fontSize: 18.0,fontWeight: FontWeight.normal,fontFamily: 'Gilroy'),)),),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(width: MediaQuery.of(context).size.width,margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),height: 50,
                  child: RaisedButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),onPressed: (){
                    saveLanguageSession(true);
                    saveLanguage('hi');
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Chapters()));
                  },color: Color(0xffFFD700),child: Text('हिन्दी',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,
                      color: Color(0xFF1A237E)),),),
                ),
                Container(width: MediaQuery.of(context).size.width,margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),height: 50,
                  child: RaisedButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),onPressed: (){
                    saveLanguageSession(true);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Chapters()));

                  },color: Color(0xffFFD700),child: Text('English',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,
                      color: Color(0xFF1A237E)),),),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
