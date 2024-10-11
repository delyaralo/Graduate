import 'dart:convert';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduate/screens/department.dart';
import 'package:graduate/screens/favorites.dart';
import 'package:graduate/screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'home_screen.dart';
import 'login_singup/auth/token_manager.dart';
import 'themee/theme_notifier.dart';
import 'package:provider/provider.dart';

class Screens extends StatefulWidget {
  int currentindex;
  Screens({super.key, required this.currentindex});

  @override
  State<Screens> createState() => _Screens();
}

class _Screens extends State<Screens> {
  bool showPrice = false;
  bool _isAdShown = false;
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
    const Icon(Icons.category, color: Colors.white, size: 30),
    const Icon(Icons.school, color: Colors.white, size: 30),
    const Icon(Icons.store_sharp, color: Colors.white, size: 30),
  ];
  List<Map<String, String?>> adds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    AutoOrientation.portraitUpMode();
    _fetchAddsUrls();
    _fetchShowPrice();
  }

  Future<void> _checkAdDisplay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastShownTimestamp = prefs.getInt('lastAdShownTime');
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    if (lastShownTimestamp == null || currentTime - lastShownTimestamp >= 86400000) {
      if (!isLoading) {
        _showAd();
      }
      await prefs.setInt('lastAdShownTime', currentTime);
    }
  }

// جلب بيانات الإعلانات
  Future<void> _fetchAddsUrls() async {
    try {
      // Fetch the slides using ApiClient with authentication
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/Slides/list");

      if (response?.statusCode == 200) {
        final List<dynamic> data = json.decode(response!.body);
        setState(() {
          adds = data.map((slide) => {
            'imageUrl': slide['imageUrl'] as String?,
            'link': slide['link'] as String?,
          }).toList();
          isLoading = false; // انتهى التحميل
        });

        _checkAdDisplay(); // بعد انتهاء التحميل تحقق من عرض الإعلان

      } else {
        // Handle the error case
        print('Failed to load images. Status code: ${response?.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching images: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

// وظيفة عرض الإعلان
  void _showAd() {
    bool canClose = false; // لا يمكن غلق الـDialog مباشرة
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        canClose = true; // يمكن غلق الـDialog بعد 5 ثوانٍ
      });
    });

    Future.delayed(Duration.zero, () {
      if (adds.isNotEmpty && adds[0]['imageUrl'] != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        String? url = adds[0]['link'];
                        if (url != null && await canLaunch(url)) {
                          await launch(url);
                        } else {
                          print('Could not launch $url');
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: 3 / 2,
                          child: CachedNetworkImage(
                            imageUrl: adds[0]['imageUrl']!,
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()), // عرض مؤشر تحميل أثناء جلب الصورة
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(seconds: 5),
                        builder: (context, value, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: value,
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // لون الدائرة
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (canClose) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        print("No ads to show.");
      }
    });
  }


  // باقي الكود
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    List<Color> catColors = [
      themeNotifier.customThemeIndex == 3 ? Color(0xffFF758F) : Color(0xFF2BB8A7),
      themeNotifier.customThemeIndex == 3 ? Color(0xffC9184A) : Color(0xFF28A8AF),
      themeNotifier.customThemeIndex == 3 ? Color(0xffFF4D6D) : Color(0xFF247D95),
    ];

    bool isLightMode = themeNotifier.themeMode == ThemeMode.light;
    bool isBlueMode = themeNotifier.themeMode == ThemeMode.system;
    Color Selecteditem = isBlueMode ? Colors.blue : Theme.of(context).primaryColor;
    Color unSelecteditem = isBlueMode
        ? Colors.white
        : themeNotifier.customThemeIndex == 3
        ? Color(0xffFFF0F3)
        : isLightMode
        ? Colors.grey
        : Colors.white;

    List<Widget> widgetpages = [
      HomePage(catNames: catNames, catColors: catColors, catIcons: catIcons, showPrice: showPrice),
      Department(showPrice: showPrice, appBarTitle: appBarTitle[widget.currentindex]),
      Favorites(appBarTitle: appBarTitle[widget.currentindex]),
      Profile(appBarTitle: appBarTitle[widget.currentindex]),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: showPrice == null
          ? Center(child: CircularProgressIndicator())  // Show loading if data not yet fetched
          : widgetpages.elementAt(widget.currentindex),  // Show content if data is fetched
      bottomNavigationBar: Container(
        decoration: isLightMode
            ? null
            : BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isBlueMode ? Color(0xFF0B1320) : Color(0xff00161a),  // لون بداية التدرج
              isBlueMode ? Color(0xFF0B1340) : Theme.of(context).primaryColor, // لون نهاية التدرج
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
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
                  if (widget.currentindex == 0)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.08,
                      height: 3,  // سماكة الخط الأزرق
                      color: widget.currentindex == 0 ? Selecteditem : unSelecteditem,
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
        ),
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
