import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduate/course_page/free_coures.dart';
import '../course_page/shortcut/customBoxDocoration.dart';
import '../course_page/shortcut/customCard.dart';
import '../login_singup/auth/token_manager.dart';
import '../main.dart';
import '../splashScreen/customLoadingIndicator.dart';

class TeachersFreeCourse extends StatefulWidget {
  const TeachersFreeCourse({super.key});

  @override
  State<TeachersFreeCourse> createState() => _TeachersState();
}

class _TeachersState extends State<TeachersFreeCourse> {
  late List<dynamic> TeacherInfo = [];
  late List<dynamic> filteredTeacherInfo = [];
  late bool isLoaded = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_filterTeachers);
    _loadTeacherInfo();
  }

  Future<void> _loadTeacherInfo() async {
    final teacherInfo = await getTeacher();
    if (teacherInfo.isNotEmpty) {
      setState(() {
        TeacherInfo = teacherInfo;
        filteredTeacherInfo = TeacherInfo; // Initialize with all teachers
        isLoaded = true;
      });
    }
  }

  void _filterTeachers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredTeacherInfo = TeacherInfo.where((teacher) {
        final name = teacher['name'].toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust number of grid columns dynamically based on the screen width
    int crossAxisCount = screenWidth < 600
        ? 2
        : screenWidth < 900
        ? 3
        : 4;

    // Adjust the child aspect ratio based on screen dimensions
    double childAspectRatio = screenWidth / (screenHeight * 0.75);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "أساتذة الدورات المجانية",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 3),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'البحث ...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xff32DDE6), width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xff28A8AF), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xff247D95), width: 2),
                          ),
                          suffixIcon: Icon(Icons.search, color: mainColors),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: isLoaded
                      ? GridView.builder(
                    itemCount: filteredTeacherInfo.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FreeCourse(
                                teacherId: filteredTeacherInfo[index]['id'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          decoration: CustomBoxDecoration(context, teacherThemeBegin),
                          child: Column(
                            children: [
                              CustomCard(
                                imageUrl: filteredTeacherInfo[index]['image']!,
                                title: filteredTeacherInfo[index]['title']!,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                filteredTeacherInfo[index]['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                      : CustomLoadingIndicator(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<List<dynamic>> getTeacher() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/Instructor");
      final List<dynamic> TeacherList = json.decode(response!.body);
      if (response.statusCode == 200) {
        return TeacherList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
