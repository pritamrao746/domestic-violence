import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domestic_violence/home-views/ShowNotes.dart';


class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final Color primaryColor=Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen=Color(0xff25bcbb);

  var notesList=[];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: (){
          Navigator.pushNamed(context,'/addnotes');
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: notesList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context,int index){
            return ListTile(
              leading:Icon(Icons.notes),
              title:Text(notesList[index]["time"]),
              trailing: Wrap(
                spacing:20,
                children:[
                  IconButton(
                    icon: Icon(Icons.open_in_new),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => ShowNotes(notesList:notesList,index:index),
                      ));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {

                      notesList[index]['ref'].delete();
                      setState(() {
                        loadData();
                      });

                    },
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  @override
  void initState()
  {
    loadData();
  }


  Future<void> loadData() async {
    String uid = FirebaseAuth.instance.currentUser.uid.toString();

    notesList.clear();
    print("LOADADATA CALLED AGAIN");
    await FirebaseFirestore.
    instance.
    collection("notes").
    where("uid", isEqualTo: uid).
    get().
    then((value) {
      value.docs.forEach((result) {
        var avd = new Map();
        avd['ref'] = result.reference;
        avd['body'] = result.data()['body'].toString();
        avd['time'] = result.data()['time'].toString();

        //print(avd);
        notesList.add(avd);
      });
    });

    setState(() {

    });
  }
}
