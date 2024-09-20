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

class LaptopsPrevieo extends StatefulWidget {
  final bool check;
  final showPrice;

  const LaptopsPrevieo({super.key, required this.check, required this.showPrice});

  @override
  State<LaptopsPrevieo> createState() => _LaptopsPrevieo();
}

class _LaptopsPrevieo extends State<LaptopsPrevieo> {
  late List<dynamic> laptopsPrevieo = [];
  late bool isloaded = false;
  late bool isempty = false;

  @override
  void initState() {
    super.initState();
    _loadTeacherInfo();
  }

  Future<void> _loadTeacherInfo() async {
    final laptops_Previeo = await getProjects();
    if (laptops_Previeo.isNotEmpty) {
      setState(() {
        laptopsPrevieo = laptops_Previeo;
        isloaded = true;
      });
    } else {
      setState(() {
        isloaded = true;
        isempty = true;
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
    final childAspectRatio = (screenSize.width / crossAxisCount) /
        (screenSize.height / (widget.showPrice ? 2.5 : 3)); // تعديل بسيط إذا كان السعر مخفيًا

    return Center(
      child: isloaded
          ? (laptopsPrevieo.isNotEmpty
          ? GridView.builder(
        itemCount: laptopsPrevieo.length >= 2 ? 2 : laptopsPrevieo.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount, // عدد الأعمدة ديناميكي
          childAspectRatio: childAspectRatio, // نسبة العرض إلى الارتفاع ديناميكي
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProjctViewScile(
                  img: laptopsPrevieo[index]['imageUrl'],
                  projectdescription: laptopsPrevieo[index]['description'],
                  price: laptopsPrevieo[index]['price'].toString(),
                  title: laptopsPrevieo[index]['title'],
                  showPrice: widget.showPrice,
                  trailerVideo: '',
                  contact: laptopsPrevieo[index]['contact'],
                  showTrialerViedo: false,
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
                      imageUrl: laptopsPrevieo[index]['imageUrl']!,
                      title: laptopsPrevieo[index]['title']!,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0), // مساحة بينية من الأسفل
                      child: widget.showPrice
                          ? Column(
                        children: [
                          Text(
                            laptopsPrevieo[index]['price'].toString() + " IQD",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
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
          : const Center(
        child: Text(
          " ً",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ))
          : CustomLoadingIndicator(),
    );
  }

  Future<List<dynamic>> getProjects() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/Laptops");
      if (response!.statusCode == 200) {
        final List<dynamic> ProjectsList = json.decode(response.body);
        return ProjectsList;
      } else {
        // Handle the case where the request was not successful
        setState(() {
          isempty = true;
        });
        return [];
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print("Error fetching courses: $e");
      return [];
    }
  }
}
