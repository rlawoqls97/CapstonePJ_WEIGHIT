import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/services/auth.dart';
import 'package:weighit/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<TheUser>(
      create: (_) => AuthService().user,
      child: MaterialApp(
        title: 'final',
        home: Wrapper(),
        theme: defaultTheme(),
        // routes 지정
        // routes: {
        //   '/initialPage': (context) => Wrapper(),
        // },
      ),
    );
  }

  ThemeData defaultTheme() {
    return ThemeData(
      // the default brightness and colors are DEFINED HERE
      brightness: Brightness.light,
      primaryColor: Color(0xff09255B),
      accentColor: Color(0xff25E4BD),
      backgroundColor: Color(0xffF8F6F6),
      // colorScheme: ColorScheme(
      //   primary: Color(0xff09255B),
      //   brightness: Brightness.light,
      //   secondary: Color(0xff25E4BD),
      //   error: Colors.red,
      //   secondaryVariant: Color(0xff25E4BD),
      //   onBackground: Color(0xff25E4BD),
      //   surface: Color(0xff25E4BD),
      //   onSurface: Color(0xff25E4BD),
      //   onSecondary: Color(0xff25E4BD),
      //   onPrimary: Color(0xff25E4BD),
      //   primaryVariant: Color(0xff25E4BD),
      //   onError: Color(0xff25E4BD),
      //   background: Color(0xff25E4BD),
      // ),

      // the default font family are DEFINED HERE
      // fontFamily: 'Medium'
      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 24.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.black),
        headline2: TextStyle(
            fontSize: 13.0, fontFamily: 'Roboto', color: Color(0xff26E3BC)),
        headline3: TextStyle(
          fontSize: 22.0, fontFamily: 'Roboto', color: Color(0xff26E3BC)
        ),
        headline4: TextStyle(
          fontSize: 17.0, fontFamily: 'Roboto', color: Colors.black,
        ),
        headline6: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.black),
        subtitle1: TextStyle(
            fontSize: 18.0,
            color: Color(0xff26E3BC),
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold),
        subtitle2: TextStyle(
            fontSize: 15.1,
            color: Colors.white,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold),
        bodyText1: TextStyle(fontSize: 14.0, color: Color(0xff26E3BC), fontFamily: 'Roboto'),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Roboto', color: Colors.black),

      ),
    );
  }
}
