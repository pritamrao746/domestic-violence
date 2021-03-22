import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'dart:typed_data' show Uint8List;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:domestic_violence/MyEncrpytClass.dart';

// Widget to capture and crop the image
class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

// Active Image File
// Only piece of state here is the actual file itself
class _ImageCaptureState extends State<ImageCapture> {
  File _image, _picked;
  final picker = ImagePicker();
  String _downloadUrl;
  var decr;
  bool isDecrypted = false;

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _picked = File(pickedFile.path);
        print("Image Picked Path : $_image");
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> getCroppedImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: _image.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );

    setState(() {
      _image = croppedFile ?? _image;
      print("Image Cropped Path : $_image");
    });
  }

  // remove image
  void clear() {
    setState(() => _image = null);
  }

  Future<void> getCompressedImage() async {
    var result = await FlutterImageCompress.compressAndGetFile(
        _image.path, _picked.path,
        quality: 25);
    print("OG LENGTH ${_image.lengthSync()}");

    setState(() {
      if (result == null) {
        print("No compression done");
      } else {
        _image = result;
        print("COMP LENGTH ${result.lengthSync()}");
      }
    });
  }

  Future<void> uploadImageToCloud(String filePath) async {
    File largeFile = File(filePath);

    // encrypting the image
    Uint8List data = largeFile.readAsBytesSync();
    final encryptedData =
        MyEncrypt.myEncrypter.encryptBytes(data, iv: MyEncrypt.myIv).bytes;

    String downloadUrl;

    var ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now()}.text');

    firebase_storage.UploadTask task = ref.putData(encryptedData);

    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      } else {
        print('Some random error = $e');
      }
    });

    try {
      await task;
      downloadUrl = await ref.getDownloadURL();
      print("DATA = $encryptedData");

      // Decryption trying

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
    } catch (e) {
      print("Some Error occurred e=$e");
    }

    setState(() {
      _downloadUrl = downloadUrl ?? _downloadUrl;
      print("Download Url is $_downloadUrl");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Select an image from the camera or gallery
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => getImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => getImage(ImageSource.gallery),
            ),
          ],
        ),
      ),

      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (_image != null) ...[
            Image.file(_image),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.crop),
                  onPressed: getCroppedImage,
                ),
                FlatButton(
                  child: Icon(Icons.refresh),
                  onPressed: clear,
                ),
              ],
            ),
            FlatButton.icon(
              label: Text('Compress Image'),
              icon: Icon(Icons.compress),
              onPressed: () => getCompressedImage(),
            ),
            FlatButton.icon(
              label: Text('Upload to Firebase'),
              icon: Icon(Icons.cloud_upload),
              onPressed: () {
                uploadImageToCloud(_image.path);
              },
            ),
            if (isDecrypted) ...[Image.memory(decr)]
          ]
        ],
      ),
    );
  }
}
