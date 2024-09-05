import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import '../../Edit/edit_project.dart';
import '../../course_page/shortcut/projectview.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;

import '../auth/token_manager.dart';
class ProjectView extends StatefulWidget
{
  final bool check;
  const ProjectView({super.key,required this.check});
  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {

  late List<dynamic> ProjectInfo;
  late bool isloaded=false;
  late bool isempty =false;
  void initState()
  {
    super.initState();
    _loadTeacherInfo();
  }
  Future<void> _loadTeacherInfo() async {
    final teacherInfo = await getProjects();
    if (teacherInfo.isNotEmpty) {
      setState(() {
        ProjectInfo = teacherInfo;
      });
      setState(() {
        isloaded=true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Center(
      child: isloaded?GridView.builder(
        itemCount:widget.check==true?ProjectInfo.length:2,
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>ProjctViewScile(img: ProjectInfo[index]['image'], projectdescription:ProjectInfo[index]['description'],price: ProjectInfo[index]['price'].toString(), title: ProjectInfo[index]['title'],) ,));
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
                            Navigator.of(context).push(MaterialPageRoute(builder:(context) => EditProject(),));
                          }, icon: Icon(Icons.edit,color: Colors.indigoAccent[400],)),
                        ],
                      ),
                    ),);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFF5F3FF),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.network(ProjectInfo[index]['image'], width: 80, height: 80,fit:BoxFit.fill,),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ProjectInfo[index]['title'],
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "اضافة",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigoAccent[400]),
                  ),
                ],
              ),
            ),
          );
        },
      ):Center(child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height/8,),
          CircularProgressIndicator(),
        ],
      )),
    );
  }
  Future<List<dynamic>> getProjects() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context,"/api/Projects");
      if (response!.statusCode == 200) {
        final List<dynamic> ProjectsList = json.decode(response.body);
        return ProjectsList;
      } else {// Handle the case where the request was not successful
        setState(() {
          isempty=true;
        });
        return [response.statusCode];
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print("Error fetching courses: $e");
      return [];
    }
  }
}