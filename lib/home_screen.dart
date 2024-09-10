import 'package:flutter/material.dart';
import 'package:graduate/course.dart';
import 'package:graduate/course_page/projects.dart';
import 'package:graduate/screens.dart';
import 'package:graduate/screens/appBar.dart';
import 'package:graduate/screens/teacherFreeCourse.dart';
import 'login_singup/shortcut/projectview.dart';

class HomePage extends StatefulWidget {
  final List<String> catNames;
  final List<Color> catColors;
  final List<Icon> catIcons;
  final bool showPrice;

  const HomePage({super.key, required this.catNames, required this.catColors, required this.catIcons, required this.showPrice});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(  // Wrapped in SingleChildScrollView for scrolling
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          children: [
            CustomAppBarWidget(),
            const SizedBox(height: 20),
            GridView.builder(
              itemCount: widget.catIcons.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: widget.catColors[index],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: widget.catIcons[index],
                        ),
                      ),
                      onTap: () {
                        if (index == 0) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Screens(currentindex: 1)),
                                (route) => false,
                          );
                        } else if (index == 1) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => TeachersFreeCourse()),
                          );
                        } else if (index == 2) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Projects(showPrice: widget.showPrice)),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.catNames[index],
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.7)),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "الدورات",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 23),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Screens(currentindex: 1)),
                          (route) => false,
                    );
                  },
                  child: Text(
                    "مشاهدة المزيد",
                    style: TextStyle(color: Colors.indigoAccent[400], fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Course(showPrice: widget.showPrice),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "المشاريع",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 23),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Projects(showPrice: widget.showPrice)),
                    );
                  },
                  child: Text(
                    "مشاهدة المزيد",
                    style: TextStyle(color: Colors.indigoAccent[400], fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ProjectView(check: false, showPrice: widget.showPrice),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
