import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

// For encryption decryption purpose
import 'package:encrypt/encrypt.dart' as enc;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data' show Uint8List;
import 'package:domestic_violence/MyEncrpytClass.dart';
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
  var decr;
  bool isDecrypted = false;

  Future<void> uploadVideo(String filePath) async {
    print("Compressed Path is $filePath");
    File largeFile = File(filePath);
    var downloadUrl;
    var ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("videos/${DateTime.now()}.text");

    // Reading and encrypting the data
    Uint8List fileData = largeFile.readAsBytesSync();
    Uint8List fileEncryptedData =
        MyEncrypt.myEncrypter.encryptBytes(fileData, iv: MyEncrypt.myIv).bytes;

    firebase_storage.UploadTask task = ref.putData(fileEncryptedData);

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
      print('Upload complete. and DownloadUrl is $downloadUrl');

      print("Encrypted = $fileEncryptedData");

      // Decrypting Data
      if (await canLaunch(downloadUrl)) {
        print("Data downloading....");
        var resp = await http.get(downloadUrl);
        enc.Encrypted encc = enc.Encrypted(resp.bodyBytes);
        print("RESP = ${resp.bodyBytes}");

        List<int> decryptedData =
            MyEncrypt.myEncrypter.decryptBytes(encc, iv: MyEncrypt.myIv);
        Uint8List d = Uint8List.fromList(decryptedData);
        decr = d;
        isDecrypted = true;

        print("DECRYPTED = ${decryptedData}");
      } else {
        print("Can't launch URL.");
      }
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
              label: Text('Upload to Firebase'),
              icon: Icon(Icons.cloud_upload),
              onPressed: () {
                uploadVideo(_counter);
              },
            )
          ],
          if (isDecrypted) ...[]
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
