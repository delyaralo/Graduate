import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graduate/course_page/shortcut/customBoxDocoration.dart';
import 'package:graduate/course_page/shortcut/customCard.dart';
import '../Edit/edit_course.dart';
import '../course_screen.dart';
import '../login_singup/auth/login.dart';
import '../login_singup/auth/token_manager.dart';
import '../main.dart';

class FreeCourse extends StatefulWidget {
  final String teacherId;
  const FreeCourse({Key? key, required this.teacherId}) : super(key: key);

  @override
  State<FreeCourse> createState() => _FreeCourseState();
}

class _FreeCourseState extends State<FreeCourse> {
  late List<dynamic> courseInfo = [];
  late List<dynamic> filteredCourseInfo = [];
  late bool isLoaded = false;
  late bool isEmpty = false;
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
    final teacherInfo = await getCourse(widget.teacherId);
    setState(() {
      courseInfo = teacherInfo;
      filteredCourseInfo = courseInfo;
      isLoaded = true;
      isEmpty = teacherInfo.isEmpty;
    });
  }

  void _filterCourses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCourseInfo = courseInfo.where((course) {
        final title = course['title'].toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    int crossAxisCount = screenWidth < 600 ? 2 : screenWidth < 900 ? 3 : 4;
    double childAspectRatio = screenWidth / (screenHeight / 1.5); // تحسين نسبة العرض إلى الارتفاع

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "الدورات المجانية",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'ابحث باسم الدورة...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xff32DDE6), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xff28A8AF), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xff247D95), width: 1.5),
                  ),
                  suffixIcon: Icon(Icons.search, color: mainColors, size: 20),
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodySmall?.color, // Correct way to access primary color
                ),
                textAlign: TextAlign.right,
              ),

            ),
          ),
          Expanded(
            child: isLoaded
                ? isEmpty
                ? const Center(
              child: Text(
                "لا توجد كورسات",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
                : GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredCourseInfo.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio, // استخدام نسبة العرض إلى الارتفاع المحسنة
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
                          CourseId: filteredCourseInfo[index]['id'],
                          Courseimage: filteredCourseInfo[index]['image'],
                          Coursetitle: filteredCourseInfo[index]['title'],
                          lock: true,
                          price: filteredCourseInfo[index]['price'].toString(),
                          description: filteredCourseInfo[index]['description'],
                          depWhatsApp: '07748687725',
                          trailerVideo: filteredCourseInfo[index]['trailerVideo'],
                          showPrice: false,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 8, // تقليل ارتفاع الظل
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // تقليل الحدود الدائرية
                    ),
                    child: Container(
                      decoration: CustomBoxDecoration(context,courseThemeBegin),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // تعديل التمركز في المنتصف
                        crossAxisAlignment: CrossAxisAlignment.center, // التمركز أفقياً
                        children: [
                      CustomCard(
                      imageUrl: filteredCourseInfo[index]['image']!,
                        title: filteredCourseInfo[index]['title']!,
                      ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: const Text(
                              "مجاناً",
                              style: TextStyle(
                                fontSize: 18, // تصغير حجم النص
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
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ],
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
