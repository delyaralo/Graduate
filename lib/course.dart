import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:graduate/splashScreen/customLoadingIndicator.dart';
import 'Edit/edit_course.dart';
import 'course_screen.dart';
import 'login_singup/auth/token_manager.dart';
import 'main.dart';

class Course extends StatefulWidget {
  final bool showPrice;

  const Course({super.key, required this.showPrice});

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  late List<dynamic> CourseInfo;
  late bool isloaded = false;

  @override
  void initState() {
    super.initState();
    _loadTeacherInfo();
  }

  Future<void> _loadTeacherInfo() async {
    final teacherInfo = await getCourse("494e5497-d034-418a-a378-5274e4403834");
    if (teacherInfo.isNotEmpty) {
      setState(() {
        CourseInfo = teacherInfo;
        print(CourseInfo.length);
        isloaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final crossAxisCount = screenSize.width < 600 ? 2 : 3;  // Dynamically set crossAxisCount based on screen width
    final childAspectRatio = (screenSize.width / crossAxisCount) / (screenSize.height / 3);  // Dynamic aspect ratio

    return Center(
      child: isloaded
          ? GridView.builder(
        itemCount:CourseInfo.length<4?CourseInfo.length:4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,  // Dynamic crossAxisCount
          childAspectRatio: childAspectRatio,  // Dynamic aspect ratio
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
                    CourseId: CourseInfo[index]['id'],
                    Courseimage: CourseInfo[index]['image'],
                    Coursetitle: CourseInfo[index]['title'],
                    lock: true,
                    price: CourseInfo[index]['price'].toString(),
                    description: CourseInfo[index]['description'],
                    depWhatsApp: '07748687725',
                    trailerVideo: CourseInfo[index]['trailerVideo'],
                    showPrice: widget.showPrice,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.only( top:10,right: 10,left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: containerTheme,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CachedNetworkImage(
                      imageUrl: CourseInfo[index]['image'],
                      width: 100,
                      height: 100,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    CourseInfo[index]['title'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.6)),
                  ),
                  const SizedBox(height: 10),
                  widget.showPrice
                      ? Text(
                    " ${CourseInfo[index]['price']} IQD",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )
                      : Text(
                    "     ",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                  )
                ],
              ),
            ),
          );
        },
      )
          : CustomLoadingIndicator(),
    );
  }

  Future<List<dynamic>> getCourse(String instructorId) async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/Course/instructor/$instructorId");
      if (response?.statusCode == 200) {
        final List<dynamic> courseList = json.decode(response!.body);
        print(response.body);
        return courseList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
