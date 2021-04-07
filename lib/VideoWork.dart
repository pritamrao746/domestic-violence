import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String title;

  VideoPage({Key key, this.title}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  String _counter = null;
  String _downloadUrl;
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);

  Future<void> uploadVideo(String filePath) async {
    print("Compressed Path is $filePath");
    File largeFile = File(filePath);
    var downloadUrl;
    var ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("videos/${DateTime.now()}.mp4");

    firebase_storage.UploadTask task = ref.putFile(largeFile);

    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      print(task.snapshot);
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });

    // We can still optionally use the Future alongside the stream.
    try {
      await task;
      downloadUrl = await ref.getDownloadURL();
      _downloadUrl = downloadUrl;

      String time = DateTime.now().toString();
      await uploadOnFirestore(downloadUrl, time);
    } on firebase_core.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text('Evidence-New Video'),
          backgroundColor: primaryColor,
          actions:[
            IconButton(icon: Icon(Icons.g_translate, color:Colors.white) ,onPressed: null)
          ]
      ),
      body: ListView(
        children: <Widget>[
          if (_counter != null) ...[
            FlatButton.icon(
              label: Text('Upload to Firebase'),
              icon: Icon(Icons.cloud_upload),
              onPressed: () {
                uploadVideo(_counter);
                setState(() {
                  _counter = null;
                });
                Navigator.pop(context);
              },
            )
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () async {
          final file =
              await ImagePicker().getVideo(source: ImageSource.gallery);

          print("Original Video path is ${file.path}");
          await VideoCompress.setLogLevel(0);
          final info = await VideoCompress.compressVideo(
            file.path,
            quality: VideoQuality.LowQuality,
            deleteOrigin: false,
            includeAudio: true,
          );
          if (info != null) {
            setState(() {
              _counter = info.path;
              print("VideoPath is ${info.path}");
              print("Compress LEN = ${info.filesize}");
            });
          }
        },
        tooltip: 'New Video',
        child: Icon(Icons.add),
      ),
    );
  }

  uploadOnFirestore(downloadUrl, String time) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    var videoRef = FirebaseFirestore.instance.collection('video');

    videoRef.doc(time).set({
      'uid': uid,
      'url': downloadUrl,
      'time': time,
    });
  }
}
