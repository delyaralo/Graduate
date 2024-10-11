import 'package:flutter/material.dart';
import 'package:graduate/main.dart';

class CustomTextFormFieldPassword extends StatelessWidget {
  final bool number;
  final bool check;
  final bool isvalidator;
  final String hinttext;
  final TextEditingController mycontroler;

  const CustomTextFormFieldPassword({
    super.key,
    required this.hinttext,
    required this.mycontroler,
    required this.check,
    required this.number,
    required this.isvalidator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: mainwhitetheme),
      autovalidateMode: isvalidator ? AutovalidateMode.onUserInteraction : null,
      validator: isvalidator
          ? (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى ادخال كلمة السر';
        } else if (value.length < 6 || value.length > 50) {
          return 'يجب أن تحتوي كلمة السر على 6 إلى 50 حرفًا';
        } else if (!containsLetter(value)) {
          return 'كلمة السر يجب أن تحتوي على حرف واحد على الأقل';
        } else if (!containsDigit(value)) {
          return 'كلمة السر يجب أن تحتوي على رقم';
        } else {
          return null;
        }
      }
          : null,
      obscureText: check,
      controller: mycontroler,
      keyboardType: number == true ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
          focusColor: mainwhitetheme,
          hintText: hinttext,
          hintStyle: TextStyle(fontSize: 16, color: mainwhitetheme),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          filled: true,
          fillColor: mainDarkgray,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: mainwhitetheme),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainwhitetheme),
            borderRadius: BorderRadius.circular(50),
          )),
    );
  }

  // التحقق من وجود حرف واحد على الأقل سواء كان صغيرًا أو كبيرًا
  bool containsLetter(String value) {
    return value.contains(RegExp(r'[A-Za-z]'));
  }
  // التحقق من وجود رقم
  bool containsDigit(String value) {
    return value.contains(RegExp(r'[0-9]'));
  }
}
