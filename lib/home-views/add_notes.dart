import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class AddNotes extends StatefulWidget {
  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final Color primaryColor=Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen=Color(0xff25bcbb);

  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text('AddNotes'),
          backgroundColor: primaryColor,
          actions:[
            IconButton(icon: Icon(Icons.g_translate, color:Colors.white) ,onPressed: null)
          ]
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
    );
  }

  @override
  void initState(){
    final document =_loadDocument();
    _controller=ZefyrController(document);
    _focusNode=FocusNode();
  }

  NotusDocument _loadDocument(){
    final Delta delta=Delta()..insert("Insert text here\n");
    return NotusDocument.fromDelta(delta);
  }
}
