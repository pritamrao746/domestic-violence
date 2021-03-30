import 'package:domestic_violence/VideoWork.dart';
import 'package:domestic_violence/audio-work/AudioHomeView.dart';
import 'package:domestic_violence/home-views/Calendar.dart';
import 'package:domestic_violence/home-views/notes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Evidence extends StatefulWidget {
  @override
  _Evidence createState() => _Evidence();
}

class _Evidence extends State<Evidence> {


  final Color primaryColor=Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen=Color(0xff25bcbb);

  int _currentIndex=0;

  final List<Widget> _children =[
    Calendar(),
    AudioHomeView(),
    VideoPage(title: "Video Upload"),
    Notes(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text('Evidence'),
          backgroundColor: primaryColor,
          actions:[
            IconButton(icon: Icon(Icons.g_translate, color:Colors.white) ,onPressed: null)
          ]
      ),
      body:_children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type:BottomNavigationBarType.fixed,
          selectedFontSize: 20,
          unselectedFontSize: 15,
          items:[
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined,color: Color(0xff30384c)),
              title:Text('Calendar',style: TextStyle(color:Color(0xff30384c))),


            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_voice,color: Color(0xff30384c)),
              title:Text('Audio',style: TextStyle(color:Color(0xff30384c))),


            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_call_rounded,color: Color(0xff30384c)),
              title:Text('Video',style: TextStyle(color:Color(0xff30384c))),

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.text_snippet_rounded,color: Color(0xff30384c)),
              title:Text('Notes',style: TextStyle(color:Color(0xff30384c))),

            ),

          ],
        onTap: (index){
            setState(() {
              _currentIndex=index;
            });
        },
      ),


    );
  }
}
