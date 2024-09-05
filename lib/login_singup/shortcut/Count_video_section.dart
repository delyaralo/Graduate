// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:graduate/main.dart';
import 'dart:convert';
import '../auth/token_manager.dart';
class CountVideoSection extends StatefulWidget
{
  final String CourseId;
  final bool lock;
  final String phone_number;
  const CountVideoSection({super.key, required this.CourseId, required this.lock, required this.phone_number});

  @override
  State<CountVideoSection> createState() => _CountVideoSection();
}

class _CountVideoSection extends State<CountVideoSection> {
  late bool isempty=false;
  late int VideosInfo;
  late bool isloaded=false;
  void initState()
  {
    super.initState();
    _loadTeacherInfo();
  }
  Future<void> _loadTeacherInfo() async {
    final int teacherInfo = await getVideos(widget.CourseId);
    if (teacherInfo!=0) {
      setState(() {
        VideosInfo = teacherInfo;
      });
      setState(() {
        isloaded=true;
      });
    }
    else
    {
      isempty=true;
      setState(() {
        isloaded=true;
      });
    }
  }
  @override
  Widget build(BuildContext context )
  {
    return isloaded?Column(
      children: [
        ListView.builder(
          itemCount:isempty?0:VideosInfo,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color:mainColors,
                    shape: BoxShape.circle
                ),
                child:widget.lock?  Icon(Icons.lock,color:mainwhitetheme,size: 30,): Icon(Icons.play_arrow_rounded,color: mainwhitetheme,size: 30,),
              ),
              title: Text("lecture ${index + 1}"),
              onTap:null,
            );
          },
        ),
        Container(child: isempty?const Center(child: Text("لا توجد فديوات",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)):null)
      ],
    ):const Center(child: Column(
      children: [
        SizedBox(height: 100,),
        CircularProgressIndicator(),
      ],
    ));
  }
  Future<int> getVideos(String CourseId) async {
    var response = await ApiClient().getAuthenticatedRequest(
        context, "/api/Videos/Count/$CourseId");
    if (response?.statusCode == 200) {
      // ignore: non_constant_identifier_names
      final int VideosList = json.decode(response!.body);
      print(response?.body);
      return VideosList;
    } else {// Handle the case where the request was not successful
      print("Failed to fetch courses. Status code: ${response?.statusCode}");
      setState(() {
        isempty=true;
      });
      return 0;
    }
  }
}
