import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduate/course_page/coures_page.dart';
import '../login_singup/auth/token_manager.dart';
import '../splashScreen/customLoadingIndicator.dart';
import 'appBar.dart';

class Teachers extends StatefulWidget {
  final String departmentId;

  Teachers({super.key, required this.departmentId});
  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  late String depWhatsApp;
  String depTelegram="----";
  late List<dynamic> instructors = [];
  late bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadTeacherInfo();
  }

  Future<void> _loadTeacherInfo() async {
    final departmentData = await getTeacher();
    if (departmentData != null) {
      setState(() {
        depWhatsApp = departmentData['departmentContact'];  // تحديث بيانات التواصل// تحديث بيانات التواصل
        instructors = departmentData['instructors'];  // تخزين قائمة المدرسين
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        title: Text(
          "الأساتذة",
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 20,),
          Center(
            child: isLoaded ? GridView.builder(
              itemCount: instructors.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (MediaQuery.of(context).size.height - 75) / 900,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoursePage(TeacherId: instructors[index]['id'], depWhatsApp: depWhatsApp, depTelegram: depTelegram),));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFFF5F3FF),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ClipOval(child: CachedNetworkImage(
                            imageUrl: instructors[index]['image'],
                            width: 100,
                            height: 100,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          )),
                        ),
                        Text(
                            instructors[index]['title'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.6))),
                        const SizedBox(height: 3),
                        Text(
                          instructors[index]['name'],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ) : CustomLoadingIndicator(),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> getTeacher() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/Departments/instructors/${widget.departmentId}");
      if (response?.statusCode == 200) {
        return json.decode(response!.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
