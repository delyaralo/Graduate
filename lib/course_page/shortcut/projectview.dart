import 'package:flutter/material.dart';
import 'package:graduate/Description_section.dart';
import 'package:graduate/login_singup/shortcut/imageview.dart';

import '../../main.dart';
import '../../screens/buy_course.dart';

class ProjctViewScile extends StatelessWidget {
  final String price;
  final String img;
  final String projectdescription;
  final String title;
  final String trailerVideo;
  final bool showPrice;
  final String contact;
  final bool showTrialerViedo;
  ProjctViewScile({
    super.key,
    required this.img,
    required this.projectdescription,
    required this.price,
    required this.title,
    this.showPrice = false,
    required this.trailerVideo,
    required this.contact,
    required this.showTrialerViedo,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.05,
        ),
        child: ListView(
          children: [
            ImageView(img: img, isArrow: showTrialerViedo, trailerVideo: trailerVideo),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "$title",
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            projectdescription.isNotEmpty
                ? DescriptionSection(description: projectdescription)
                : SizedBox(height: screenHeight * 0.03),
            SizedBox(height: screenHeight * 0.02),

            SizedBox(height: screenHeight * 0.02),
            showPrice
                ? Column(
              children: [
                Text(
                  price + " IQD",
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                 ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BuyCourse(
                          price: price,
                          title: title,
                          contact: contact,
                          showPrice: true,
                          image: img,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "شراء",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColors, // لون خلفية الزر
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // حواف الزر مستديرة
                    ),
                  ),
                ),
              ],
            )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _contactInfo(String platform, String contact, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "$platform : $contact",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
