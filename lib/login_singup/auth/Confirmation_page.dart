import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graduate/main.dart';
import 'login.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({super.key});

  @override
  _ConfirmationPage createState() => _ConfirmationPage();
}

class _ConfirmationPage extends State<ConfirmationPage> {
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    // تشغيل المؤقت لمدة 10 ثوانٍ
    Timer(Duration(seconds: 12), () {
      setState(() {
        _isButtonEnabled = true; // تفعيل الزر بعد 10 ثوانٍ
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تأكيد البريد الإلكتروني'),
      ),
      body: Form(
        child: Container(
          color: mainDarkTheme,
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                'تم إرسال رسالة تأكيد البريد الإلكتروني إلى بريدك على الجيميل.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'الرجاء التحقق من بريدك الإلكتروني والنقر على رابط التأكيد.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'بعد تأكيد البريد، اضغط على الزر أدناه.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Login()),
                        (Route<dynamic> route) => false, // هذا المعامل يضمن إزالة جميع الصفحات السابقة
                  );
                }
                    : null, // الزر يكون غير مفعل إذا لم تمر 10 ثوانٍ
                child: Text('قمت بتأكيد البريد'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
