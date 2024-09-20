// box_decoration.dart
import 'package:flutter/material.dart';

BoxDecoration CustomBoxDecoration(BuildContext context, Color departmentThemeBegin) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF28A8AF).withOpacity(0.35),
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 3),
      ),
    ],
    gradient: LinearGradient(
      begin: Alignment.topRight, // بداية التدرج من أعلى اليسار
      end: Alignment.bottomLeft, // نهاية التدرج إلى أسفل اليمين
      colors: [
        departmentThemeBegin, // لون البداية
        Theme.of(context).cardColor, // لون النهاية
      ],
    ),
  );
}
