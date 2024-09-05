import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchImageUrls();
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

    return isLoading
        ? Center(child: CustomLoadingIndicator())
        : Container(
      height: screenHeight * 0.4, // Adjust height as needed
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
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
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
                activeDotColor: Colors.blue,
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
                    duration: Duration(milliseconds: 300),
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
