import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:domestic_violence/audio-work/CloudAudio.dart';
import 'package:domestic_violence/audio-work/FeatureButtonsView.dart';

class AudioHomeView extends StatefulWidget {
  @override
  _AudioHomeViewState createState() => _AudioHomeViewState();
}

class _AudioHomeViewState extends State<AudioHomeView> {
  List<String> references = List<String>();
  List<DocumentReference> metaref = List<DocumentReference>(); // creates an empty List<Map>


  @override
  void initState() {
    super.initState();
    _onUploadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      : CloudRecordListView(references: references,metaref:metaref,onUploadComplete: _onUploadComplete),
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
    String uid = FirebaseAuth.instance.currentUser.uid.toString();
    references.clear();

    await FirebaseFirestore.instance
        .collection("audio")
        .where('uid', isEqualTo: uid)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        print("-----DEBUG-----");
        DocumentReference metaRef = result.reference;
        String url = result.data()['url'];


        references.add(url);
        metaref.add(metaRef);
      });
    });

    setState(() {
    });
  }
}
