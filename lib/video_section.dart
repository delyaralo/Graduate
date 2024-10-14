import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduate/main.dart';
import 'package:graduate/splashScreen/customLoadingIndicator.dart';
import 'package:graduate/video_player.dart';
import 'Edit/edit_video.dart';
import 'custombutton.dart';
import 'login_singup/auth/login.dart';
import 'login_singup/auth/token_manager.dart';
import 'dart:convert';

class VideoSection extends StatefulWidget {
  final String CourseId;
  final bool lock;
  final String phone_number;
  const VideoSection({super.key, required this.CourseId, required this.lock, required this.phone_number});

  @override
  State<VideoSection> createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  late bool isempty = false;
  late List<dynamic> VideosInfo;
  late bool isloaded = false;

  @override
  void initState() {
    super.initState();
    _loadTeacherInfo();
  }

  Future<void> _loadTeacherInfo() async {
    final teacherInfo = await getVideos(widget.CourseId);
    if (teacherInfo.isNotEmpty) {
      setState(() {
        VideosInfo = teacherInfo;
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
        ListView.separated(
          itemCount: isempty ? 0 : VideosInfo.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final video = VideosInfo[index];
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: mainColors,
                  shape: BoxShape.circle,
                ),
                child: widget.lock
                    ? const Icon(Icons.lock, color: Colors.white, size: 30)
                    : const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
              ),
              title: Text(
                video['title'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Checkbox(
                value: video['isWatched'], // قيمه الجيك بوكس
                onChanged: widget.lock
                    ? null
                    : (value)  {
                  // انتظار انتهاء العملية قبل تحديث الواجهة
                  if (value == true) {
                     _isWatched(video['id']); // استدعاء تمت المشاهدة
                  } else {
                     _isNotWatched(video['id']); // استدعاء لم يتم المشاهدة
                  }
                  // تحديث واجهة المستخدم بعد إتمام العملية
                  setState(() {
                    video['isWatched'] = value;
                  });
                },
              ),
              onTap: widget.lock
                  ? null
                  : () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Platform.isAndroid ? Video_Player(
                    url: video['link'],
                    phone_number: widget.phone_number,
                  ):VideoPlayer(url: video['link'],
                    phone_number: widget.phone_number),
                ));
              },
              onLongPress: () {
                if (isadmin) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: MaterialButton(
                                    onPressed: () {
                                      // تأكيد الحذف هنا
                                    },
                                    child: const Text(
                                      "تاكيد الحذف",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditVideo(),
                                ),
                              );
                            },
                            icon: Icon(Icons.edit, color: Colors.indigoAccent[400]),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          },
          separatorBuilder: (context, index) {
            return Container(
              height: 1, // سمك الخط الفاصل
              margin: EdgeInsets.symmetric(vertical: 10), // المسافة بين العناصر والخط
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff32DDE6), Color(0xff2D3479)], // ألوان التدرج
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            );
          },
        ),
        Container(
          child: isempty
              ? const Center(
            child: Text(
              "قَرِيبًا",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          )
              : null,
        ),
      ],
    )
        : CustomLoadingIndicator();
  }

  Future<List<dynamic>> getVideos(String CourseId) async {
    var response = await ApiClient().getAuthenticatedRequest(context, "api/Videos/$CourseId");
    if (response?.statusCode == 200) {
      final List<dynamic> VideosList = json.decode(response!.body);
      VideosList.sort((a, b) => a["order"].compareTo(b["order"]));
      print(response?.body);
      return VideosList;
    } else {
      print("Failed to fetch courses. Status code: ${response?.statusCode}");
      setState(() {
        isempty = true;
      });
      return [];
    }
  }

  Future<String?> _isWatched(String videoId) async {
    String? message = await ApiClient().isWatched(context, widget.CourseId, videoId);
    return message;
  }

  Future<String?> _isNotWatched(String videoId) async {
    String? message = await ApiClient().isNotWatched(context, widget.CourseId, videoId);
    return message;
  }
}
