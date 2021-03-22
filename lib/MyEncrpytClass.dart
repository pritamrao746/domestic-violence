import 'package:encrypt/encrypt.dart' as enc;

class MyEncrypt {
  static String two256= "PreetamYourLifeYourResponsibilty";
  static final myKey = enc.Key.fromUtf8(two256);
  static final myIv = enc.IV.fromUtf8("VivekPanchal1122");
  static final myEncrypter = enc.Encrypter(enc.AES(myKey));
}
