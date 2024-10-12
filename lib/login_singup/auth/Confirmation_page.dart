import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduate/main.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // لإطلاق الروابط

class ConfirmationPage extends StatefulWidget {
  final String resend_massege;
  ConfirmationPage({super.key, required this.resend_massege});

  @override
  _ConfirmationPage createState() => _ConfirmationPage();
}

class _ConfirmationPage extends State<ConfirmationPage> {
  bool _isButtonEnabled1 = false;
  bool _isButtonEnabled2 = false;
  int _seconds = 60;
  Timer? _timer;
  bool _isLoading = false;
  int _resendCount = 0; // تتبع عدد مرات الضغط على الزر

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _activateFirstButton();
  }

  void _activateFirstButton() {
    Timer(Duration(seconds: 12), () {
      setState(() {
        _isButtonEnabled1 = true;
      });
    });
  }

  void _startCountdown() {
    setState(() {
      _isButtonEnabled2 = false;
      _seconds = 60;
      _isLoading = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds--;
        if (_seconds == 0) {
          _isButtonEnabled2 = true;
          _isLoading = false;
          _timer?.cancel();
        }
      });
    });
  }

  // فتح رابط واتساب
  void _launchWhatsApp() async {
    final whatsappUrl = "https://wa.me/+9647748687725?text=أنا أواجه مشكلة في تلقي رسالة تأكيد البريد الإلكتروني."; // ضع رقم الواتساب هنا
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      showSnackbar(context, "لا يمكن فتح واتساب");
    }
  }

  @override
  Widget build(BuildContext context) {
    // استخدام MediaQuery للحصول على أبعاد الشاشة
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('تأكيد البريد الإلكتروني'),
      ),
      body: Container(
        color: mainDarkTheme,
        padding: EdgeInsets.all(screenWidth * 0.05), // الهوامش تعتمد على العرض
        child: ListView(
          children: [
            Text(
              'تم إرسال رسالة تأكيد البريد الإلكتروني إلى بريدك على الجيميل.',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.05, // حجم النص يعتمد على عرض الشاشة
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'الرجاء التحقق من بريدك الإلكتروني والنقر على رابط التأكيد.',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.045, // حجم النص يعتمد على عرض الشاشة
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'بعد تأكيد البريد، اضغط على الزر أدناه.',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.045,
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              onPressed: _isButtonEnabled1
                  ? () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Login()),
                      (Route<dynamic> route) => false,
                );
              }
                  : null,
              child: Text(
                'قمت بتأكيد البريد',
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            ElevatedButton(
              onPressed: _isButtonEnabled2
                  ? () {
                _resendCount++; // زيادة العداد
                if (_resendCount >= 2) {
                  _showSupportMessage();
                }
                ResendCodeConfirmation();
                _startCountdown();
              }
                  : null,
              child: Text(
                'اضغط لإرسالها مرة أخرى بعد انتهاء العداد',
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // زر الدعم الجديد
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: 0.0),
              duration: Duration(seconds: 60),
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: value,
                      strokeWidth: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    Text(
                      '${_seconds}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton.icon(
              onPressed: _showSupportMessage, // عند الضغط تظهر نفس الرسالة
              icon: SvgPicture.asset(
                'images/whatsapp.svg',
                height: screenWidth * 0.08,
                width: screenWidth * 0.08,
                color: Colors.white,
              ),
              label: Text(
                'الدعم الفني',
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColors, // لون خلفية الزر
              ),
            ),
          ],
        ),
      ),
    );
  }

  // إظهار رسالة دعم للمستخدم مع رابط الواتساب
  void _showSupportMessage() {
    // استخدام MediaQuery داخل Dialog
    double screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('هل تواجه مشكلة؟', style: TextStyle(fontSize: screenWidth * 0.045)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'إذا لم تتلق رسالة التأكيد، يرجى التواصل مع الدعم عبر الواتساب.',
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _launchWhatsApp,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'images/whatsapp.svg', // مسار ملف SVG
                      height: screenWidth * 0.08, // ضبط ارتفاع الأيقونة بشكل ديناميكي
                      width: screenWidth * 0.08, // ضبط عرض الأيقونة بشكل ديناميكي
                      color: mainColors,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'اضغط هنا للتواصل مع الدعم',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: screenWidth * 0.035, // حجم النص يعتمد على عرض الشاشة
                        decoration: TextDecoration.underline, // إضافة خط أسفل النص
                        decorationThickness: screenWidth * 0.002, // سماكة الخط تتغير مع الشاشة
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إغلاق', style: TextStyle(fontSize: screenWidth * 0.04)), // حجم النص يعتمد على العرض
            ),
          ],
        );
      },
    );
  }

  void ResendCodeConfirmation() async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    var url = Uri.https(URL, "/api/Auth/ResendConfirmationEmail");
    Map<String, String> data = {
      "email": widget.resend_massege,
    };
    String jsonBody = jsonEncode(data);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    var response = await http.post(
      url,
      headers: headers,
      body: jsonBody,
    );
    if (response.statusCode == 200) {
      showSnackbar(context, "تم ارسال رسالة التأكيد الى بريدك");
    } else {
      final responseJson = json.decode(response.body);
      List<dynamic> Errors = responseJson['errors'];
      for (var error in Errors) {
        if (error == 'USER_NOT_FOUND') {
          showSnackbar(context, "المستخدم غير موجود");
        } else if (error == 'UNEXPECTED_ERROR')
          showSnackbar(context, "حدث خطأ غير معروف");
      }
      Navigator.of(context).pop();
    }
  }
  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
