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




  @override
  Widget build(BuildContext context) {

    FirebaseAuth auth = FirebaseAuth.instance;
//    String uid = auth.currentUser.uid;
    String uid='HVaUYC72SvhbsFOpOmC9YmLPk9B2';

    var url_list=[];
    FirebaseFirestore.
    instance.
    collection("video").
    where("uid", isEqualTo: uid).
    get().
    then((value) {
      value.docs.forEach((result) {
        var avd = new Map();
        avd['title'] = result.data()['time'];
        avd['url'] = result.data()['url'];
        print(avd);
        url_list.add(avd);
      });
    });
    print(url_list);


    return Scaffold(
      body: ListView.builder(
          itemCount: videos.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context,int index){
            return ListTile(
                leading:Icon(Icons.videocam),
                title:Text(videos[index]["title"]),
                trailing: Wrap(
                spacing:20,
                children:[
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {

                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => VideoDemo(url:videos[index]["url"])));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {},
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
}
