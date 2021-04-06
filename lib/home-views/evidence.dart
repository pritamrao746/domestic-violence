import 'package:domestic_violence/VideoWork.dart';
import 'package:domestic_violence/audio-work/AudioHomeView.dart';
import 'package:domestic_violence/home-views/Calendar.dart';
import 'package:domestic_violence/home-views/notes.dart';
import 'package:domestic_violence/home-views/video_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:domestic_violence/classes/language.dart';
import 'package:domestic_violence/localization/language_constants.dart';
import 'package:domestic_violence/main.dart';

class Evidence extends StatefulWidget {
  @override
  _Evidence createState() => _Evidence();
}

class _Evidence extends State<Evidence> {


  final Color primaryColor=Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen=Color(0xff25bcbb);

  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  int _currentIndex=0;

  final List<Widget> _children =[
    Calendar(),
    AudioHomeView(),
    VideoList(),
    Notes(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text(getTranslated(context, 'evidence')),
          backgroundColor: primaryColor,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<Language>(
              underline: SizedBox(),
              icon: Icon(
                Icons.language,
                color: Colors.white,
              ),
              onChanged: (Language language) {
                _changeLanguage(language);
              },
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                  value: e,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        e.flag,
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(e.name)
                    ],
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ],
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
              title:Text(getTranslated(context, 'calendar'),style: TextStyle(color:Color(0xff30384c))),


            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_voice,color: Color(0xff30384c)),
              title:Text(getTranslated(context, 'audio'),style: TextStyle(color:Color(0xff30384c))),


            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_call_rounded,color: Color(0xff30384c)),
              title:Text(getTranslated(context, 'video'),style: TextStyle(color:Color(0xff30384c))),

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.text_snippet_rounded,color: Color(0xff30384c)),
              title:Text(getTranslated(context, 'notes'),style: TextStyle(color:Color(0xff30384c))),

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
