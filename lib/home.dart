import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:domestic_violence/classes/language.dart';
import 'package:domestic_violence/localization/language_constants.dart';
import 'package:domestic_violence/main.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final double _borderRadius=24;

  final Color primaryColor=Color(0xff18203d);

  final Color secondaryColor = Color(0xff232c51);

  final Color logoGreen=Color(0xff25bcbb);

  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/posts');
                },
                child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: 350,
                  height:80,
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(_borderRadius),
                    gradient:LinearGradient(
                        colors:[secondaryColor,Colors.blue],
                        begin:Alignment.topLeft,
                        end:Alignment.bottomRight
                    ),
                    boxShadow:[
                      BoxShadow(
                        color:Colors.black,
                        blurRadius:8,
                        offset:Offset(0,4),
                      ),
                    ],
                  ),
                  child:Center(child: Text(getTranslated(context, 'posts'), style:TextStyle(
                    fontSize: 35,
                    color:Colors.white,
                  ))),
                ),
              ),
            ),

            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context,'/evidence');
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: 350,
                  height:80,
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(_borderRadius),
                    gradient:LinearGradient(
                        colors:[secondaryColor,Colors.blue],
                        begin:Alignment.topLeft,
                        end:Alignment.bottomRight
                    ),
                    boxShadow:[
                      BoxShadow(
                        color:Colors.black,
                        blurRadius:8,
                        offset:Offset(0,4),
                      ),
                    ],
                  ),
                  child:Center(child: Text(getTranslated(context, 'evidence'), style:TextStyle(
                    fontSize: 35,
                    color:Colors.white,
                  ))),
                ),
              ),
            ),
            SizedBox(height:10),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context,'/ngo');
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: 350,
                  height:80,
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(_borderRadius),
                    gradient:LinearGradient(
                        colors:[secondaryColor,Colors.blue],
                        begin:Alignment.topLeft,
                        end:Alignment.bottomRight
                    ),
                    boxShadow:[
                      BoxShadow(
                        color:Colors.black,
                        blurRadius:8,
                        offset:Offset(0,4),
                      ),
                    ],
                  ),
                  child:Center(child: Text(getTranslated(context, 'ngo'), style:TextStyle(
                    fontSize: 35,
                    color:Colors.white,
                  ))),
                ),
              ),
            ),
            SizedBox(height:10),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context,'/education');
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: 350,
                  height:80,
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(_borderRadius),
                    gradient:LinearGradient(
                        colors:[secondaryColor,Colors.blue],
                        begin:Alignment.topLeft,
                        end:Alignment.bottomRight
                    ),
                    boxShadow:[
                      BoxShadow(
                        color:Colors.black,
                        blurRadius:8,
                        offset:Offset(0,4),
                      ),
                    ],
                  ),
                  child:Center(child: Text(getTranslated(context, 'edu_videos'), style:TextStyle(
                    fontSize: 35,
                    color:Colors.white,
                  ))),
                ),
              ),
            ),
            SizedBox(height:10),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context,'/emergency');
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: 350,
                  height:80,
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(_borderRadius),
                    gradient:LinearGradient(
                        colors:[secondaryColor,Colors.blue],
                        begin:Alignment.topLeft,
                        end:Alignment.bottomRight
                    ),
                    boxShadow:[
                      BoxShadow(
                        color:Colors.black,
                        blurRadius:8,
                        offset:Offset(0,4),
                      ),
                    ],
                  ),
                  child:Center(child: Text(getTranslated(context, 'emergency'), style:TextStyle(
                    fontSize: 35,
                    color:Colors.white,
                  ))),
                ),
              ),
            ),
          ]

      ),
    );
  }
}

