import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:graduate/login_singup/shortcut/customappbar.dart';
import '../login_singup/auth/token_manager.dart';
import '../login_singup/shortcut/custombotton.dart';
import '../main.dart';
import 'appBar.dart';

class Profile extends StatefulWidget {
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
    return Container(
      child: ListView(
        physics:BouncingScrollPhysics(),
        children: [
          Column(
            children: [
              Column(
                children: [
                  CustomAppBarWidget(
                    text: "Profile",
                  ),
                  const SizedBox(height: 40,),
                  isloaded ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.only(right: 4),
                            height: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200]
                            ),
                            child: ClipOval(
                              child: Image.asset("images/hussein.jpg"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        const Text("Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                        Container(height: 5,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[100],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: ListTile(
                            leading: const Icon(Icons.email, size: 23,),
                            title: Text(Userinfo['email'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        const Text("Full Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        Container(height: 5,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[100],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: ListTile(
                            leading: const Icon(Icons.person, size: 23,),
                            title: Row(
                              children: [
                                Text(Userinfo['fullName'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                                IconButton(
                                  icon: Icon(Icons.edit,color: mainColors,),
                                  onPressed: () {
                                    _showUpdateNameDialog(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        const Text("Phone Number", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                        Container(height: 5,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[100],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: ListTile(
                            leading: const Icon(Icons.phone, size: 23,),
                            title: Text(Userinfo['phoneNumber'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        custombutton(
                          onPressed: () async {
                            try {
                              logout();
                            } catch (e) {}
                          },
                          text: "تسجيل الخروج",
                        ),
                        custombutton(
                          onPressed: () {
                            _showDeleteAccountDialog(context);
                          },
                          text: "حذف الحساب",
                        ),
                      ],
                    ),
                  ) : Center(child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height / 6,),
                        const CircularProgressIndicator()
                      ])),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Map?> getUserInfo() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/Auth/UserInfo");
      if (response!.statusCode == 200) {
        final Map UserInfo = json.decode(response.body);
        print(response.body);
        return UserInfo;
      } else { // Handle the case where the request was not successful
        print("Failed to fetch courses. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print("Error fetching courses: $e");
      return null;
    }
  }

  Future<void> logout() async {
    // Delete the token
    showDialog(context: context, builder: (context) =>
    const Center(child: CircularProgressIndicator(),),);
    await secure_storage.delete(key: 'token');
    await secure_storage.delete(key: 'refreshToken');
    await secure_storage.delete(key: 'refreshTokenExpiration');
    await secure_storage.delete(key: 'sessionId');
    // Navigate the user to the login screen
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
                // Handle "No" action here
                Navigator.of(context).pop();
              },
              child: Text('لا'),
            ),
            TextButton(
              onPressed: () async {
                // Handle "Yes" action here
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
