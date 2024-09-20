
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../course_page/shortcut/customBoxDocoration.dart';
import '../../course_page/shortcut/customCard.dart';
import '../../course_page/shortcut/projectview.dart';
import '../../login_singup/auth/token_manager.dart';
import '../../main.dart';
import '../../screens/buy_course.dart';
import '../../splashScreen/customLoadingIndicator.dart';
import '../../themee/theme_notifier.dart';

class ProjectsPage extends StatefulWidget {
  final bool showPrice;

  const ProjectsPage({super.key, required this.showPrice});

  @override
  State<ProjectsPage> createState() => _ProjectsPage();
}

class _ProjectsPage extends State<ProjectsPage> {
  late List<dynamic> ProjectInfo;
  late bool isloaded = false;
  late bool isempty = false;

  @override
  void initState() {
    super.initState();
    _loadTeacherInfo();
  }

  // دالة لفصل مشاريع Arduino واللابتوبات

  Future<void> _loadTeacherInfo() async {
    final Project_Info = await getProjects();
    if (Project_Info.isNotEmpty) {
      setState(() {
        ProjectInfo = Project_Info;
        isloaded = true;
        // فصل المشاريع بعد تحميل البيانات
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final screenSize = MediaQuery.of(context).size;

    // تحديد عدد الأعمدة بناءً على عرض الشاشة
    final crossAxisCount = screenSize.width < 600 ? 2 : 3;

    // حساب نسبة العرض إلى الارتفاع ديناميكيًا
    final childAspectRatio = (screenSize.width / crossAxisCount) / (screenSize.height / (widget.showPrice ? 2.5 : 3)); // تعديل بسيط إذا كان السعر مخفيًا

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Arduino",
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body:Center(
        child: isloaded
            ? GridView.builder(
          itemCount: ProjectInfo.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,  // عدد الأعمدة ديناميكي
            childAspectRatio: childAspectRatio,  // نسبة العرض إلى الارتفاع ديناميكي
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProjctViewScile(
                    img: ProjectInfo[index]['image'],
                    projectdescription: ProjectInfo[index]['description'],
                    price: ProjectInfo[index]['price'].toString(),
                    title: ProjectInfo[index]['title'],
                    showPrice: widget.showPrice,
                    trailerVideo: ProjectInfo[index]['trailerVideo'],
                    contact: '07748687725-g_raduate-g_raduate',
                    showTrialerViedo: true,
                  ),
                ));
              },
              child: Card(
                elevation: 8, // ظل للكارد
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // زاوية حواف الكارد
                ),
                child: Container(
                  decoration: CustomBoxDecoration(
                    context,
                    themeNotifier.customThemeIndex == 3 ? Color(0xffFF4D6D) : teacherThemeBegin,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // محاذاة المحتوى في المنتصف
                    crossAxisAlignment: CrossAxisAlignment.center, // محاذاة المحتوى أفقيًا في المنتصف
                    children: [
                      CustomCard(
                        imageUrl: ProjectInfo[index]['image']!,
                        title: ProjectInfo[index]['title']!,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0), // مساحة بينية من الأسفل
                        child: widget.showPrice
                            ? Column(
                          children: [
                            Text(
                              ProjectInfo[index]['price'].toString() + " IQD",
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => BuyCourse(
                                      price: ProjectInfo[index]['price'].toString(),
                                      title: ProjectInfo[index]['title'],
                                      contact: "07748687725-g_raduate-g_raduate",
                                      showPrice: true,
                                      image: ProjectInfo[index]['image']!,
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
                            : const SizedBox.shrink(), // إذا تم إخفاء السعر، يتم إزالة عنصر السعر من التخطيط
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )
            : CustomLoadingIndicator(),
      )
    );
  }
  Future<List<dynamic>> getProjects() async {
    try {
      var response =
      await ApiClient().getAuthenticatedRequest(context, "/api/Projects");
      if (response!.statusCode == 200) {
        final List<dynamic> ProjectsList = json.decode(response.body);
        ProjectsList.sort((a, b) => a["order"].compareTo(b["order"]));
        return ProjectsList;
      } else {
        // Handle the case where the request was not successful
        setState(() {
          isempty = true;
        });
        return [response.statusCode];
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print("Error fetching courses: $e");
      return [];
    }
  }
}
