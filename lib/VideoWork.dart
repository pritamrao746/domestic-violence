import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class VideoPage extends StatefulWidget {
  final String title;

  VideoPage({Key key, this.title}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  String _counter = "video";
  String _downloadUrl;

  Future<void> uploadVideo(String filePath) async {
    File largeFile = File(filePath);

    var ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("videos/${DateTime.now()}.mp4");

    var downloadUrl;

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
      print('Upload complete. and DownloadUrl is $downloadUrl');
    } on firebase_core.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    }

    setState(() {
      _downloadUrl = downloadUrl ?? _downloadUrl;
      print('SetState DownloadUrl is $downloadUrl');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          if (_counter != null) ...[
            FlatButton.icon(
              label: Text('Compress Image'),
              icon: Icon(Icons.compress),
              onPressed: () => print("Nothing"),
            ),
            FlatButton.icon(
              label: Text('Upload to Firebase'),
              icon: Icon(Icons.cloud_upload),
              onPressed: () {
                uploadVideo(_counter);
              },
            )
          ]
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
