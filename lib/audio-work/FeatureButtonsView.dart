import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// For encryption decryption purpose
import 'dart:typed_data' show Uint8List;
import 'package:domestic_violence/MyEncrpytClass.dart';

class FeatureButtonsView extends StatefulWidget {
  final Function onUploadComplete;

  const FeatureButtonsView({
    Key key,
    @required this.onUploadComplete,
  }) : super(key: key);

  @override
  _FeatureButtonsViewState createState() => _FeatureButtonsViewState();
}

class _FeatureButtonsViewState extends State<FeatureButtonsView> {
  bool _isPlaying;
  bool _isUploading;
  bool _isRecorded;
  bool _isRecording;

  AudioPlayer _audioPlayer;
  String _filePath;

  FlutterAudioRecorder _audioRecorder;

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    _isRecording = false;
    _audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isRecorded
          ? _isUploading
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LinearProgressIndicator()),
          Text('Uploading to Firebase'),
        ],
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.replay),
            onPressed: _onRecordAgainButtonPressed,
          ),
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _onPlayButtonPressed,
          ),
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: _onFileUploadButtonPressed,
          ),
        ],
      )
          : IconButton(
        icon: _isRecording ? Icon(Icons.pause) : Icon(Icons.add_box),
        onPressed: _onRecordButtonPressed,
      ),
    );
  }

  Future<void> _onFileUploadButtonPressed() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    setState(() {
      _isUploading = true;
    });
    try {
      var ref = firebaseStorage.ref('upload-voice-firebase').child(
          _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length));

      // getting encrypted data
      Uint8List encryptedData = encryptAudio(_filePath);

      firebase_storage.UploadTask task = ref.putData(encryptedData);

      // Uploading Audio Data to Firestore
      try {
        await task;
        String downloadUrl = await ref.getDownloadURL();
        String time = DateTime.now().toString();
        await uploadOnFirestore(downloadUrl, time);
      } catch (e) {
        print("Some Error occurred e=$e");
      }

      widget
          .onUploadComplete(); // This is the function which we passed from the main aap
    } catch (error) {
      print('Error occurred while uploading to Firebase ${error.toString()}');
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred while uploading'),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _onRecordAgainButtonPressed() {
    setState(() {
      _isRecorded = false;
    });
  }

  Future<void> _onRecordButtonPressed() async {
    if (_isRecording) {
      _audioRecorder.stop();
      _isRecording = false;
      _isRecorded = true;
    } else {
      _isRecorded = false;
      _isRecording = true;

      await _startRecording();
    }
    setState(() {});
  }

  void _onPlayButtonPressed() {
    if (!_isPlaying) {
      _isPlaying = true;

      _audioPlayer.play(_filePath, isLocal: true);
      _audioPlayer.onPlayerCompletion.listen((duration) {
        setState(() {
          _isPlaying = false;
        });
      });
    } else {
      _audioPlayer.pause();
      _isPlaying = false;
    }
    setState(() {});
  }

  Future<void> _startRecording() async {
    final bool hasRecordingPermission =
    await FlutterAudioRecorder.hasPermissions;
    if (hasRecordingPermission) {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath = directory.path +
          '/' +
          DateTime
              .now()
              .millisecondsSinceEpoch
              .toString() +
          '.aac';
      _audioRecorder =
          FlutterAudioRecorder(filepath, audioFormat: AudioFormat.AAC);
      await _audioRecorder.initialized;
      _audioRecorder.start();
      _filePath = filepath;
      setState(() {});
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Center(
          child: Text('Please enable recording permission'),
        ),
      ));
    }
  }

  Uint8List encryptAudio(String filepath) {
    File file = File(filepath);
    Uint8List data = file.readAsBytesSync();
    Uint8List encryptedData =
        MyEncrypt.myEncrypter
            .encryptBytes(data, iv: MyEncrypt.myIv)
            .bytes;
    print("ENCRYPTED DATA = $encryptedData");
    return encryptedData;
  }

  uploadOnFirestore(String downloadUrl, String time) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    var audioRef = FirebaseFirestore.instance.collection('audio');
    audioRef.doc(time).set(
        {
          'uid': uid,
          'url': downloadUrl,
          'time': time,
        });
  }
}
