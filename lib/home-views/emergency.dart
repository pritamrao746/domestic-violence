import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Emergency extends StatefulWidget {
  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  final Color primaryColor=Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen=Color(0xff25bcbb);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text('Emergency'),
          backgroundColor: primaryColor,
          actions:[
            IconButton(icon: Icon(Icons.g_translate, color:Colors.white) ,onPressed: null)
          ]
      ),
      body: Center(
        child: Container(
            child:ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  primary: Colors.red,
                  elevation: 50,
              ),
              child: Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,

                ),
                child: Text(
                  'Press',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              onPressed: () {},
            )
        ),
      ),
    );
  }
}
