import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Videos extends StatefulWidget {

  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  final Color primaryColor=Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen=Color(0xff25bcbb);
  YoutubePlayerController _controller;

  void runYouTubePlayer(){
    _controller=YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId('https://www.youtube.com/watch?v=KVpxP3ZZtAc'),
        flags:YoutubePlayerFlags(
          enableCaption:false,
          isLive:false,
          autoPlay:false,
        )
    );
  }
  @override
  void initState(){
    runYouTubePlayer();
    super.initState();
  }

  @override
  void deactivate(){
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player:YoutubePlayer(
        controller:_controller,
      ),
      builder:(context,player) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Educational Videos'),
            backgroundColor: primaryColor,

          ),

          body:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              player,
              SizedBox(height:40),
              Text(
                'Youtube Player',
              ),
            ],
          ),

        );

      },
    );
  }
}
