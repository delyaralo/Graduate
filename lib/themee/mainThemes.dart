import 'package:flutter/material.dart';
import '../main.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: mainColors,
  cardColor: mainwhitetheme,
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black.withOpacity(0.9),
    ),
  ),
  brightness: Brightness.light,
  fontFamily: "NotoKufiArabic",
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: mainwhitetheme,
    iconTheme: IconThemeData(color: mainDarkTheme),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  primaryColor: mainColors,
  cardColor: mainDarkTheme,
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  ),
  brightness: Brightness.dark,
  fontFamily: "NotoKufiArabic",
  scaffoldBackgroundColor: mainDarkTheme,
  appBarTheme: AppBarTheme(
    backgroundColor: mainDarkTheme,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: bottomNavigationBarDark,
  ),
);

ThemeData blueTheme = ThemeData(
  primaryColor: mainColors,
  cardColor: Color(0xFF162780),  // Card color: #162780
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  ),
  brightness: Brightness.dark,
  fontFamily: "NotoKufiArabic",
  scaffoldBackgroundColor: Color(0xFF0B1340),  // Background color: #0B1340
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF0B1340),  // AppBar background: #213ABF
    iconTheme: IconThemeData(color: Color(0xFF2B4EFF)),  // Icon color: #2B4EFF
    titleTextStyle: TextStyle(
      color: Colors.white,  // Title color: #2B4EFF
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF2746E6),  // Bottom nav background: #2746E6
  ),
);
ThemeData pinkTheme = ThemeData(
  primaryColor: Color(0xFF800F2F),  // لون الـ Primary: #800F2F
  cardColor: Color(0xFFFFB3C1),  // لون البطاقات: #FFB3C1
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Color(0xff590D22),  // نصوص كبيرة بيضاء
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w500,
      color: Color(0xFF590D22),  // نصوص صغيرة بلون داكن #590D22
    ),
  ),
  brightness: Brightness.light,  // الإضاءة فاتحة
  fontFamily: "NotoKufiArabic",  // الخط
  scaffoldBackgroundColor: Color(0xFFFFCCD5),  // خلفية الـ Scaffold: #FFF0F3
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFFF4D6D),  // خلفية شريط التطبيقات: #800F2F
    iconTheme: IconThemeData(color: Color(0xFF590D22)),  // لون الأيقونات: #FF4D6D
    titleTextStyle: TextStyle(
      color: Colors.white,  // لون العنوان: أبيض
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFFF8FA3),  // خلفية شريط التنقل السفلي: #C9184A
    selectedItemColor: Color(0xFFFF758F),  // لون العنصر المختار: #FF758F// لون العنصر غير المختار: #590D22
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFF800F2F),  // لون الأزرار: #800F2F
    textTheme: ButtonTextTheme.primary,  // نصوص الأزرار بلون الـ Primary
  ),

);
