import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:graduate/login_singup/auth/token_manager.dart';
import '../../screens.dart';
class LoginOrScreens extends StatefulWidget {
  @override
  _LoginOrScreensState createState() => _LoginOrScreensState();
}

class _LoginOrScreensState extends State<LoginOrScreens> {
  @override
  void initState() {
    super.initState();
    autoLogin();
  }
  void autoLogin() async {
    String? token = await secure_storage.read(key: 'token');
    if (token != null) {
      bool isrefreshtokenexpired=await ApiClient().isJwtTokenExpired();
      if(!isrefreshtokenexpired)
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Screens(currentindex: 0)),
            (route) => false,
      );
      else
        {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Login()),
          (route) => false,);
        }
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    // You can return a loading screen or something here
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}