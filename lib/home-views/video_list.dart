import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:domestic_violence/home-views/display_video.dart';
import 'package:domestic_violence/home-views/video_url.dart';

class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  final Color primaryColor=Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen=Color(0xff25bcbb);
  final List<dynamic> videos = video_url;
  var url_list=[];



  @override
  Widget build(BuildContext context) {

    FirebaseAuth auth = FirebaseAuth.instance;
//    String uid = auth.currentUser.uid;
    String uid='HVaUYC72SvhbsFOpOmC9YmLPk9B2';

    return Scaffold(
      body: ListView.builder(
          itemCount: url_list.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context,int index){
            return ListTile(
                leading:Icon(Icons.videocam),
                title:Text(url_list[index]["time"]),
                trailing: Wrap(
                spacing:20,
                children:[
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {

                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => VideoDemo(url:url_list[index]["url"])));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      url_list[index]['ref'].delete();
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: (){
          Navigator.pushNamed(context,'/video');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void initState()
  {
    loadData();
  }


  Future<void> loadData() async{

    String uid = FirebaseAuth.instance.currentUser.uid.toString();
    url_list.clear();

    await FirebaseFirestore.
    instance.
    collection("video").
    where("uid", isEqualTo: uid).
    get().
    then((value) {
      value.docs.forEach((result) {
        var avd = new Map();
        avd['time'] = result.data()['time'];
        avd['url'] = result.data()['url'];
        avd['ref'] = result.reference;
        print(avd);
        url_list.add(avd);
      });
    });
    print(url_list);

    setState(() {

    });
  }
}
