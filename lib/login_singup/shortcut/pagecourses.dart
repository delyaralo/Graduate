import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import '../../Edit/edit_course.dart';
import '../../course_screen.dart';
import '../../main.dart';
import '../../splashScreen/customLoadingIndicator.dart';
import '../auth/token_manager.dart';

class PageCourses extends StatefulWidget {
  final String TeacherId;
  final String depWhatsApp;
  final String depTelegram;
  final bool showPrice;

  const PageCourses({
    super.key,
    required this.TeacherId,
    required this.depWhatsApp,
    required this.depTelegram,
    required this.showPrice,
  });

  @override
  State<PageCourses> createState() => _PageCoursesState();
}

class _PageCoursesState extends State<PageCourses> {
  late List<dynamic> CourseInfo;
  late bool isloaded = false;
  late bool isempty = false;

  @override
  void initState() {
    super.initState();
    _loadTeacherInfo();
  }

  Future<void> _loadTeacherInfo() async {
    final teacherInfo = await getCourse(widget.TeacherId);
    if (teacherInfo.isNotEmpty) {
      setState(() {
        CourseInfo = teacherInfo;
        isloaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final crossAxisCount = screenSize.width < 600 ? 2 : 3;  // Dynamically set crossAxisCount based on screen width
    final childAspectRatio = (screenSize.width / crossAxisCount) / (screenSize.height / 3);  // Dynamic aspect ratio

    return ListView(
      children: [
        const SizedBox(height: 20),
        Center(
          child: isloaded
              ? GridView.builder(
            itemCount: isempty ? 0 : CourseInfo.length,
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
                        depWhatsApp: widget.depWhatsApp,
                        trailerVideo: CourseInfo[index]['trailerVideo'],
                        showPrice: widget.showPrice,
                      ),
                    ),
                  );
                },
                onLongPress: () {
                  if (isadmin) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: MaterialButton(
                                      onPressed: () {},
                                      child: Text(
                                        "تاكيد الحذف",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditCourse(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit, color: Colors.indigoAccent[400]),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 10),
                      widget.showPrice == true
                          ? Text(
                        "${CourseInfo[index]['price']} IQD",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : Text(
                        "     ",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
              : CustomLoadingIndicator(),
        ),
        isempty
            ? const Center(
          child: Text(
            "لا توجد كورسات",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        )
            : Container(),
      ],
    );
  }

  Future<List<dynamic>> getCourse(String instructorId) async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(
        context,
        "/api/Course/instructor/$instructorId",
      );
      if (response?.statusCode == 200) {
        final List<dynamic> courseList = json.decode(response!.body);
        print(response.body);
        return courseList;
      } else {
        setState(() {
          isempty = true;
        });
        return [response!.statusCode];
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      return [];
    }
  }
}
