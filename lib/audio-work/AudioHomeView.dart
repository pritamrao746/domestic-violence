import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:domestic_violence/audio-work/CloudAudio.dart';
import 'package:domestic_violence/audio-work/FeatureButtonsView.dart';


class AudioHomeView extends StatefulWidget {
  @override
  _AudioHomeViewState createState() => _AudioHomeViewState();
}

class _AudioHomeViewState extends State<AudioHomeView> {
  List<Reference> references;

  @override
  void initState() {
    super.initState();
    _onUploadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Example'),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: references == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: LinearProgressIndicator(),
                  ),
                  Text('Fetching records from Firebase')
                ],
              )
                  : references.isEmpty
                  ? Center(
                child: Text('No File uploaded yet'),
              )
                  : CloudRecordListView(references: references),
            ),
            Expanded(
              flex: 2,
              child: FeatureButtonsView(
                onUploadComplete: _onUploadComplete,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onUploadComplete() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult =
    await firebaseStorage.ref().child('upload-voice-firebase').list();
    setState(() {
      references = listResult.items;
    });
  }
}
