import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class UserData {
  final String name, nickname, mobile, password;

  UserData(this.name, this.nickname, this.mobile, this.password);

  storeNewUserData(context) async {
    var user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'name': name,
      'uid': user.uid,
      'email': user.email,
      'nickname': nickname,
      'mobile': mobile,
      'password': password
    }).then((value) {
      print("User Added Successfully");
      Navigator.popUntil(context, ModalRoute.withName('/'));
      Navigator.pop(context);
      Navigator.pushNamed(context, '/login');
    }).catchError((e) {
      print(
          "Some Error Occurred while registering user, Please try again \n\n Error is $e");
    });
  }
}
