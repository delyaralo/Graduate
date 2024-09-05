import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduate/Edit/edit_project.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'Edit/edit_course.dart';
import 'course_screen.dart';
import 'login_singup/auth/token_manager.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
class Course extends StatefulWidget {
  const Course({super.key});

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  late List<dynamic> CourseInfo;
  late bool isloaded=false;
  void initState()
  {
    super.initState();
    _loadTeacherInfo();
  }
  Future<void> _loadTeacherInfo() async {
    final teacherInfo = await getCourse("494e5497-d034-418a-a378-5274e4403834");
    if (teacherInfo.isNotEmpty) {
      setState(() {
        CourseInfo = teacherInfo;
        print(CourseInfo.length);
      });
      setState(() {
        isloaded=true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   Center(
      child:isloaded?GridView.builder(
        itemCount:CourseInfo.length<4?CourseInfo.length:4,
        shrinkWrap:true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (MediaQuery.of(context).size.height - 75) / 960,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) =>CourseScreen( CourseId: CourseInfo[index]['id'], Courseimage: CourseInfo[index]['image'], Coursetitle: CourseInfo[index]['title'], lock: true, price:CourseInfo[index]['price'].toString(), description: CourseInfo[index]['description'],)));
            },
            onLongPress: (){
              if(isadmin)
              {
              showDialog(context: context, builder: (context) =>
                AlertDialog(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(onPressed:(){
                          showDialog(context: context, builder: (context) =>
                          AlertDialog(content: MaterialButton(onPressed: (){},child: Text("تاكيد الحذف",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,letterSpacing: 1),),))
                          );
                      }, icon: Icon(Icons.delete,color: Colors.red,)),
                      IconButton(onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder:(context) => EditCourse(),));
                      }, icon: Icon(Icons.edit,color: Colors.indigoAccent[400],)),
                    ],
                  ),
                ),);
            }
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
                    child: Image.network(CourseInfo[index]['image'], width: 80, height: 80),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    CourseInfo[index]['title'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.6)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    CourseInfo[index]['price'].toString(),
                    style: TextStyle(fontSize: 15, fontWeight:  FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        },
      ):Center(child: Column(
        children: [
          SizedBox(height: 100,),
          CircularProgressIndicator(),
        ],
      )),
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
        // Handle the case where the request was not successful
        return [];
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      return [];
    }
  }


}





