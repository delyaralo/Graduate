import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduate/mulazim/pdfplayer.dart';
import '../login_singup/auth/token_manager.dart';
import '../main.dart';
import '../splashScreen/customLoadingIndicator.dart';

class MulazimSection extends StatefulWidget {
  final String CourseId;
  final String phone_number;
  final bool lock;

  const MulazimSection({
    super.key,
    required this.CourseId,
    required this.phone_number,
    required this.lock,
  });

  @override
  State<MulazimSection> createState() => _MulazimSectionState();
}

class _MulazimSectionState extends State<MulazimSection> {
  late bool isempty = false;
  late List<dynamic> mulazim;
  late bool isloaded = false;

  @override
  void initState() {
    super.initState();
    _loadmulazimInfo();
  }

  Future<void> _loadmulazimInfo() async {
    final mulazimInfo = await getMulazim(widget.CourseId);
    if (mulazimInfo.isNotEmpty) {
      setState(() {
        mulazim = mulazimInfo;
        isloaded = true;
        isempty = false; // تأكيد أن القائمة ليست فارغة
      });
    } else {
      setState(() {
        isloaded = true;
        isempty = true; // تعيين `isempty` إلى true إذا كانت القائمة فارغة
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isloaded
        ? Column(
      children: [
        if (!isempty) // إذا كانت القائمة ليست فارغة، عرض الملزمات
          ListView.separated(
            itemCount: mulazim.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final handout = mulazim[index];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: mainColors, // استخدم نفس اللون الرئيسي لتناسق التصميم
                    shape: BoxShape.circle,
                  ),
                  child: widget.lock
                      ? Icon(Icons.lock, color: mainwhitetheme, size: 30)
                      : Icon(Icons.picture_as_pdf, color: mainwhitetheme, size: 30), // أيقونة PDF
                ),
                title: Text(
                  handout['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ), // عنوان الملزمة
                onTap: widget.lock
                    ? null
                    : () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PdfPlayer(
                      url: handout['url'],
                      tital: handout['name'],
                      phone_number: widget.phone_number,
                    ),
                  ));
                },
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                height: 1, // سمك الخط الفاصل
                margin: EdgeInsets.symmetric(vertical: 10), // المسافة بين العناصر والخط
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff32DDE6), Color(0xff2D3479)], // ألوان التدرج
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              );
            },
          )
        else // إذا كانت القائمة فارغة، عرض رسالة
          Container(
            padding: EdgeInsets.all(16),
            child: const Center(
              child: Text(
                "لا توجد ملخصات حالياً",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    )
        : CustomLoadingIndicator();
  }

  Future<List<dynamic>> getMulazim(String CourseId) async {
    var response = await ApiClient().getAuthenticatedRequest(context, "api/CourseResources/$CourseId");
    if (response?.statusCode == 200) {
      final List<dynamic> mulazimList = json.decode(response!.body);
      mulazimList.sort((a, b) => a["order"].compareTo(b["order"]));
      print(response?.body);
      return mulazimList;
    } else {
      print("Failed to fetch courses. Status code: ${response?.statusCode}");
      setState(() {
        isempty = true;
      });
      return [];
    }
  }
}
