import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduate/main.dart';
import 'package:provider/provider.dart'; // استيراد Provider
import 'package:url_launcher/url_launcher.dart';
import '../login_singup/auth/token_manager.dart';
import '../themee/theme_notifier.dart'; // استيراد ThemeNotifier
import '../login_singup/auth/login.dart';
import '../login_singup/shortcut/customappbar.dart';
import '../login_singup/shortcut/custombotton.dart';
import '../splashScreen/customLoadingIndicator.dart';

class Profile extends StatefulWidget {
  final String appBarTitle;

  const Profile({super.key, required this.appBarTitle});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Map Userinfo;
  late bool isloaded = false;

  @override
  void initState() {
    super.initState();
    _loadTeacherInfo();
  }

  Future<void> _loadTeacherInfo() async {
    final teacherInfo = await getUserInfo();
    if (teacherInfo!.isNotEmpty) {
      setState(() {
        Userinfo = teacherInfo!;
        isloaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Future<void> _launchInstagram(String link) async {
      final Uri url = Uri.parse(link); // استبدال yourpage بصفحتك
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication); // فتح الرابط باستخدام LaunchMode
      } else {
        throw 'Could not launch $url';
      }
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.appBarTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            'images/instagram.svg',
            width: MediaQuery.of(context).size.width * 0.09,
            height: MediaQuery.of(context).size.width * 0.09,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            _launchInstagram('https://www.instagram.com/g_raduate/');
          },
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'images/telegram.svg',
              width: MediaQuery.of(context).size.width * 0.09,
              height: MediaQuery.of(context).size.width * 0.09,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              _launchInstagram('https://t.me/g_raduate');
            },
          ),
        ],
      ),
      body: isloaded
          ? ListView(
        padding: const EdgeInsets.all(16),
        physics: BouncingScrollPhysics(),
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF28A8AF).withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: ClipOval(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Image.asset("images/user_def_photo.png", fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          buildProfileTile(
            icon: Icons.email,
            title: "Email",
            value: Userinfo['email'],
          ),
          const SizedBox(height: 15),
          buildProfileTile(
            icon: Icons.person,
            title: "Full Name",
            value: Userinfo['fullName'],
            showEditButton: true,
            onEdit: () => _showUpdateNameDialog(context),
          ),
          const SizedBox(height: 15),
          buildProfileTile(
            icon: Icons.phone,
            title: "Phone Number",
            value: Userinfo['phoneNumber'],
          ),
          const SizedBox(height: 20),
          custombutton(
            onPressed: () async {
              try {
                logout();
              } catch (e) {}
            },
            text: "تسجيل الخروج",
            color: Color(0xFF32DDE6),//
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 10, right: 20),
            child: Row(
              textDirection: TextDirection.rtl, // يجعل العناصر تبدأ من اليمين إلى اليسار
              children: [
                Text(
                  "هل تريد حذف الحساب ؟",
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 1,
                    wordSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Container(
                  child: InkWell(
                    onTap: () {
                      _showDeleteAccountDialog(context);
                    },
                    child: Text(
                      "حذف الحساب",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 1,
                        wordSpacing: 2,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.support_agent),
                  color: Theme.of(context).primaryColor,
                  iconSize: MediaQuery.of(context).size.width * 0.1,
                  onPressed: () {
                    // عرض حوار عند الضغط على الأيقونة
                    Support(context);
                  },
                ),
                SizedBox(width: 8), // مسافة صغيرة بين الأيقونة والنص
                Text(
                  "الدعم",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: MediaQuery.of(context).size.width * 0.05, // حجم النص يتناسب مع عرض الشاشة
                  ),
                ),
              ],
            ),
          )
        ],
      )
          : CustomLoadingIndicator(),
    );
  }

  Widget buildProfileTile({
    required IconData icon,
    required String title,
    required String value,
    bool showEditButton = false,
    VoidCallback? onEdit,
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
        leading: Icon(icon, size: 24, color: Color(0xFF247D95)),
        title: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
        subtitle: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color:Theme.of(context).primaryColor)),
        trailing: showEditButton
            ? IconButton(
          icon: Icon(Icons.edit, color:Theme.of(context).primaryColor),
          onPressed: onEdit,
        )
            : null,
      ),
    );
  }
  void Support(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text("تواصل مع الدعم"),
            content: Text("يرجى اختيار نوع المشكلة للتواصل مع الدعم:"),
            actions: <Widget>[
              TextButton(
                child: Text("مشكلة في التطبيق"),
                onPressed: () {
                  Navigator.of(context).pop(); // إغلاق الحوار
                  _showContactInfo(context, " تواصل مع الفريق المختص عبر Telegram مع ارسال مشكلة التطبيق : " + "@g_raduate");
                },
              ),
              TextButton(
                child: Text("مشكلة مع المعهد"),
                onPressed: () {
                  Navigator.of(context).pop(); // إغلاق الحوار
                  _showContactInfo(context, " تواصل مع الفريق المختص عبر Telegram مع ارسال اسم المعهد والمشكلة : " + "@g_raduate");
                },
              ),
              TextButton(
                child: Text("مشكلة مع أستاذ معين"),
                onPressed: () {
                  Navigator.of(context).pop(); // إغلاق الحوار
                  _showContactInfo(context, " تواصل مع الفريق المختص عبر Telegram مع ارسال اسم الاستاذ والمشكلة : " + "@g_raduate");
                },
              ),
              TextButton(
                child: Text("مشكلة أخرى"),
                onPressed: () {
                  Navigator.of(context).pop(); // إغلاق الحوار
                  _showContactInfo(context, " تواصل مع الفريق المختص عبر Telegram مع ارسال مشكلة بالتفصيل : " + "@g_raduate");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showContactInfo(BuildContext context, String contactInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text("معلومات التواصل"),
            content: Text(contactInfo),
            actions: <Widget>[
              TextButton(
                child: Text("حسناً"),
                onPressed: () {
                  Navigator.of(context).pop(); // إغلاق الحوار
                },
              ),
            ],
          ),
        );
      },
    );
  }
  Future<Map?> getUserInfo() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/Auth/UserInfo");
      if (response!.statusCode == 200) {
        final Map UserInfo = json.decode(response.body);
        print(response.body);
        return UserInfo;
      } else {
        print("Failed to fetch courses. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching courses: $e");
      return null;
    }
  }

  Future<void> logout() async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    await secure_storage.delete(key: 'token');
    await secure_storage.delete(key: 'refreshToken');
    await secure_storage.delete(key: 'refreshTokenExpiration');
    await secure_storage.delete(key: 'sessionId');
    Navigator.of(context).pop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('حذف الحساب'),
          content: Text('هل انت متاكد من حذف حسابك'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('لا'),
            ),
            TextButton(
              onPressed: () async {
                bool? isDeleted = await ApiClient().deletAccount(context);
                if (isDeleted != null) {
                  if (isDeleted) {
                    logout();
                  }
                }
              },
              child: Text('نعم'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateNameDialog(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    _nameController.text = Userinfo['fullName'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تحديث الاسم'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'بعد تحديث الاسم سيتم تسجيل الخروج تلقائي',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                await updateName(_nameController.text);
                Navigator.of(context).pop();
              },
              child: Text('تحديث'),
            ),
          ],
        );
      },
    );
  }
  Future<void> updateName(String newName) async {
    bool? isupdated = await ApiClient().putinfo(context, newName);
    if (isupdated != null) {
      if (isupdated) {
        setState(() {
          Userinfo['fullName'] = newName;
        });
        logout();
      }
    }
  }
}
