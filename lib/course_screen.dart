import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduate/add_data/new_video.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:graduate/login_singup/shortcut/custombotton.dart';
import 'package:graduate/login_singup/shortcut/imageview.dart';
import 'package:graduate/screens.dart';
import 'package:graduate/splashScreen/customLoadingIndicator.dart';
import 'package:graduate/video_section.dart';
import 'Description_section.dart';
import 'login_singup/auth/token_manager.dart';
import 'login_singup/shortcut/Count_video_section.dart';
import 'main.dart';
import 'mulazim/mulazimsection.dart';
import 'screens/buy_course.dart';

class CourseScreen extends StatefulWidget {
  final bool lock;
  final String CourseId;
  final String Courseimage;
  final String Coursetitle;
  final String price;
  final String description;
  final String depWhatsApp;
  final String trailerVideo;
  final bool showPrice;

  const CourseScreen({
    super.key,
    required this.CourseId,
    required this.Courseimage,
    required this.Coursetitle,
    required this.lock,
    required this.price,
    required this.description,
    required this.depWhatsApp,
    required this.trailerVideo,
    required this.showPrice,
  });

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late List<dynamic> VideosInfo;
  bool isVideosSection = true;
  bool isHandoutSection = false; // Toggle for handouts section
  late Map Userinfo;
  bool isloading = false;
  bool isloading2 = false; // للتحكم في حالة التحميل عند إضافة الدورة المجانية

  @override
  void initState() {
    super.initState();
    _loadTeacherInfo();
  }

  bool showWidget = false;

  void _showWidgetAfterDelay() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        showWidget = true;
      });
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Screens(currentindex: 2),
        ),
            (route) => false,
      );
    });
  }

  Future<void> _loadTeacherInfo() async {
    final teacherInfo = await getUserInfo();
    if (teacherInfo!.isNotEmpty) {
      setState(() {
        Userinfo = teacherInfo!;
        isloading = true;
      });
    }
  }

  Future<String?> _loadAddFreeCourse() async {
    String? message = await ApiClient().addFreeCourse(context, widget.CourseId);
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.Coursetitle,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: isloading
            ? Stack(
          children: [
            ListView(
              children: [
                ImageView(
                  isArrow: true,
                  img: widget.Courseimage,
                  trailerVideo: widget.trailerVideo,
                ),
                const SizedBox(height: 15),
                Center(
                  child: Text(
                    widget.Coursetitle,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: isVideosSection
                                ? const LinearGradient(
                              colors: [
                                Color(0xFF32DDE6),
                                Color(0xFF247D95)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                                : const LinearGradient(
                              colors: [
                                Color(0xFF247D95),
                                Color(0xFF247D95)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isVideosSection = true;
                                isHandoutSection = false;
                              });
                            },
                            child: const Center(
                              child: Text(
                                "الفيديوهات",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                        const SizedBox(width: 10), // Add spacing between buttons
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: isHandoutSection
                                  ? const LinearGradient(
                                colors: [
                                  Color(0xFF32DDE6),
                                  Color(0xFF247D95)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                                  : const LinearGradient(
                                colors: [
                                  Color(0xFF247D95),
                                  Color(0xFF247D95)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isVideosSection = false;
                                  isHandoutSection = true;
                                });
                              },
                              child: const Center(
                                child: Text(
                                  "الملخصات",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 10), // Add spacing between buttons
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: (!isVideosSection && !isHandoutSection)
                                ? const LinearGradient(
                              colors: [
                                Color(0xFF32DDE6),
                                Color(0xFF247D95)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                                : const LinearGradient(
                              colors: [
                                Color(0xFF247D95),
                                Color(0xFF247D95)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isVideosSection = false;
                                isHandoutSection = false;
                              });
                            },
                            child: const Center(
                              child: Text(
                                "الوصف",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Other sections below...
                Center(
                  child: widget.lock
                      ? int.parse(widget.price) != 0
                      ? widget.showPrice == true
                      ? Column(
                        children: [
                          Text(
                                              widget.price + " IQD :  السعر ",
                                              style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                                            ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BuyCourse(
                                    price: widget.price,
                                    title: widget.Coursetitle,
                                    contact: widget.depWhatsApp,
                                    showPrice: true,
                                    image: widget.Courseimage,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "شراء",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColors, // Background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0), // Border radius
                              ),
                            ),
                          )

                        ],
                      )
                      : const Text("     ",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black))
                      : Column(
                        children: [
                          Text(
                                              " مجاناً ",
                                              style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                                            ),
                          ElevatedButton(
                            onPressed: () {
                              _addFreeCourse(context);
                            },
                            child: Text(
                              "اضافة",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColors, // Background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0), // Border radius
                              ),
                            ),
                          ),
                        ],
                      )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 10),
                isVideosSection
                    ? widget.lock
                    ? CountVideoSection(
                  CourseId: widget.CourseId,
                  lock: widget.lock,
                  phone_number: Userinfo['phoneNumber'],
                  trailerVideo: widget.trailerVideo,
                )
                    : VideoSection(
                  CourseId: widget.CourseId,
                  lock: widget.lock,
                  phone_number: Userinfo['phoneNumber'],
                )
                    : isHandoutSection
                    ?  MulazimSection(CourseId:widget.CourseId, phone_number: Userinfo['phoneNumber'],lock: widget.lock)
                    : DescriptionSection(
                  description: widget.description,
                ),
              ],
            ),
            if (isloading2)
              Container(
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.deepPurple),
                ),
              ),
          ],
        )
            :  CustomLoadingIndicator(),
      ),
    );
  }

  Future<Map?> getUserInfo() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/Auth/UserInfo");
      if (response!.statusCode == 200) {
        final Map UserInfo = json.decode(response.body);
        return UserInfo;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user info: $e");
      return null;
    }
  }
  void _addFreeCourse(BuildContext context) async {
    setState(() {
      isloading2 = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('الدورة'),
          content: Text('هل انت متاكد من اضافة هذه الدورة المجانية الى كورساتك'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Handle "No" action here
                Navigator.of(context).pop();
                setState(() {
                  isloading2 = false;
                });
              },
              child: Text('لا'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                String? message = await _loadAddFreeCourse();
                _showWidgetAfterDelay();
                setState(() {
                  isloading2 = false;
                });
              },
              child: Text('نعم'),
            ),
          ],
        );
      },
    );
  }


}
