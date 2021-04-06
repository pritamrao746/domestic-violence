import 'package:domestic_violence/login_screen.dart';
import 'package:domestic_violence/services/UserSetup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:domestic_violence/classes/language.dart';
import 'package:domestic_violence/localization/language_constants.dart';
import 'package:domestic_violence/main.dart';


class Register_Screen extends StatefulWidget {
  @override
  _Register_ScreenState createState() => _Register_ScreenState();
}

class _Register_ScreenState extends State<Register_Screen> {
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emer1Controller = TextEditingController();
  final TextEditingController emer2Controller = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title:Text(getTranslated(context, 'sign_up')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<Language>(
              underline: SizedBox(),
              icon: Icon(
                Icons.language,
                color: Colors.white,
              ),
              onChanged: (Language language) {
                _changeLanguage(language);
              },
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                  value: e,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        e.flag,
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(e.name)
                    ],
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              SizedBox(height: 10),
              _buildTextField(nameController, Icons.account_circle, getTranslated(context, 'name')),
              SizedBox(height: 10),
              _buildTextField(
                  nicknameController, Icons.account_circle,getTranslated(context, 'nickname')),
              SizedBox(height: 10),
              _buildTextField(emailController, Icons.account_circle, getTranslated(context, 'email')),
              SizedBox(height: 10),
              _buildTextField(
                  mobileController, Icons.account_circle, getTranslated(context, 'mobile')),
              SizedBox(height: 10),
              _buildTextField(emer1Controller, Icons.account_circle, getTranslated(context, 'emer1')),
              SizedBox(height: 10),
              _buildTextField(emer2Controller, Icons.account_circle, getTranslated(context, 'emer2')),
              SizedBox(height: 10),
              _buildPasswordField(passwordController, Icons.lock, getTranslated(context, 'password')),
              SizedBox(height: 10),
              _buildPasswordField(
                  confirmPasswordController, Icons.lock, getTranslated(context, 'conf_password')),
              SizedBox(height: 20),
              MaterialButton(
                elevation: 0,
                minWidth: double.maxFinite,
                height: 50,
                onPressed: () async {
                  String name = nameController.text;
                  String nickname = nicknameController.text;
                  String mobile = mobileController.text;
                  String email = emailController.text;
                  String password = passwordController.text;
                  String cont1=emer1Controller.text;
                  String cont2=emer2Controller.text;

                  try{
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                    User user = FirebaseAuth.instance.currentUser;
                    user.updateProfile(displayName: name);
                    userSetup(name, password, mobile, nickname,cont1,cont2 );

                    Navigator.popUntil(context, ModalRoute.withName('/'));
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/login');

                  } catch(e){
                    print("Error during registration is ${e.toString()}");
                  }

                },
                color: logoGreen,
                child: Text(getTranslated(context, 'sign_up'),
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                textColor: Colors.white,
              ),
              SizedBox(height: 20),
              MaterialButton(
                elevation: 0,
                minWidth: double.maxFinite,
                height: 50,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => Login_Screen()));
                },
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 10),
                    Text(getTranslated(context, 'login'),
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTextField(
      TextEditingController controller, IconData icon, String labelText) {
    return Container(
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
  _buildPasswordField(
      TextEditingController controller, IconData icon, String labelText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: secondaryColor, border: Border.all(color: Colors.blue)),
      child: TextField(
        obscureText: true,
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
}
