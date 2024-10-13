import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'dart:math';

import 'main.dart';

class Video_Player extends StatefulWidget {
  final String url;
  final String phone_number;
  const Video_Player({super.key, required this.url, required this.phone_number});

  @override
  State<Video_Player> createState() => _Video_Player();
}

class _Video_Player extends State<Video_Player> {
  late WebViewController controller;
  double positionX = 0.0; // الموضع الأفقي الحالي للرقم
  double positionY = 0.0; // الموضع العمودي الحالي للرقم
  double screenWidth = 0.0; // عرض الشاشة
  double screenHeight = 0.0;

  late Timer textAnimationTimer;
  Random random = Random();

  String convertToEmbed(String youtubeUrl) {
    // Convert the provided YouTube URL to an embeddable URL
    if (youtubeUrl.contains("youtu.be/")) {
      // Extract video ID from shortened URL
      String videoId = youtubeUrl.split("youtu.be/")[1].split("?")[0];
      return "https://www.youtube.com/embed/$videoId?rel=0&modestbranding=1&controls=1&showinfo=0";
    } else if (youtubeUrl.contains("watch?v=")) {
      // Extract video ID from standard URL
      String videoId = youtubeUrl.split("watch?v=")[1].split("&")[0];
      return "https://www.youtube.com/embed/$videoId?rel=0&modestbranding=1&controls=1&showinfo=0";
    } else {
      // If the URL doesn't match known formats, return it as is
      return youtubeUrl;
    }
  }

  @override
  void initState() {
    super.initState();
    String embedUrl = convertToEmbed(widget.url);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar if necessary
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // Prevent navigation to non-embedded YouTube links
            if (request.url.startsWith('https://www.youtube.com/') &&
                !request.url.contains('/embed/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(embedUrl));
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
    screenHeight = MediaQuery.of(context).size.height; // ارتفاع الشاشة
    bool isTablet = screenWidth > 600;
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          bool isLandscape = orientation == Orientation.landscape;
          return Stack(
            children: [
              // خلفية الفيديو
              Container(
                height: screenHeight,
                width: screenWidth,
                child: WebViewWidget(controller: controller),
              ),
              // AppBar شفاف في الأعلى
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height:screenHeight * 0.2
, // You can adjust this height based on the bar size you want to hide
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Center(
                      child: Text(
                        "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ), // Color overlay to cover the top portion and hide the title and download button
                ),
              ),
              Platform.isAndroid
                  ? Positioned(
                bottom: 60,
                right: screenWidth * 0.001,
                child:  Container(
                  width: screenWidth * 0.9,
                  height: 45,
                  color: Colors.white,
                ), // إذا كان iOS، قم بتعطيلها باستخدام عنصر فارغ
              ):SizedBox.shrink(),
              Positioned(
                top: 10, // تعديل الموضع بناءً على حجم الشاشة
                right: 10, // تعديل الموضع بناءً على حجم الشاشة
                child: Container(
                  width: !isLandscape ? screenHeight * 0.2 : screenWidth * 0.2, // عرض الغطاء الذي يعطل زر المشاركة
                  height:!isLandscape ? screenHeight * 0.2 : screenWidth * 0.15, // ارتفاع الغطاء
                  color: Colors.transparent, // لجعل الغطاء غير مرئي ولكن يعطل الزر
                ),
              ),
              Positioned(
                top: 10, // تعديل الموضع بناءً على حجم الشاشة// تعديل الموضع بناءً على حجم الشاشة
                child: Container(
                  width: screenWidth,// عرض الغطاء الذي يعطل زر المشاركة
                  height: 75, // ارتفاع الغطاء
                  color: Colors.white, // لجعل الغطاء غير مرئي ولكن يعطل الزر
                ),
              ),
              Positioned(
                bottom: isLandscape
                    ? screenHeight * 0.018
                    : screenHeight * 0.01, // تعديل الموضع بناءً على الوضع
                right: isLandscape
                    ? screenWidth * 0.015
                    : screenWidth * 0.02, // تعديل الموضع بناءً على الوضع
                child: Container(
                  width:isLandscape
                      ? screenWidth * 0.09
                      : screenWidth * 0.15, // هاتف: تعديل العرض بناءً على الوضع
                  height:isLandscape
                      ? screenHeight * 0.08
                      : screenHeight * 0.05, // هاتف: تعديل الارتفاع بناءً على الوضع
                  color: Colors.black,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // زر الرجوع
                    },
                    icon: Icon(Icons.arrow_back, color: mainColors),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    AutoOrientation.portraitUpMode();
    textAnimationTimer.cancel(); // إلغاء المؤقت عند التخلص من الصفحة
  }
}
