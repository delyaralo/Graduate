import 'package:flutter/material.dart';
import '../add_data/new_course.dart';
import '../login_singup/auth/login.dart';
import '../login_singup/shortcut/pagecourses.dart';
class CoursePage extends StatelessWidget {
  final String TeacherId;
  final String depWhatsApp;
  final String depTelegram;
  final bool showPrice;
  const CoursePage({super.key, required this.TeacherId, required this.depWhatsApp, required this.depTelegram, required this.showPrice});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[50],
          elevation: 0,
          centerTitle: true,
          title: Text(
            "الدورات",
            style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ),
        floatingActionButton:isadmin? FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>NewCourse()));
          },
          child:Icon(Icons.add,),
        ):null,
        body:PageCourses(TeacherId:TeacherId, depWhatsApp: depWhatsApp, depTelegram:depTelegram,showPrice:showPrice)
    );
  }
}
