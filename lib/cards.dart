import 'package:flutter/material.dart';

class ChapterCard extends StatelessWidget {
  final String name;
  final String tag;
  final int chapterNumber;
  final Function press;
  const ChapterCard({
    Key key,
    this.name,
    this.tag,
    this.chapterNumber,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 16),padding: EdgeInsets.only(right: 5,left: 10),
      width: size.width ,
      height: 70,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38.5),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 33,
            color: Color(0xFFD3D3D3).withOpacity(.84),
          ),
        ],
      ),
      child: Center(
        child: Flexible(
          child: ListTile(
            title: Text(name,style: TextStyle(color: Color(0xFF1A237E),fontSize: 15.0,fontWeight: FontWeight.w600,fontFamily: 'Gilroy',),overflow: TextOverflow.ellipsis,maxLines: 2,),
            subtitle: Text(tag,style: TextStyle(color: Colors.grey,fontSize: 13.0,fontWeight: FontWeight.normal,fontFamily: 'Gilroy'),),
            trailing:IconButton(icon:  Icon(Icons.arrow_forward_ios,color: Colors.black54,size: 14,), onPressed: press,),
          ),
        )
      ),
    );
  }
}