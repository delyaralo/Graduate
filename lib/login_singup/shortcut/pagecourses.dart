import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import '../../Edit/edit_course.dart';
import '../../course_page/shortcut/customBoxDocoration.dart';
import '../../course_page/shortcut/customCard.dart';
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
  bool isSearching=false;
  late List<dynamic> CourseInfo;
  late List<dynamic> filteredCourseInfo;
  late bool isloaded = false;
  late bool isempty = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_filterCourses);
    _loadTeacherInfo();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTeacherInfo() async {
    final teacherInfo = await getCourse(widget.TeacherId);
    if (teacherInfo.isNotEmpty) {
      setState(() {
        CourseInfo = teacherInfo;
        filteredCourseInfo = CourseInfo; // Initialize filtered list
        isloaded = true;
      });
    }
  }

  void _filterCourses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCourseInfo = CourseInfo.where((course) {
        final title = course['title'].toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          int crossAxisCount = screenWidth < 600 ? 2 : screenWidth < 900 ? 3 : 4;  // Dynamically set crossAxisCount based on screen width
          final childAspectRatio = (screenWidth / crossAxisCount) / (screenHeight / 3);  // Dynamic aspect ratio

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Directionality(
                  textDirection: TextDirection.rtl, // Sets text direction from right to left
                  child: TextField(

                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'ابحث باسم الدورة...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xff32DDE6), width: 2), // Solid border color
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xff28A8AF), width: 2), // Border color when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xff247D95), width: 2), // Border color when focused
                      ),
                      suffixIcon: Icon(Icons.search, color: mainColors), // Icon color
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodySmall?.color, // Correct way to access primary color
                    ),
                    textAlign: TextAlign.right, // Aligns text to the right
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: isloaded
                          ? GridView.builder(
                        itemCount: isempty ? 0 : filteredCourseInfo.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount, // Dynamic crossAxisCount
                          childAspectRatio: childAspectRatio, // Dynamic aspect ratio
                          mainAxisSpacing: 12, // Spacing between cards
                          crossAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseScreen(
                                    CourseId: filteredCourseInfo[index]['id'],
                                    Courseimage: filteredCourseInfo[index]['image'],
                                    Coursetitle: filteredCourseInfo[index]['title'],
                                    lock: true,
                                    price: filteredCourseInfo[index]['price'].toString(),
                                    description: filteredCourseInfo[index]['description'],
                                    depWhatsApp: widget.depWhatsApp,
                                    trailerVideo: filteredCourseInfo[index]['trailerVideo'],
                                    showPrice: widget.showPrice,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 8,
                              shadowColor: Color(0xFF28A8AF).withOpacity(0.35), // تأثير الظل
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20), // زاوية الكارد
                              ),
                              child: Container(
                                decoration: CustomBoxDecoration(context,courseThemeBegin),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomCard(
                                      imageUrl: filteredCourseInfo[index]['image']!,
                                      title: filteredCourseInfo[index]['title']!,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0), // Padding أسفل النص
                                      child: Text(
                                        widget.showPrice == true
                                            ? "${filteredCourseInfo[index]['price']} IQD"
                                            : " ",
                                        style: TextStyle(
                                          fontSize: 14, // حجم النص للسعر
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
                ),
              ),
            ],
          );
        },
      ),
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
        return courseList;
      } else {
        setState(() {
          isempty = true;
        });
        return [];
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      return [];
    }
  }
}
