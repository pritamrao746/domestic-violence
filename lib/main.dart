import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domestic_violence/VideoWork.dart';
import 'package:domestic_violence/audio-work/AudioHomeView.dart';
import 'package:domestic_violence/home_sidebar.dart';
import 'package:domestic_violence/login_screen.dart';
import 'package:domestic_violence/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:domestic_violence/tic_tac_toe.dart';
import 'package:domestic_violence/ImageWork.dart';
import 'package:domestic_violence/home-views/posts.dart';
import 'package:domestic_violence/home-views/evidence.dart';
import 'package:domestic_violence/home-views/ngo.dart';
import 'package:domestic_violence/home-views/videos.dart';
import 'package:domestic_violence/home-views/emergency.dart';
import 'package:domestic_violence/home-views/add_notes.dart';
import 'package:domestic_violence/home-views/display_video.dart';
import 'package:domestic_violence/localization/demo_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/language_constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // var email = prefs.get('email');

  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print(
              "\n\n\nConnection Error of firebase! Please try again in a moment !!\n\n\n");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print("\n\n\nConnection Established Successfully\n\n\n");
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        print("\n\n\nConnection not Established but no errors\n\n\n");
        return MyApp();
      },
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

  class _MyAppState extends State<MyApp> {
    Locale _locale;
    setLocale(Locale locale) {
      setState(() {
        _locale = locale;
      });
    }
    @override
    void didChangeDependencies() {
      getLocale().then((locale) {
        setState(() {
          this._locale = locale;
        });
      });
      super.didChangeDependencies();
    }

    @override
    Widget build(BuildContext context) {
      if (this._locale == null) {
        return Container(
          child: Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800])),
          ),
        );
      } else {
        return MaterialApp(
          locale: _locale,
          supportedLocales: [
            Locale("en", "US"),
            Locale("hi", "IN")
          ],
          localizationsDelegates: [
            DemoLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          title: 'Domestic Violence fight',
          routes: {
            '/video': (BuildContext context) => VideoPage(title: "Video Upload"),
            '/displayVideo':(BuildContext context) => VideoDemo(),
            '/image': (BuildContext context) => ImageCapture(),
            '/audio': (BuildContext context) => AudioHomeView(),
            '/': (BuildContext context) => HomePage(),
            '/register': (BuildContext context) => Register_Screen(),
            '/login': (BuildContext context) => Login_Screen(),
            '/home': (BuildContext context) => Home_Screen(),
            '/posts':(BuildContext context) => Posts(),
            '/evidence':(BuildContext context) => Evidence(),
            '/ngo':(BuildContext context) => NGO(),
            '/addnotes':(BuildContext context)=>AddNotes(),
            '/education':(BuildContext context) => Videos(),
            '/emergency':(BuildContext context) => Emergency(),
          },

        );
      }
    }
  }

class HomePage extends StatelessWidget {
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //We take the image from the assets
            Image.asset(
              'assets/splash-image.jpg',
              height: 250,
            ),
            SizedBox(
              height: 20,
            ),
            //Texts and Styling of them
            Text(
              'Welcome to TIC TAC TOE !',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),

            SizedBox(
              height: 30,
            ),
            //Our MaterialButton which when pressed will take us to a new screen named as
            //LoginScreen
            MaterialButton(
              elevation: 10,
              height: 50,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => TicTacToe()));
              },
              color: logoGreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Start Playing',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
