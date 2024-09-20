import 'dart:convert';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:graduate/main.dart';
import 'package:graduate/screens/department.dart';
import 'package:graduate/screens/favorites.dart';
import 'package:graduate/screens/profile.dart';
import 'package:graduate/themee/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'add_data/new_teacher.dart';
import 'home_screen.dart';
import 'login_singup/auth/token_manager.dart';


class Screens extends StatefulWidget {
  int currentindex;
  Screens({super.key, required this.currentindex});

  @override
  State<Screens> createState() => _Screens();
}

class _Screens extends State<Screens> {
  bool showPrice = false;
  // Set to false by default to prevent red screen
  List<String> teachers_name = [
    "حسين خريج",
  ];
  List<String> teachersimg = [
    "hussein",
  ];
  List<String> appBarTitle = [
    "الرئيسية",
    "الاقسام",
    "دوراتك",
    "الحساب",
  ];
  List<String> catNames = [
    "الاقسام",
    "الدورات المجانية",
    "المنتجات",
  ];


  List<Icon> catIcons = [
    const Icon(Icons.category, color: Colors.white, size: 30), // for الاقسام
    const Icon(Icons.school, color: Colors.white, size: 30),   // for الدورات المجانية
    const Icon(Icons.store_sharp, color: Colors.white, size: 30), // for المشاريع
  ];

  void addteacher(String name, String img) {
    setState(() {
      teachers_name.add(name);
      teachersimg.add(img);
    });
  }

  @override
  void initState() {
    super.initState();
    AutoOrientation.portraitUpMode();
    _fetchShowPrice();  // Fetch data in initState
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    List<Color> catColors = [
      themeNotifier.customThemeIndex==3 ? Color(0xffFF758F) : Color(0xFF2BB8A7),
      themeNotifier.customThemeIndex==3 ? Color(0xffC9184A) : Color(0xFF28A8AF),
      themeNotifier.customThemeIndex==3 ? Color(0xffFF4D6D) : Color(0xFF247D95),
    ];

    bool isLightMode = themeNotifier.themeMode == ThemeMode.light;
    bool isBlueMode = themeNotifier.themeMode == ThemeMode.system;
    Color Selecteditem = isBlueMode ? Colors.blue:Theme.of(context).primaryColor;
    Color unSelecteditem =isBlueMode ? Colors.white : themeNotifier.customThemeIndex == 3 ? Color(0xffFFF0F3) :isLightMode ?  Colors.grey : Colors.white  ;
    List<Widget> widgetpages = [
      HomePage(catNames: catNames, catColors: catColors, catIcons: catIcons, showPrice: showPrice),
      Department(showPrice: showPrice,appBarTitle:appBarTitle[widget.currentindex]),
      Favorites(appBarTitle:appBarTitle[widget.currentindex]),
      Profile(appBarTitle:appBarTitle[widget.currentindex]),
    ];

    return Scaffold(
      backgroundColor: mainwhitetheme,
      body: showPrice == null
          ? Center(child: CircularProgressIndicator())  // Show loading if data not yet fetched
          : widgetpages.elementAt(widget.currentindex),  // Show content if data is fetched
      bottomNavigationBar: Container(
        decoration:isLightMode ?null:
        BoxDecoration(
          gradient:  LinearGradient(
            colors: [
              isBlueMode ? Color(0xFF0B1320):Color(0xff00161a),  // لون بداية التدرج
              isBlueMode ? Color(0xFF0B1340): mainDarkTheme, // لون نهاية التدرج
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),  // في الوضع الفاتح، استخدم لون ثابت بدلاً من التدرج
            // حدد لون الخلفية في الوضع الفاتح
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: isLightMode ? null : Colors.transparent,  // الحفاظ على الخلفية الشفافة لعرض الـ gradient
          showUnselectedLabels: true,
          iconSize: MediaQuery.of(context).size.width * 0.1,  // الحجم الديناميكي للأيقونات بناءً على عرض الشاشة
          selectedItemColor: Selecteditem,
          selectedFontSize: MediaQuery.of(context).size.width * 0.045,  // حجم الخط الديناميكي بناءً على عرض الشاشة
          unselectedItemColor: unSelecteditem,
          currentIndex: widget.currentindex,
          onTap: (index) {
            setState(() {
              widget.currentindex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                      if (widget.currentindex == 0) // عرض الخط الأزرق فقط إذا كانت هذه الصفحة هي المختارة
                    Container(
                    width: MediaQuery.of(context).size.width * 0.08,
                height: 3,  // سماكة الخط الأزرق
                color: widget.currentindex == 0 ? Selecteditem : unSelecteditem,  // اللون الأزرق للخط
                    ),
                  SvgPicture.asset(
                    'images/home.svg',  // المسار إلى الأيقونة بصيغة SVG
                    width: MediaQuery.of(context).size.width * 0.1,  // الحجم الديناميكي للأيقونة
                    height: MediaQuery.of(context).size.width * 0.1,
                    color: widget.currentindex == 0 ? Selecteditem : unSelecteditem,
                  ),

                ],
              ),
              label: appBarTitle[0],
            ),
            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.currentindex == 1)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.08,
                      height: 3,
                      color: widget.currentindex == 1 ? Selecteditem : unSelecteditem,
                    ),
                  SvgPicture.asset(
                    'images/department.svg',
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.width * 0.1,
                    color: widget.currentindex == 1 ? Selecteditem : unSelecteditem,
                  ),

                ],
              ),
              label: appBarTitle[1],
            ),
            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.currentindex == 2)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.08,
                      height: 3,
                      color: widget.currentindex == 2 ? Selecteditem : unSelecteditem,
                    ),
                  SvgPicture.asset(
                    'images/video_courses.svg',
                    width: MediaQuery.of(context).size.width * 0.09,
                    height: MediaQuery.of(context).size.width * 0.09,
                    color: widget.currentindex == 2 ? Selecteditem : unSelecteditem,
                  ),

                ],
              ),
              label: appBarTitle[2],
            ),
            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.currentindex == 3)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.08,
                      height: 3,
                      color: widget.currentindex == 3 ? Selecteditem : unSelecteditem,
                    ),
                  Icon(
                    Icons.person,
                    size: MediaQuery.of(context).size.width * 0.1,
                    color: widget.currentindex == 3 ? Selecteditem : unSelecteditem,
                  ),
                ],
              ),
              label: appBarTitle[3],
            ),
          ],
        )
      ),

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
        setState(() {
          showPrice = true; // Default value or handle error appropriately
        });
      }
    } catch (e) {
      print("Error fetching showPrice: $e");
      setState(() {
        showPrice = true; // Default value or handle error appropriately
      });
    }
  }
}
