import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:domestic_violence/classes/language.dart';
import 'package:domestic_violence/localization/language_constants.dart';
import 'package:domestic_violence/main.dart';

// Widget to capture and crop the image
class NewPosts extends StatefulWidget {
  @override
  _NewPostsState createState() => _NewPostsState();
}

// Active Image File
// Only piece of state here is the actual file itself
class _NewPostsState extends State<NewPosts> {
  File _image, _picked;
  final picker = ImagePicker();
  String _downloadUrl;
  var decr;

  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  bool isDecrypted = false;
  final TextEditingController captionController = TextEditingController();
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    // IMAGE AND TEXT TIME CODE IT

    setState(() {
      if (pickedFile != null) {
        print("USER EMAIL IS ${FirebaseAuth.instance.currentUser.email}");
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
    if (result == null) {
      print("No compression done");
    } else {
      _image = result;
      print("COMP LENGTH ${result.lengthSync()}");
    }
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

      // Uploading link on firestore
      String time = DateTime.now().toString();
      await uploadOnFirestore(downloadUrl, time);

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

  }

  _buildTextField(
      TextEditingController controller, IconData icon, String labelText) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: secondaryColor, border: Border.all(color: Colors.blue)),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white),

            // prefix: Icon(icon),
            border: InputBorder.none),
      ),
    );
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
              label: Text(getTranslated(context, 'upload')),
              icon: Icon(Icons.cloud_upload),
              onPressed: () {
                getCompressedImage();
                uploadImageToCloud(_image.path);
//                Navigator.pushNamed(context, '/posts');
              },
            ),
            SizedBox(height: 10),
            _buildTextField(captionController, Icons.account_circle, getTranslated(context, 'caption')),
            if (isDecrypted) ...[Image.memory(decr)]
          ]
        ],
      ),
    );
  }

  uploadOnFirestore(String downloadUrl, String time) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    var imgRef = FirebaseFirestore.instance.collection('image');

    imgRef.doc(time).set(
        {
          'uid':uid,
          'url': downloadUrl,
          'time': time,
          'caption':captionController.text
        });
  }
}
