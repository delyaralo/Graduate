// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graduate/Edit/edit_techer.dart';
import 'package:graduate/course_page/coures_page.dart';
import 'package:graduate/login_singup/auth/login.dart';
import '../course_page/free_coures.dart';
import '../login_singup/auth/token_manager.dart';
import '../login_singup/shortcut/customappbar.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

import '../splashScreen/customLoadingIndicator.dart';
import 'appBar.dart';
class TeachersFreeCourse extends StatefulWidget
{
  const TeachersFreeCourse({super.key});
  @override
  State<TeachersFreeCourse> createState() => _TeachersState();
}

class _TeachersState extends State<TeachersFreeCourse> {
  late List<dynamic> TeacherInfo;
  late bool isloaded=false;
  @override
  void initState()
  {
    super.initState();
    _loadTeacherInfo();
  }
  Future<void> _loadTeacherInfo() async {
    final teacherInfo = await getTeacher();
    if (teacherInfo.isNotEmpty) {
      setState(() {
        TeacherInfo = teacherInfo;
        print(TeacherInfo.length);
      });
      setState(() {
        isloaded=true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        title: Text(
          "أساتذة الدورات المجانية",
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: ListView(

        children: [
          const SizedBox(height: 20,),
          Center(
            child:isloaded? GridView.builder(
              itemCount:TeacherInfo.length,
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
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => FreeCourse(teacherId:TeacherInfo[index]['id']),));
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
                                  Navigator.of(context).push(MaterialPageRoute(builder:(context) => EditTeacher(),));
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
                      color: containerTheme,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ClipOval(child:CachedNetworkImage(
                            imageUrl: TeacherInfo[index]['image'],
                            width: 100,
                            height: 100,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          )),
                        ),
                        Text(
                            TeacherInfo[index]['title'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.6))),
                        const SizedBox(height: 3),
                        Text(
                          TeacherInfo[index]['name'],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ):CustomLoadingIndicator(),
          ),
        ],
      ),
    );
  }
  Future<List<dynamic>> getTeacher() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/Instructor");
      final List<dynamic> TeacherList=json.decode(response!.body);
      // Check the response
      if (response.statusCode == 200)
      {
        print(response.body);
        print(TeacherList[0]['name']);
        return TeacherList;
      }
      else
      {
        return [];
      }
    }catch (e)
    {
      return [];
    }
  }

}