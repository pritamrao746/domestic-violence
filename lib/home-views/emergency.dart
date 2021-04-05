import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Emergency extends StatefulWidget {
  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {


  TwilioFlutter twilioFlutter;
  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACae4c21f091611009dacaa163499617b7',
        authToken: '3d3f8fd49a39e9d32d23c041b0eb8142',
        twilioNumber: '+15182848514' );
    super.initState();
  }


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
              onPressed: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                String uid = auth.currentUser.uid;
                var ss = await FirebaseFirestore.
                instance.
                collection("users").
                doc(uid).get();

                print(ss);
                print('button pressed');
                String number= ss.data()['contact1'];
                try {
                  if (number != null) {
                    if (number.length == 10) {
                      number = '+91' + number;
                    }
                    await twilioFlutter.sendSMS(
                      toNumber: number,
                      messageBody: 'The message we want to send go here',
                    );
                  }
                }catch(e){
                  print("Error  ${e.toString()}");
                }

                number= ss.data()['contact2'];
                try {
                  if (number != null) {
                    if (number.length == 10) {
                      number = '+91' + number;
                    }
                    await twilioFlutter.sendSMS(
                      toNumber: number,
                      messageBody: 'The message we want to send go here',
                    );
                  }
                }catch(e){
                  print("Error  ${e.toString()}");
                }
              },
            )
        ),
      ),
    );
  }
}
