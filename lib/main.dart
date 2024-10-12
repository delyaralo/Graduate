import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graduate/policyScreen/policyScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // مكتبة SharedPreferences
import 'package:graduate/splashScreen/splashScreen.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:graduate/themee/theme_notifier.dart';
import 'package:graduate/themee/themme.dart';
import 'package:graduate/themee/mainThemes.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'login_singup/auth/login.dart';
import 'login_singup/auth/singup.dart';

String URL = "graduate-a29962909a04.herokuapp.com";

Color mainColors = ThemeColors.primary;
Color mainDarkTheme = ThemeColors.darkBackground;
Color mainDarkgray = ThemeColors.darkgray;
Color mainwhitetheme = ThemeColors.whitetheme;
Color courseThemeBegin = ThemeColors.courseThemeBeginLight;
Color courseThemeEnd = ThemeColors.courseThemeEnd;
Color teacherThemeBegin = ThemeColors.teacherThemeBeginLight;
Color teacherThemeEnd = ThemeColors.teacherThemeEnd;
Color departmentThemeBegin = ThemeColors.departmentThemeBeginLight;
Color departmentThemeEnd = ThemeColors.departmentThemeEnd;
Color bottomNavigationBarDark = ThemeColors.bottomNavigationBarDark;



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  bool isPolicyAccepted = await _checkIfPolicyAccepted(); // Check if policy was accepted
  bool isEmulator = await _checkIfRunningOnEmulator(); // Check if running on emulator

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(), // Provide ThemeNotifier
      child: MyApp(isPolicyAccepted: isPolicyAccepted, isEmulator: isEmulator),
    ),
  );
}

Future<bool> _checkIfPolicyAccepted() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isPolicyAccepted') ?? false; // Return false if policy not accepted yet
}

Future<bool> _checkIfRunningOnEmulator() async {
  final deviceInfo = DeviceInfoPlugin();
  bool isEmulator = false;

  try {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await deviceInfo.androidInfo;
      isEmulator = androidInfo.isPhysicalDevice == false;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iosInfo = await deviceInfo.iosInfo;
      isEmulator = iosInfo.isPhysicalDevice == false;
    }

    return isEmulator;
  } catch (e) {
    print('Error checking if running on emulator: $e');
    return false; // Assume it's not an emulator in case of error
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final bool isPolicyAccepted;
  final bool isEmulator;
  bool underDeveloment = true; // Set to false when you finish development

  MyApp({required this.isPolicyAccepted, required this.isEmulator});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isLightMode = themeNotifier.themeMode == ThemeMode.light;
    bool isBlueMode = themeNotifier.themeMode == ThemeMode.system;

    isLightMode
        ? courseThemeBegin = ThemeColors.courseThemeBeginLight
        : isBlueMode
        ? courseThemeBegin = ThemeColors.courseThemeBeginBlue
        : courseThemeBegin = ThemeColors.courseThemeBeginDark;

    teacherThemeBegin = isLightMode
        ? ThemeColors.teacherThemeBeginLight
        : isBlueMode
        ? ThemeColors.teacherThemeBeginBlue
        : ThemeColors.teacherThemeBeginDark;

    departmentThemeBegin = isLightMode
        ? ThemeColors.departmentThemeBeginLight
        : isBlueMode
        ? ThemeColors.departmentThemeBeginBlue
        : ThemeColors.departmentThemeBeginDark;

    if (isEmulator && !underDeveloment) {
      // Show a dialog if running on an emulator
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) => AlertDialog(
            title: Text('نزلت المحاكي من اجل تسجيل المحاضرات'),
            content: Text('دور طريقة ثانية لان هاي الطريقة مانعها من زمان.'),
            actions: [
              TextButton(
                child: Text('موافق'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Future.delayed(Duration.zero, () => exit(0)); // Exit the app
                },
              ),
            ],
          ),
        );
      });

      return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: Text('الرجاء استخدام جهاز حقيقي')),
        ),
      );
    }
    else {

     //FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

      return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.customThemeIndex == 0 ? lightTheme :
        themeNotifier.customThemeIndex == 2 ? blueTheme :
        themeNotifier.customThemeIndex == 3 ? pinkTheme :darkTheme,
        darkTheme: themeNotifier.customThemeIndex == 0 ? lightTheme :
        themeNotifier.customThemeIndex == 2 ? blueTheme :
        themeNotifier.customThemeIndex == 3 ? pinkTheme :darkTheme,
        themeMode: themeNotifier.themeMode,
        home: isPolicyAccepted ? SplashScreen() : PolicyScreen(),
        routes: {
          "signup": (context) => Signup(),
          "login": (context) => Login(),
        },
      );
    }
  }
}


