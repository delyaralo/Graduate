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
  // ignore: non_constant_identifier_names
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

  });

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late List<dynamic> VideosInfo;
  bool isVideosSection = true;
  late Map Userinfo;
  bool isloading = false;
  bool isloading2 = false; // متغير للتحكم في حالة التحميل عند إضافة الدورة المجانية
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
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Screens(currentindex: 2),), (route) => false);
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
      floatingActionButton: isVideosSection && isadmin
          ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewVideo(),
            ),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
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
                ImageView(isArrow: true, img: widget.Courseimage, trailerVideo: widget.trailerVideo,),
                const SizedBox(height: 15),
                Center(
                  child: Text(
                    widget.Coursetitle ,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    "منصة خريج التعليمية",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.7)),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFF5F3FF),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Material(
                        color: isVideosSection ? const Color(0xFF674AEF) : const Color(0xFF674AEF).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isVideosSection = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                            child: const Text(
                              "Videos",
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: isVideosSection ? const Color(0xFF674AEF).withOpacity(0.6) : const Color(0xFF674AEF),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isVideosSection = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                            child: const Text(
                              "Description",
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: widget.lock
                      ? int.parse(widget.price) != 0
                      ? showPrice==true ?Text(
                    widget.price + "  :  السعر ",
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ):SizedBox.shrink()
                      : Text(
                    " مجاناً ",
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )
                      :SizedBox.shrink(),
                ),
                Center(
                  child: widget.lock
                      ? custombutton(
                    onPressed: () {
                      if (0 < int.parse(widget.price)) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BuyCourse(price: widget.price, title: widget.Coursetitle, depWhatsApp:widget.depWhatsApp),
                          ),
                        );
                      } else {
                        _addFreeCourse(context);
                      }
                    },
                    text: "اضافة",
                  )
                      : null,
                ),
                const SizedBox(height: 10),
                isVideosSection
                    ? widget.lock
                    ? CountVideoSection(CourseId: widget.CourseId, lock: widget.lock, phone_number: Userinfo['phoneNumber'],trailerVideo:widget.trailerVideo)
                    : VideoSection(CourseId: widget.CourseId, lock: widget.lock, phone_number: Userinfo['phoneNumber'])
                    : DescriptionSection(description: widget.description),
              ],
            ),
            if (isloading2)
              Container(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.deepPurple),
                ),
              ),
          ],

        )
            : CustomLoadingIndicator(),
      ),
    );
  }

  Future<Map?> getUserInfo() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/Auth/UserInfo");
      if (response!.statusCode == 200) {
        final Map UserInfo = json.decode(response.body);
        print(response.body);
        return UserInfo;
      } else {
        // Handle the case where the request was not successful
        print("Failed to fetch courses. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print("Error fetching courses: $e");
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