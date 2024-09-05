// ignore_for_file: non_constant_identifier_names
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:graduate/splashScreen/customLoadingIndicator.dart';
import 'package:graduate/video_player.dart';
import 'Edit/edit_video.dart';
import 'login_singup/auth/login.dart';
import 'login_singup/auth/token_manager.dart';
import 'dart:convert';

class VideoSection extends StatefulWidget
{
  final String CourseId;
  final bool lock;
  final String phone_number;
  const VideoSection({super.key, required this.CourseId, required this.lock, required this.phone_number});

  @override
  State<VideoSection> createState() => _VideoSectionState();
}
class _VideoSectionState extends State<VideoSection> {
  late bool isempty=false;
  late List<dynamic> VideosInfo;
  late bool isloaded=false;
  void initState()
  {
    super.initState();
    _loadTeacherInfo();
  }
  Future<void> _loadTeacherInfo() async {
    final teacherInfo = await getVideos(widget.CourseId);
    if (teacherInfo.isNotEmpty) {
      setState(() {
        VideosInfo = teacherInfo;
      });
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
          itemCount:isempty?0:VideosInfo.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.indigoAccent[400],
                    shape: BoxShape.circle
                ),
                child:widget.lock? const Icon(Icons.lock,color: Colors.white,size: 30,):const Icon(Icons.play_arrow_rounded,color: Colors.white,size: 30,),
              ),
              title: Text( VideosInfo[index]['title']),
              onTap:widget.lock?null:(){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoPlayer(url:VideosInfo[index]['link'],phone_number:widget.phone_number),));
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
                                  AlertDialog(content: MaterialButton(onPressed: (){

                                  },child: const Text("تاكيد الحذف",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,letterSpacing: 1),),))
                              );
                            }, icon: const Icon(Icons.delete,color: Colors.red,)),
                            IconButton(onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder:(context) => EditVideo(),));
                            }, icon: Icon(Icons.edit,color: Colors.indigoAccent[400],)),
                          ],
                        ),
                      ),);
                }
              },
            );
          },
        ),
        Container(child: isempty?const Center(child: Text("لا توجد فديوات",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)):null)
      ],
    ):CustomLoadingIndicator();
  }
  Future<List<dynamic>> getVideos(String CourseId) async {
    var response = await ApiClient().getAuthenticatedRequest(
        context, "api/Videos/$CourseId");
    if (response?.statusCode == 200)
    {
      // ignore: non_constant_identifier_names
      final List<dynamic> VideosList = json.decode(response!.body);
      VideosList.sort((a, b) => a["order"].compareTo(b["order"]));
      print(response?.body);
      return VideosList;
    } else {// Handle the case where the request was not successful
      print("Failed to fetch courses. Status code: ${response?.statusCode}");
      setState(() {
        isempty=true;
      });
      return [response?.statusCode];
    }
  }
}