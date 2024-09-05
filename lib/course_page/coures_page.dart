import 'package:flutter/material.dart';
import '../add_data/new_course.dart';
import '../login_singup/auth/login.dart';
import '../login_singup/shortcut/pagecourses.dart';
class CoursePage extends StatelessWidget {
  final String TeacherId;
  const CoursePage({super.key, required this.TeacherId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:isadmin? FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>NewCourse()));
        },
        child:Icon(Icons.add,),
      ):null,
      body:PageCourses(TeacherId:TeacherId)
    );
  }
}
