import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduate/course_page/coures_page.dart';
import 'package:graduate/screens/teachers.dart';
import '../course_page/shortcut/customBoxDocoration.dart';
import '../course_page/shortcut/customCard.dart';
import '../login_singup/auth/token_manager.dart';
import '../splashScreen/customLoadingIndicator.dart';
import '../main.dart';

class Department extends StatefulWidget {
  final bool showPrice;
  final String appBarTitle;
  const Department({super.key, required this.showPrice, required this.appBarTitle});

  @override
  State<Department> createState() => _DepartmentState();
}

class _DepartmentState extends State<Department> {
  List<dynamic> departmentInfo = [];
  bool isloaded = false;

  @override
  void initState() {
    super.initState();
    _loadDepartmentInfo();
  }

  Future<void> _loadDepartmentInfo() async {
    final teacherInfo = await getDepartment();
    if (teacherInfo.isNotEmpty) {
      setState(() {
        departmentInfo = teacherInfo;
        isloaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    final crossAxisCount = screenSize.width < 600 ? 2 : 3; // Dynamically set crossAxisCount based on screen width
    final childAspectRatio = (screenSize.width / crossAxisCount) / (screenSize.height / 3); // Dynamic aspect ratio

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.appBarTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 20),
            Center(
              child: isloaded
                  ? GridView.builder(
                itemCount: departmentInfo.length,
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
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Teachers(
                          departmentId: departmentInfo[index]['id'],
                          showPrice: widget.showPrice,
                        ),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: CustomBoxDecoration(context,departmentThemeBegin),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      CustomCard(
                      imageUrl: departmentInfo[index]['imageUrl']!,
                        title: departmentInfo[index]['name']!,
                      ),
                          const SizedBox(height: 3),
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
      ),
    );
  }

  Future<List<dynamic>> getDepartment() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/Departments/list");
      final List<dynamic> departmentInfoList = json.decode(response!.body);
      if (response.statusCode == 200) {
        return departmentInfoList;
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching departments: $e");
      return [];
    }
  }
}
