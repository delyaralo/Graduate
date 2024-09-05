import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
class CustomLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'images/loading.json', // تأكد من أنك وضعت ملف JSON في مجلد الأصول
        width: 120,  // قم بتعديل الحجم حسب احتياجاتك
        height: 120, // قم بتعديل الحجم حسب احتياجاتك
      ),
    );
  }
}
