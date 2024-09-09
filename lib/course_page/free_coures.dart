import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../Edit/edit_course.dart';
import '../course_screen.dart';
import '../login_singup/auth/login.dart';
import '../login_singup/auth/token_manager.dart';
import '../login_singup/shortcut/customappbar.dart';
import '../main.dart';
import '../screens/appBar.dart';

class FreeCourse extends StatefulWidget {
  final String teacherId;
  const FreeCourse({Key? key, required this.teacherId}) : super(key: key);

  @override
  State<FreeCourse> createState() => _FreeCourseState();
}

class _FreeCourseState extends State<FreeCourse> {
  late List<dynamic> courseInfo = [];
  late bool isLoaded = false;
  late bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    _loadTeacherInfo();
  }

  Future<void> _loadTeacherInfo() async {
    final teacherInfo = await getCourse(widget.teacherId);
    if (teacherInfo.isNotEmpty) {
      setState(() {
        courseInfo = teacherInfo;
        isLoaded = true;
        isEmpty = false;
      });
    } else {
      setState(() {
        isEmpty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // الحصول على عرض وارتفاع الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // حساب عدد الأعمدة اعتمادًا على عرض الشاشة
    int crossAxisCount = screenWidth < 600 ? 2 : screenWidth < 900 ? 3 : 4;

    // حساب نسبة العرض إلى الارتفاع ديناميكيًا
    double childAspectRatio = screenWidth / (screenHeight / 1.2);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "الدورات المجانية",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: isLoaded
          ? isEmpty
          ? const Center(
        child: Text(
          "لا توجد كورسات",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      )
          : GridView.builder(
        itemCount: courseInfo.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseScreen(
                    CourseId: courseInfo[index]['id'],
                    Courseimage: courseInfo[index]['image'],
                    Coursetitle: courseInfo[index]['title'],
                    lock: true,
                    price: courseInfo[index]['price'].toString(),
                    description: courseInfo[index]['description'],
                    depWhatsApp: '07748687725',
                    trailerVideo: courseInfo[index]['trailerVideo'],
                    showPrice: false,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: containerTheme,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CachedNetworkImage(
                      imageUrl: courseInfo[index]['image'],
                      width: 100,
                      height: 100,
                      placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    courseInfo[index]['title'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "مجاناً",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          );
        },
      )
          : Center(
        child: Column(
          children: [
            SizedBox(height: screenHeight / 1.8),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> getCourse(String instructorId) async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(
          context, "/api/Course/instructor/free/$instructorId");
      if (response?.statusCode == 200) {
        final List<dynamic> courseList = json.decode(response!.body);
        return courseList;
      } else {
        setState(() {
          isEmpty = true;
        });
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
