import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:domestic_violence/classes/language.dart';
import 'package:domestic_violence/localization/language_constants.dart';
import 'package:domestic_violence/main.dart';

class ShowNotes extends StatefulWidget {
  final dynamic notesList;
  final int index;

  const ShowNotes({Key key, @required this.notesList,@required this.index})
      : super(key: key);

  @override
  _ShowNotesState createState() => _ShowNotesState();
}

class _ShowNotesState extends State<ShowNotes> {
  final Color primaryColor=Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen=Color(0xff25bcbb);
  final CollectionReference notesRef = FirebaseFirestore.instance.collection('notes');

  ZefyrController _controller;
  FocusNode _focusNode;

  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(getTranslated(context, 'add_notes')),
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
      body:Container(
        padding: EdgeInsets.all(10),
        child:ZefyrScaffold(
          child:ZefyrEditor(
            padding:EdgeInsets.all(5),
            controller:_controller,
            focusNode:_focusNode,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: ()  {
          save();
        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }

  @override
  void initState(){
    final document =_loadDocument();
    _controller=ZefyrController(document);
    _focusNode=FocusNode();
  }

  NotusDocument _loadDocument(){
    String body = widget.notesList[widget.index]['body'].toString()+"\n";
    final Delta delta=Delta()..insert(body);
    return NotusDocument.fromDelta(delta);
  }

  void save()
  {
    final content = jsonEncode(_controller.document);

    // Removing the extra string added by json
    String contentStr = content.toString();
    int length = contentStr.length;
    String body = contentStr.substring(12,length-5);

    // Storing in firebase
    try{
      String time = DateTime.now().toString();
      notesRef.doc(time).set({
        'uid':FirebaseAuth.instance.currentUser.uid.toString(),
        'time':time,
        'body':body
      });
    }
    catch(e)
    {
      print("Some error occurred i.e e=${e.toString()}");
    }
    finally{
      Navigator.pop(context);
    }
  }
}

