import 'package:flutter/material.dart';
import 'package:graduate/course.dart';
import 'package:graduate/course_page/projects.dart';
import 'package:graduate/item_screen/item_page.dart';
import 'package:graduate/item_screen/laptops/laptops_page.dart';
import 'package:graduate/main.dart';
import 'package:graduate/screens.dart';
import 'package:graduate/screens/appBar.dart';
import 'package:graduate/screens/teacherFreeCourse.dart';
import 'package:provider/provider.dart';
import 'item_screen/laptops/LaptopPrevieo.dart';
import 'login_singup/shortcut/projectview.dart';
import 'package:graduate/themee/theme_notifier.dart';
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          IconButton(
            alignment: Alignment.topRight,
            icon: Icon(
              themeNotifier.customThemeIndex == 0
                  ? Icons.wb_sunny
                  : themeNotifier.customThemeIndex == 1
                  ? Icons.nights_stay
                  : themeNotifier.customThemeIndex == 2
                  ? Icons.star
                  : Icons.favorite,
              color: Color(0xFF32DDE6),
              size: 30,
            ),
            onPressed: () {
              // Toggle through the themes (Light -> Dark -> Blue -> Pink)
              int newThemeIndex = (themeNotifier.customThemeIndex + 1) % 4;
              themeNotifier.toggleTheme(newThemeIndex); // Toggle between light, dark, blue, and pink themes
            },
          ),
          CustomAppBarWidget(),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Column(
              children: [
                GridView.builder(
                  itemCount: widget.catIcons.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.1,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {

                            double screenWidth = MediaQuery.of(context).size.width;
                            double screenHeight = MediaQuery.of(context).size.height;


                            double iconSize = screenWidth * 0.15;
                            double spacing = screenHeight * 0.02;

                            return Column(
                              children: [
                                InkWell(
                                  child: Container(
                                    height: iconSize,
                                    width: iconSize,
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
                                      setState(() {
                                        Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(builder: (context) => Screens(currentindex: 1)),
                                              (route) => false,
                                        );
                                      });
                                    } else if (index == 1) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => TeachersFreeCourse()),
                                      );
                                    } else if (index == 2) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => ItemPage(showPrice: widget.showPrice)),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: spacing),
                                Text(
                                  widget.catNames[index],
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            );
                          },
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
                      "الأكثر شهرة",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 23),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Screens(currentindex: 1)),
                                (route) => false,
                          );
                        });
                      },
                      child: Text(
                        "مشاهدة المزيد",
                        style: TextStyle(color: themeNotifier.customThemeIndex ==3 ? Color(0xff590D22) : mainColors, fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // استخدام CachedNetworkImage هنا بدلاً من Image.network
                Course(showPrice: widget.showPrice),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "الأكثر شهرة",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 23),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ItemPage(showPrice:widget.showPrice)),
                          );
                        });
                      },
                      child: Text(
                        "مشاهدة المزيد",
                        style: TextStyle(color:themeNotifier.customThemeIndex ==3 ? Color(0xff590D22) : mainColors, fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ProjectView(check: false,showPrice:widget.showPrice),
                widget.showPrice ? LaptopsPrevieo(check: false, showPrice: widget.showPrice,): const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}