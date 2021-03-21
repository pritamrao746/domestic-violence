import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/widgets.dart';

class UserData {
  String name, nickname, mobile, password, email;

  UserData(this.name, this.nickname, this.mobile, this.password);

  void encryptUserData() {
    print("Name = ${this.name}");
    this.name =
        MyEncrypt.myEncrypter.encrypt(this.name, iv: MyEncrypt.myIv).base16;
    // this.nickname =
    //     MyEncrypt.myEncrypter.encrypt(this.nickname, iv: MyEncrypt.myIv).base16;
    // this.mobile =
    //     MyEncrypt.myEncrypter.encrypt(this.mobile, iv: MyEncrypt.myIv).base16;
    // this.password =
    //     MyEncrypt.myEncrypter.encrypt(this.password, iv: MyEncrypt.myIv).base16;

    print("Name = ${this.name}");
    // print("Nick = ${this.nickname}");
    // print("Mobi = ${this.mobile}");
    // print("Pass = ${this.password}");
  }

  void decryptUserData() {
    print("Name=${MyEncrypt.myEncrypter.decrypt16(name, iv: MyEncrypt.myIv)}");
    print(
        "Nick=${MyEncrypt.myEncrypter.decrypt16(nickname, iv: MyEncrypt.myIv)}");
    print(
        "Mobi=${MyEncrypt.myEncrypter.decrypt16(mobile, iv: MyEncrypt.myIv)}");
    print(
        "Pass=${MyEncrypt.myEncrypter.decrypt16(password, iv: MyEncrypt.myIv)}");
  }

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
      //decryptUserData();
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

class MyEncrypt {
  static final myKey =
      encrypt.Key.fromUtf8('TechWithVPTechWithVPTechWithVP12');
  static final myIv = encrypt.IV.fromUtf8("VivekPanchal1122");
  static final myEncrypter = encrypt.Encrypter(encrypt.AES(myKey));
}

// void testEncrytpion() {
//
//   var encrpytedName = MyEncrypt.myEncrypter.encrypt(name, iv: MyEncrypt.myIv);
//   print('enc name bytes = ${encrpytedName.bytes}');
//   print('enc name 64 = ${encrpytedName.base64}');
//   print('enc name 16 = ${encrpytedName.base16}');
//   print('enc name sting = ${encrpytedName.toString()}');
//   print('Decrypted name = ${MyEncrypt.myEncrypter.decrypt(encrpytedName, iv: MyEncrypt.myIv)}');
//
//   print("Name is $name");
// }
