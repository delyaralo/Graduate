// ignore_for_file: non_constant_identifier_names
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduate/Edit/edit_techer.dart';
import 'package:graduate/course_page/coures_page.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:graduate/screens/teachers.dart';
import '../login_singup/auth/token_manager.dart';
import '../login_singup/shortcut/customappbar.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

import '../splashScreen/customLoadingIndicator.dart';
import 'appBar.dart';

class Department extends StatefulWidget {
  final bool showPrice;
   Department({super.key, required this.showPrice});

  @override
  State<Department> createState() => _DepartmentState();
}

class _DepartmentState extends State<Department> {
  List<dynamic> departmentInfo = []; // تم التهيئة بمصفوفة فارغة
  bool isloaded = false; // افتراضياً تكون القيمة false

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
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 20,),
          Center(
            child: isloaded
                ? GridView.builder(
              itemCount: departmentInfo.length,
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
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Teachers(departmentId: departmentInfo[index]['id'],showPrice:widget.showPrice),
                    ));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: containerTheme,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: departmentInfo[index]['imageUrl'],
                              width: 100,
                              height: 100,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ),
                        Text(
                          departmentInfo[index]['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withOpacity(0.6),
                          ),
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
    );
  }

  Future<List<dynamic>> getDepartment() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/Departments/list");
      final List<dynamic> departmentInfoList = json.decode(response!.body);
      if (response.statusCode == 200) {
        print(response.body);
        print(departmentInfoList[0]['name']);
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
