import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../login_singup/shortcut/auto_login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after a delay
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds:3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginOrScreens()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xffCFFFFE),
      body: Center(
        child: Image.asset('images/splash_v.gif'),
      ),
    );
  }
}
