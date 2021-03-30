import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final Color primaryColor=Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen=Color(0xff25bcbb);

  CalendarController _controller;
  TextStyle dayStyle(FontWeight fontWeight)
  {
    return TextStyle(color:Color(0xff30384c),fontWeight:fontWeight);
  }

  Container EvidenceList(String evi_type, String evi_title, IconData iconImg, Color iconColor)
  {
    return Container(
        padding:EdgeInsets.only(top:20,right:10),

        child:Row(
            children:<Widget>[
              Icon(
                iconImg,
                color:Color(0xff00cf8d),
                size:10,

              ),
              Container(
                padding:EdgeInsets.only(left:20,right:10,top:40,bottom:10),
                width:MediaQuery.of(context).size.width*0.8,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget>[
                    Text(evi_type,
                        style:
                        TextStyle(
                            fontSize:20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        )
                    ),
                    SizedBox(height:10,),
                    Text(
                      evi_title, style:TextStyle(
                        fontSize:15,
                        color: Colors.white,
                        fontWeight: FontWeight.normal
                    ),
                    )
                  ],
                ),
              ),
              Icon(
                CupertinoIcons.delete,
                color:Color(0xff00cf8d),

                size:20,

              ),
            ]
        )
    );
  }

  @override
  void initState()
  {
    super.initState();
    _controller=CalendarController();
  }
  @override
  void dispose()
  {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child:SingleChildScrollView(
            child:Column(
                children:<Widget>[

                  TableCalendar(
                    startingDayOfWeek:StartingDayOfWeek.monday,
                    calendarStyle: CalendarStyle(
                      weekdayStyle: dayStyle(FontWeight.normal),
                      weekendStyle: dayStyle(FontWeight.normal),
                      selectedColor: Color(0xff30374b),
                      todayColor: Color(0xff30374b),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                          color:Color(0xff30384c),
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                      weekendStyle: TextStyle(
                          color:Color(0xff30384c),
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(
                        color:Color(0xff30384c),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color:Color(0xff30384c),
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color:Color(0xff30384c),
                      ),
                    ),
                    calendarController: _controller,
                  ),
                  SizedBox(height:20,),
                  Container(
                      padding:EdgeInsets.only(left:30,bottom:60),
                      width:MediaQuery.of(context).size.width,
                      height:MediaQuery.of(context).size.height*0.55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft:Radius.circular((50)),topRight:Radius.circular((50)),),
                          color: Color(0xff30384c)
                      ),
                      child: SingleChildScrollView(
                          child:Stack(

                              children:<Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.only(top:50,),
                                      child:Text("12th March 2021", style: TextStyle(
                                          color:Colors.white,
                                          fontSize:30,
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),
                                    ),

                                    EvidenceList("Evidence Type", "Evidence Style",CupertinoIcons.circle_fill, Color(0xff00cf8d)),
                                    EvidenceList("Evidence Type", "Evidence Style",CupertinoIcons.circle_fill, Color(0xff00cf8d)),
                                    EvidenceList("Evidence Type", "Evidence Style",CupertinoIcons.circle_fill, Color(0xff00cf8d)),
                                    EvidenceList("Evidence Type", "Evidence Style",CupertinoIcons.circle_fill, Color(0xff00cf8d)),
                                  ],
                                ),


                              ]
                          )
                      )
                  ),

                ]
            )
        )
    );
  }
}
