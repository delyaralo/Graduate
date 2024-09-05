import 'package:flutter/material.dart';
import 'package:graduate/main.dart';
import 'dart:convert';
import '../../splashScreen/customLoadingIndicator.dart';
import '../../video_player.dart';
import '../../video_section.dart';
import '../auth/token_manager.dart';

class CountVideoSection extends StatefulWidget {
  final String CourseId;
  final bool lock;
  final String phone_number;
  final String trailerVideo;
  const CountVideoSection({super.key, required this.CourseId, required this.lock, required this.phone_number, required this.trailerVideo});

  @override
  State<CountVideoSection> createState() => _CountVideoSection();
}

class _CountVideoSection extends State<CountVideoSection> {
  late bool isempty = false;
  late List<dynamic> VideosInfo = [];
  late bool isloaded = false;

  @override
  void initState() {
    super.initState();
    _loadTeacherInfo();
  }

  Future<void> _loadTeacherInfo() async {
    final videos = await getVideos(widget.CourseId);
    if (videos.isNotEmpty) {
      setState(() {
        VideosInfo = videos;
        isloaded = true;
      });
    } else {
      setState(() {
        isempty = true;
        isloaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isloaded
        ? Column(
      children: [
        if (widget.trailerVideo.isNotEmpty)
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: mainColors, shape: BoxShape.circle),
              child: Icon(Icons.play_arrow_rounded, color: mainwhitetheme, size: 30),
            ),
            title: Text('مقدمة الدورة'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoPlayer(url:widget.trailerVideo,phone_number:''),));
            },
          ),
        ListView.builder(
          itemCount: isempty ? 0 : VideosInfo.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: mainColors, shape: BoxShape.circle),
                child: widget.lock
                    ? Icon(Icons.lock, color: mainwhitetheme, size: 30)
                    : Icon(Icons.play_arrow_rounded, color: mainwhitetheme, size: 30),
              ),
              title: Text(VideosInfo[index]['title']),
              onTap: () {
                // Handle video tap
              },
            );
          },
        ),
        Container(
          child: isempty
              ? const Center(
              child: Text(
                "لا توجد فديوات",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ))
              : null,
        ),
      ],
    )
        : CustomLoadingIndicator();
  }

  Future<List<dynamic>> getVideos(String CourseId) async {
    var response = await ApiClient().getAuthenticatedRequest(
        context, "/api/Videos/Preview/$CourseId");
    if (response?.statusCode == 200) {
      final List<dynamic> VideosList = json.decode(response!.body);
      print(response.body);
      return VideosList;
    } else {
      print("Failed to fetch courses. Status code: ${response?.statusCode}");
      setState(() {
        isempty = true;
      });
      return [];
    }
  }
}
