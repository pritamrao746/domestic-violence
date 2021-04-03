import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:domestic_violence/MyEncrpytClass.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class CloudRecordListView extends StatefulWidget {
  final List<Reference> references;

  const CloudRecordListView({Key key, @required this.references})
      : super(key: key);

  @override
  _CloudRecordListViewState createState() => _CloudRecordListViewState();
}

class _CloudRecordListViewState extends State<CloudRecordListView> {
  bool _isPlaying;
  AudioPlayer audioPlayer;
  int selectedIndex;

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    audioPlayer = AudioPlayer();
    selectedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.references.length,
      reverse: true,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(widget.references.elementAt(index).name),
          trailing: Wrap(
            spacing:20,
            children:[
              IconButton(
              icon: _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              onPressed: () => _onListTileButtonPressed(index),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _onListTileButtonPressed(index),
              ),
            ],
          ),
          
        );
      },
    );
  }

  Future<void> _onListTileButtonPressed(int index) async {
    print("Playing = $_isPlaying");
    if (_isPlaying == false) {
      // Play It
      _isPlaying = true;
      String downloadUrl =
      await widget.references.elementAt(index).getDownloadURL();

      // Getting decrypted data back
      Uint8List decryptedAudio = await  decryptAudio(downloadUrl);
      await audioPlayer.playBytes(decryptedAudio);
      //audioPlayer.play(await widget.references.elementAt(index).getDownloadURL(), isLocal: false);
      audioPlayer.onPlayerCompletion.listen((duration) {
        setState(() {
          selectedIndex = -1;
          _isPlaying = false;
        });
      });
    } else {
      // Pause it
      audioPlayer.pause();
      _isPlaying = false;
    }
    setState(() {});
  }

  Future<Uint8List> decryptAudio(String url) async {
    Uint8List returnVal;
    try {
      print("DownloadUrl is $url");
      if (await canLaunch(url)) {
        print("Data Downloading.......");
        var response = await http.get(url);

        enc.Encrypted encryptedData = enc.Encrypted(response.bodyBytes);
        print("Response in bytes ${response.bodyBytes}");

        List<int> decr = MyEncrypt.myEncrypter.decryptBytes(encryptedData,iv:MyEncrypt.myIv);
        Uint8List decryptedData = Uint8List.fromList(decr);
        print("DecryptedData = $decryptedData");
        returnVal = decryptedData;
      }
      else{
        print("Can\'t Launch url");
      }
    } catch (e) {
      print("Error occurred during decryption where E=${e.toString()}");
    }

    return returnVal;
  }

}
