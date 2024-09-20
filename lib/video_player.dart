import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graduate/main.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'dart:math';

class VideoPlayer extends StatefulWidget {
  final String url;
  final String phone_number;
  const VideoPlayer({super.key, required this.url, required this.phone_number});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController controller;
  double positionX = 0.0; // الموضع الأفقي الحالي للرقم
  double positionY = 0.0; // الموضع العمودي الحالي للرقم
  double screenWidth = 0.0; // عرض الشاشة
  double screenHeight = 0.0; // ارتفاع الشاشة
  late Timer textAnimationTimer;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url)!,
    );
    AutoOrientation.fullAutoMode();
    textAnimationTimer = Timer.periodic(const Duration(milliseconds: 5000), (timer) {
      // تحديث موضع الرقم بشكل عشوائي في الاتجاهين الأفقي والعمودي
      positionX = random.nextDouble() * (screenWidth - 100); // 100 هو عرض النص
      positionY = random.nextDouble() * (screenHeight - 100); // 100 هو ارتفاع النص
      setState(() {}); // إعادة إنشاء الشاشة لتحديث الموقع
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // خلفية الفيديو
          Container(
            height: screenHeight,
            width: screenWidth,
            child: YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
            ),
          ),
          // زر العودة
          Positioned(
            top: 5,
            left: 5,
            child: IconButton(
              icon: Icon(Icons.close, color:Color(0xff32DDE6), size: 30),
              onPressed: () {
                Navigator.of(context).pop(); // العودة إلى الصفحة السابقة
              },
            ),
          ),
          // النص المتحرك
          Transform.translate(
            offset: Offset(positionX, positionY),
            child: Text(
              widget.phone_number,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    AutoOrientation.portraitUpMode();
    textAnimationTimer.cancel(); // إلغاء المؤقت عند التخلص من الصفحة
  }
}
