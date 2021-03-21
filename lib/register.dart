import 'package:domestic_violence/login_screen.dart';
import 'package:domestic_violence/services/UserManagement.dart';
import 'package:domestic_violence/services/UserSetup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sign up!',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(color: Colors.white, fontSize: 28),
              ),
              SizedBox(height: 20),
              _buildTextField(nameController, Icons.account_circle, 'Name'),
              SizedBox(height: 10),
              _buildTextField(
                  nicknameController, Icons.account_circle, 'Nickname'),
              SizedBox(height: 10),
              _buildTextField(emailController, Icons.account_circle, 'Email'),
              SizedBox(height: 10),
              _buildTextField(
                  mobileController, Icons.account_circle, 'Mobile No'),
              SizedBox(height: 10),
              _buildTextField(passwordController, Icons.lock, 'Password'),
              SizedBox(height: 10),
              _buildTextField(
                  confirmPasswordController, Icons.lock, 'Confirm Password'),
              SizedBox(height: 30),
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

                  try{
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                    User user = FirebaseAuth.instance.currentUser;
                    user.updateProfile(displayName: name);
                    userSetup(name, password, mobile, nickname);

                    Navigator.popUntil(context, ModalRoute.withName('/'));
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/login');

                  } catch(e){
                    print("Error during registration is ${e.toString()}");
                  }

                },
                color: logoGreen,
                child: Text('Register',
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
                      MaterialPageRoute(builder: (_) => Register_Screen()));
                },
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 10),
                    Text('Login',
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
}
