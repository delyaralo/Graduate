import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graduate/item_screen/projects/projects_page.dart';
import 'package:provider/provider.dart';
import '../../course_page/shortcut/customBoxDocoration.dart';
import '../../course_page/shortcut/customCard.dart';
import '../../course_page/shortcut/projectview.dart';
import '../../main.dart';
import '../../screens/buy_course.dart';
import '../../splashScreen/customLoadingIndicator.dart';
import '../../themee/theme_notifier.dart';
import '../login_singup/auth/token_manager.dart';
import 'laptops/laptops_page.dart';

class ItemPage extends StatefulWidget {
  final bool showPrice; // تأكد من أن هذا المتغير من نوع bool

  const ItemPage({super.key, required this.showPrice});

  @override
  State<ItemPage> createState() => _ItemPage();
}

class _ItemPage extends State<ItemPage> {
  late List<dynamic> ProjectInfo;
  late bool isempty = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final screenSize = MediaQuery.of(context).size;

    // إنشاء قائمة المنتجات وتجاهل laptops إذا كان showPrice = false
    final List items = widget.showPrice
        ? [
      {
        'title': 'laptops',
        'image':
        'https://nulpgduzktpozubpbiqf.supabase.co/storage/v1/object/public/Images/Items/Laptops/laptob.jpg',
      },
      {
        'title': 'Arduino',
        'image':
        'https://nulpgduzktpozubpbiqf.supabase.co/storage/v1/object/public/Images/Items/Laptops/arduino.jpg',
      },
    ]
        : [
      {
        'title': 'Arduino',
        'image':
        'https://nulpgduzktpozubpbiqf.supabase.co/storage/v1/object/public/Images/Items/Laptops/arduino.jpg',
      },
    ];

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
          "المنتجات",
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: items.length,
          // قم بإزالة shrinkWrap
          physics: const AlwaysScrollableScrollPhysics(), // استخدام خاصية تمرير عادية
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
                  builder: (context) => items[index]['title'] == 'laptops'
                      ? LaptopsPage(
                    showPrice: widget.showPrice,
                  )
                      : ProjectsPage(
                    showPrice: widget.showPrice,
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
                        : departmentThemeBegin,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // محاذاة المحتوى في المنتصف
                    crossAxisAlignment: CrossAxisAlignment.center, // محاذاة المحتوى أفقيًا في المنتصف
                    children: [
                      CustomCard(
                        imageUrl: items[index]['image']!,
                        title: items[index]['title']!,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
