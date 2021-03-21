import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class MyEncrypt {
  static final myKey = encrypt.Key.fromUtf8("TechWithVPTechWithVPTechWithVP12");
  static final myIv = encrypt.IV.fromUtf8("VivekPanchal1122");
  static final myEncrypter = encrypt.Encrypter(encrypt.AES(myKey));
}

Future<void> userSetup(name, pass, mob, nick) async {
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid;
  String email = auth.currentUser.email;

  name = MyEncrypt.myEncrypter.encrypt(name, iv: MyEncrypt.myIv).base16;
  nick = MyEncrypt.myEncrypter.encrypt(nick, iv: MyEncrypt.myIv).base16;
  mob = MyEncrypt.myEncrypter.encrypt(mob, iv: MyEncrypt.myIv).base16;
  pass = MyEncrypt.myEncrypter.encrypt(pass, iv: MyEncrypt.myIv).base16;
  email = MyEncrypt.myEncrypter.encrypt(email, iv: MyEncrypt.myIv).base16;

  users.doc(uid).set({
    'name': name,
    'uid': uid,
    'email': email,
    'nickname': nick,
    'mobile': mob,
    'password': pass
  });

  print("Name=${MyEncrypt.myEncrypter.decrypt16(name, iv: MyEncrypt.myIv)}");
  print("Nick=${MyEncrypt.myEncrypter.decrypt16(nick, iv: MyEncrypt.myIv)}");
  print("Mobi=${MyEncrypt.myEncrypter.decrypt16(mob, iv: MyEncrypt.myIv)}");
  print("Pass=${MyEncrypt.myEncrypter.decrypt16(pass, iv: MyEncrypt.myIv)}");
  print("email=${MyEncrypt.myEncrypter.decrypt16(email, iv: MyEncrypt.myIv)}");

  return;
}
