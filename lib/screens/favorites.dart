import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graduate/course_screen.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:graduate/login_singup/shortcut/customappbar.dart';
import 'package:http/http.dart' as http;

import '../login_singup/auth/token_manager.dart';
import '../main.dart';
import '../splashScreen/customLoadingIndicator.dart';
import 'appBar.dart';
class Favorites extends StatefulWidget
{

  @override
  State<Favorites> createState() => _Favorites();
}

class _Favorites extends State<Favorites> {
  late List<dynamic> CourseInfo;
  late bool isloaded=false;
  late bool isempty =false;
  void initState()
  {
    super.initState();
    _loadTeacherInfo();
  }
  Future<void> _loadTeacherInfo() async {
    final teacherInfo = await getCourse();
    if (teacherInfo.isNotEmpty) {
      setState(() {
        CourseInfo = teacherInfo;
      });
      setState(() {
        isloaded=true;
      });
    }
    else
    {
      setState(() {
        isloaded=true;
      });
      setState(() {
        isempty=true;
      });
    }
  }
  @override
  Widget build (BuildContext context)
  {
    return ListView(
      physics:BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 20,),
        Center(
          child:isloaded? GridView.builder(
            itemCount:isempty?0:CourseInfo.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (MediaQuery.of(context).size.height - 75) / 960,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CourseScreen(CourseId:CourseInfo[index]['id'], Courseimage: CourseInfo[index]['image'], Coursetitle: CourseInfo[index]['title'], lock: false,price: CourseInfo[index]['price'].toString(),description: CourseInfo[index]['description'], depWhatsApp: '07748687725', trailerVideo: CourseInfo[index]['trailerVideo'], showPrice: false,)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:containerTheme,
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
                        overflow: TextOverflow.ellipsis, // يستخدم لإضافة "..." في نهاية النص إذا كان طويلًا
                        maxLines: 2, // يحدد عدد الأسطر
                        textAlign: TextAlign.center, // لضبط النص في الوسط
                      ),
                      const SizedBox(height: 10),
                      Text(
                          "تم الاضافة",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.6))),
                    ],
                  ),
                ),
              );
            },
          ):CustomLoadingIndicator(),
        ),
        Container(child: isempty?Center(child: Text("لا توجد كورسات",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)):null)
      ],
    );
  }
  Future<List<dynamic>> getCourse() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context,"/api/UserCourses");
      if (response!.statusCode == 200) {
        final List<dynamic> courseList = json.decode(response.body);
        print(response.body);
        return courseList;
      } else if(response!.statusCode == 404)
      {
        setState(() {
          isempty=true;
        });
        return [response.statusCode];
      }
      else
      {
        return [response.statusCode];
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print("Error fetching courses: $e");
      return [];
    }
  }
}
