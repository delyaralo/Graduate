import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyCourse extends StatelessWidget {
  final String price;
  final String title;
  final String contact;
  final bool showPrice;
  final String image;

  BuyCourse({
    super.key,
    required this.price,
    required this.title,
    required this.contact,
    required this.showPrice,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    // الحصول على أبعاد الشاشة

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // عزل معلومات التواصل بناءً على "-"
    final contactParts = contact.split('-');
    final whatsappNumber = contactParts.isNotEmpty ? contactParts[0] : '';
    final telegramUser = contactParts.length > 1 ? contactParts[1] : '';
    final instagramUser = contactParts.length > 2 ? contactParts[2] : '';

    // بناء التايل المخصص
    Widget buildContactTile({
      required IconData icon,
      required String title,
      required String value,
      required String url, // URL المطلوب فتحه عند النقر
      bool isSvg = false,
      String? svgAsset,
    }) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF28A8AF).withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: isSvg && svgAsset != null
              ? SvgPicture.asset(
            svgAsset,
            width: 24,
            height: 24,
            color: Theme.of(context).primaryColor,
          )
              : Icon(icon, size: 24, color: Theme.of(context).primaryColor),
          title: Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          subtitle: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onTap: () async {
            final Uri uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              // Handle error if URL can't be launched
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not open $title')),
              );
            }
          },
        ),
      );
    }
    String formatWhatsAppNumber(String number) {
      // إذا كان الرقم لا يبدأ برمز الدولة (+964 مثلاً)
      if (!number.startsWith('964')) {
        // يمكنك هنا تعديل رمز الدولة حسب احتياجاتك (هنا رمز العراق +964)
        return '964' + number.replaceFirst(RegExp(r'^0+'), ''); // إزالة أي أصفار من بداية الرقم المحلي
      }
      return number;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: screenWidth * 0.05, // حجم الخط يعتمد على عرض الشاشة
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.05,
        ),
        child: ListView(
          children: [
            // مساحة لصورة الدورة التدريبية
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            // عرض السعر إن وُجد
            if (showPrice)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF28A8AF).withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                child: Card(
                  color: Colors.transparent, // لجعل لون الكارد شفافًا لتفعيل الـ BoxDecoration
                  elevation: 0, // إلغاء الارتفاع الافتراضي للـ Card لأننا استخدمنا BoxShadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.01),
                    child: Column(
                      children: [
                        Text(
                          price + " IQD : السعر",
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: screenHeight * 0.005),
            // نص للتواصل عبر الواتساب
            Text(
              ": للمزيد من المعلومات أو الشراء يرجى التواصل عبر ",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: screenHeight * 0.02),

            // عرض معلومات الواتساب
            if (whatsappNumber.isNotEmpty)
              buildContactTile(
                icon: Icons.call,
                title: "WhatsApp",
                value: whatsappNumber,
                url: 'https://wa.me/${formatWhatsAppNumber(whatsappNumber)}', // صيغة الرقم المعدلة
                isSvg: true,
                svgAsset: 'images/whatsapp.svg',
              ),

            SizedBox(height: screenHeight * 0.02),

            // عرض معلومات التليجرام
            if (telegramUser.isNotEmpty)
              buildContactTile(
                icon: Icons.telegram,
                title: "Telegram",
                value: "@$telegramUser",
                url: 'https://t.me/$telegramUser',
              ),

            SizedBox(height: screenHeight * 0.02),

            // عرض معلومات الانستغرام
            if (instagramUser.isNotEmpty)
              buildContactTile(
                icon: Icons.camera,
                title: "Instagram",
                value: "@$instagramUser",
                url: 'https://instagram.com/$instagramUser',
                isSvg: true,
                svgAsset: 'images/instagram.svg',
              ),

            SizedBox(height: screenHeight * 0.03),

            // زر العودة إلى الصفحة الرئيسية أو إتمام عملية الشراء
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF28A8AF).withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Row(
                          children: [
                            Icon(
                              Icons.contact_support,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "التواصل للشراء",
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(color: Theme.of(context).dividerColor),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              "للشراء، يرجى التواصل معنا عبر الواتساب أو وسائل التواصل الاجتماعي الأخرى المتاحة للحصول على مزيد من التفاصيل.",
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Theme.of(context).textTheme.bodySmall?.color,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                          ],
                        ),
                        actions: [
                          Center(
                            child: TextButton(
                              child: Text(
                                "إغلاق",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.shopping_cart,color: Theme.of(context).primaryColor,),
                label: Text(
                  showPrice ? "اشترِ الآن" : "العودة إلى الصفحة الرئيسية",
                  style: TextStyle(fontSize: screenWidth * 0.045,color: Theme.of(context).primaryColor),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
