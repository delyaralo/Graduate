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
bool showPrice = true;
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
    //_fetchShowPrice(); // Fetch the showPrice value when the app starts
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

  Future<void> _fetchShowPrice() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/AppleStore/info");
      if (response!.statusCode == 200) {
        final bool price = json.decode(response.body);
        setState(() {
          showPrice = price;
        });
      } else {
        // Handle the case where the request was not successful
        setState(() {
          showPrice = true; // Default value or handle error appropriately
        });
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print("Error fetching showPrice: $e");
      setState(() {
        showPrice = true; // Default value or handle error appropriately
      });
    }
  }
}