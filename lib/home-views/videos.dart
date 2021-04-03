import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  final Color primaryColor=Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen=Color(0xff25bcbb);

  DocumentReference linkRef;
  List<String> videoID = [];
  bool showItem = false;
  final utube =
  RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");

  @override
  void initState() {
    linkRef = FirebaseFirestore.instance.collection('links').doc('urls');
    super.initState();
    getData();
    print(videoID);
  }


  getData() async {
    await linkRef
        .get()
        .then((value) => value.data()?.forEach((key, value) {
      if (!videoID.contains(value)) {
        videoID.add(value);
      }
    }))
        .whenComplete(() => setState(() {
      videoID.shuffle();
      showItem = true;
    }));
  }

  @override
  Widget build(BuildContext context) {

        return Scaffold(
          appBar: AppBar(
            title: Text('Educational Videos'),
            backgroundColor: primaryColor,

          ),

          body: Column(
                children: [

                Flexible(
                    child: Container(
                           margin: EdgeInsets.symmetric(horizontal: 4),
                           child: ListView.builder(
                               itemCount: videoID.length,
                                itemBuilder: (context, index) => Container(
                                      margin: EdgeInsets.all(8),
                                      child: YoutubePlayer(
                                      controller: YoutubePlayerController(
                                      initialVideoId: YoutubePlayer.convertUrlToId(videoID[index]),
                                      flags: YoutubePlayerFlags(
                                          autoPlay: false,
                                      )),
                                      showVideoProgressIndicator: true,
                                        progressIndicatorColor: Colors.blue,
                                        progressColors: ProgressBarColors(
                                            playedColor: Colors.blue,
                                            handleColor: Colors.blueAccent),
                                     )
                                )
                           )
                    )
                ),
              ],
          ),
        );


  }
}
