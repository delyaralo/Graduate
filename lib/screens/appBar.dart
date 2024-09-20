import 'dart:async'; // استيراد مكتبة Timer
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graduate/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import '../login_singup/auth/token_manager.dart';
import '../splashScreen/customLoadingIndicator.dart'; // Import the necessary files for ApiClient

class CustomAppBarWidget extends StatefulWidget {
  @override
  _CustomAppBarWidgetState createState() => _CustomAppBarWidgetState();
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  List<Map<String, String?>> slides = [];
  PageController _pageController = PageController();
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchImageUrls();
    _startAutoSlide();
  }

  Future<void> _fetchImageUrls() async {
    try {
      // Fetch the slides using ApiClient with authentication
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/Slides/list");

      if (response?.statusCode == 200) {
        final List<dynamic> data = json.decode(response!.body);
        setState(() {
          slides = data.map((slide) => {
            'imageUrl': slide['imageUrl'] as String?,
            'link': slide['link'] as String?,
          }).toList();
          isLoading = false;
        });
      } else {
        // Handle the error case
        print('Failed to load images. Status code: ${response?.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching images: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 8), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_pageController.page! + 1).toInt() % slides.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _launchURL(String? url) async {
    if (url != null && await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // احسب قيمة borderRadius بناءً على العرض
    double borderRadiusValue = screenWidth * 0.05; // 5% من العرض

    return isLoading
        ? Center(child: CustomLoadingIndicator())
        : Container(
      height: screenHeight * 0.4, // Adjust height as needed
      width: screenWidth, // Make sure the width matches the screen width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: slides.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Check if link is present before trying to launch
                    final link = slides[index]['link'];
                    _launchURL(link);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(slides[index]['imageUrl']!),
                        fit: BoxFit.contain, // Use BoxFit.contain to preserve the aspect ratio
                      ),
                      borderRadius: BorderRadius.circular(borderRadiusValue), // استخدام القيمة المحسوبة
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10), // Space between the PageView and indicator
          Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: slides.length,
              effect: WormEffect(
                activeDotColor: mainColors,
                dotColor: Colors.grey,
                dotHeight: 8,
                dotWidth: 8,
                spacing: 16,
              ),
              onDotClicked: (index) {
                if (index == 0) {
                  _pageController.jumpToPage(0);
                } else {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
