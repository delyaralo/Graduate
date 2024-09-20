import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graduate/course_screen.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:graduate/login_singup/shortcut/customappbar.dart';
import 'package:http/http.dart' as http;
import '../course_page/shortcut/customBoxDocoration.dart';
import '../course_page/shortcut/customCard.dart';
import '../login_singup/auth/token_manager.dart';
import '../main.dart';
import '../splashScreen/customLoadingIndicator.dart';
import 'appBar.dart';

class Favorites extends StatefulWidget {
  final String appBarTitle;
  const Favorites({super.key, required this.appBarTitle});
  @override
  State<Favorites> createState() => _Favorites();
}

class _Favorites extends State<Favorites> {
  late List<dynamic> CourseInfo;
  late bool isLoaded = false;
  late bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    _loadCourseInfo();
  }

  Future<void> _loadCourseInfo() async {
    final courseInfo = await getCourse();
    if (courseInfo.isNotEmpty) {
      setState(() {
        CourseInfo = courseInfo;
        isLoaded = true;
      });
    } else {
      setState(() {
        isLoaded = true;
        isEmpty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.appBarTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: Center(  // Center the ListView
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            const SizedBox(height: 20),
            isLoaded
                ? Align(  // Align to the center
              alignment: Alignment.center,
              child: GridView.builder(
                itemCount: isEmpty ? 0 : CourseInfo.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (MediaQuery.of(context).size.height - 75) / 960,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
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
                            lock: false,
                            price: CourseInfo[index]['price'].toString(),
                            description: CourseInfo[index]['description'],
                            depWhatsApp: '07748687725',
                            trailerVideo: CourseInfo[index]['trailerVideo'],
                            showPrice: false,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration:CustomBoxDecoration(context,courseThemeBegin),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,  // تعديل التمركز في المنتصف
                          crossAxisAlignment: CrossAxisAlignment.center, // التمركز أفقياً
                          children: [
                        CustomCard(
                        imageUrl: CourseInfo[index]['image']!,
                          title: CourseInfo[index]['title']!,
                        ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "تم الاضافة",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF28A8AF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
                : CustomLoadingIndicator(),
            if (isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "لا توجد كورسات",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3479),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }


  Future<List<dynamic>> getCourse() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/UserCourses");
      if (response!.statusCode == 200) {
        final List<dynamic> courseList = json.decode(response.body);
        return courseList;
      } else if (response!.statusCode == 404) {
        setState(() {
          isEmpty = true;
        });
        return [];
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching courses: $e");
      return [];
    }
  }
}
