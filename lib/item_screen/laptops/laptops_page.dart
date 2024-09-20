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

class LaptopsPage extends StatefulWidget {
  final bool showPrice;

  const LaptopsPage({super.key, required this.showPrice});

  @override
  State<LaptopsPage> createState() => _LaptopsPage();
}

class _LaptopsPage extends State<LaptopsPage> {
  late List<dynamic> LaptopInfo = [];
  late bool isloaded = false;
  late bool isempty = false;

  @override
  void initState() {
    super.initState();
    _loadTeacherInfo();
  }

  // دالة لفصل مشاريع Arduino واللابتوبات
  Future<void> _loadTeacherInfo() async {
    final Laptop_Info = await getProjects();
    if (Laptop_Info.isNotEmpty) {
      setState(() {
        LaptopInfo = Laptop_Info;
        isloaded = true;
      });
    } else {
      setState(() {
        isloaded = true;
        isempty = true; // وضع العلامة true إذا كانت القائمة فارغة
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

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Laptop",
            style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ),
        body: Center(
          child: isloaded
              ? isempty
              ? Text(
            "Laptop" + " قريباً سيتم فتح قسم " , // الرسالة التي سيتم عرضها إذا لم تتوفر بيانات
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          )
              : GridView.builder(
            itemCount: LaptopInfo.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
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
                      img: LaptopInfo[index]['imageUrl'],
                      projectdescription: LaptopInfo[index]['description'],
                      price: LaptopInfo[index]['price'].toString(),
                      title: LaptopInfo[index]['title'],
                      showPrice: widget.showPrice,
                      trailerVideo: "",
                      contact: LaptopInfo[index]['contact'],
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
                      themeNotifier.customThemeIndex == 3
                          ? Color(0xffFF4D6D)
                          : teacherThemeBegin,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // محاذاة المحتوى في المنتصف
                      crossAxisAlignment: CrossAxisAlignment.center, // محاذاة المحتوى أفقيًا في المنتصف
                      children: [
                        CustomCard(
                          imageUrl: LaptopInfo[index]['imageUrl']!,
                          title: LaptopInfo[index]['title']!,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0), // مساحة بينية من الأسفل
                          child: widget.showPrice
                              ? Column(
                            children: [
                              Text(
                                LaptopInfo[index]['price'].toString() + " IQD",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BuyCourse(
                                        price: LaptopInfo[index]['price'].toString(),
                                        title: LaptopInfo[index]['title'],
                                        contact:
                                        LaptopInfo[index]['contact'],
                                        showPrice: true,
                                        image: LaptopInfo[index]['imageUrl']!,
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
        ));
  }

  Future<List<dynamic>> getProjects() async {
    try {
      var response =
      await ApiClient().getAuthenticatedRequest(context, "/api/Laptops");
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
