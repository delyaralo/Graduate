import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:graduate/splashScreen/splashScreen.dart';
import 'package:graduate/themee/themme.dart';
import 'login_singup/auth/login.dart';
import 'login_singup/auth/singup.dart';
import 'login_singup/auth/token_manager.dart';

String URL = "graduate-a29962909a04.herokuapp.com";
Color mainColors = ThemeColors.primary;
Color mainDarkTheme = ThemeColors.darkBackground;
Color mainDarkgray = ThemeColors.darkgray;
Color mainwhitetheme = ThemeColors.whitetheme;
Color containerTheme = ThemeColors.ContainerTheme;
void main() async {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Fetch the showPrice value when the app starts
  }
  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "NotoKufiArabic",
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SplashScreen(), // Use SplashScreen as the initial screen
      routes: {
        "signup": (context) => Signup(),
        "login": (context) => Login(),
      },
    );
  }


}