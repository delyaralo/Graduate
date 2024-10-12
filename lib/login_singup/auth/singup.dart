// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:graduate/login_singup/auth/token_manager.dart';
import 'package:graduate/screens/department.dart';
import '../../main.dart';
import '../../splashScreen/customLoadingIndicator.dart';
import '../shortcut/CustomTextFormFieldStudentName.dart';
import '../shortcut/Customtextformfieldpassword.dart';
import '../shortcut/custombotton.dart';
import '../shortcut/customtextformfieldphone.dart';
import '../shortcut/customtextformfielduser.dart';
import '../shortcut/logo.dart';
import '../shortcut/textformfield.dart';
import 'package:http/http.dart' as http;

import 'Confirmation_page.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _Signup createState() => _Signup();
}

class _Signup extends State<Signup> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? selectedInstitute; // Nullable string for selectedInstitute
  TextEditingController Email = TextEditingController();
  TextEditingController Phone_number = TextEditingController();
  TextEditingController User_Name = TextEditingController();
  TextEditingController passward = TextEditingController();
  TextEditingController confirmpassward = TextEditingController();
  TextEditingController studentName = TextEditingController();
  late bool isloaded = false;
  String errorMessage = "";

  @override
  late List<dynamic> department;

  @override
  void initState() {
    super.initState();
    _loadDepartmentInfo();
  }

  Future<void> _loadDepartmentInfo() async {
    try {
      final DepartmentInfo = await getDepartment();

      if (DepartmentInfo.isNotEmpty) {
        if (mounted) {
          setState(() {
            department = DepartmentInfo;

            // إضافة معهد باسم "غير ذلك" في النهاية
            department.add({
              'id': "null",  // يمكنك تحديد معرف خاص للمعهد الجديد
              'name': 'غير ذلك'
            });
            isloaded = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isloaded = true;
          });
        }
        print("No data found");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isloaded = true;
        });
      }
      print("Error fetching department data: $e");
    }
  }


  bool hasDuplicates(List<dynamic> list, String key) {
    var seen = <String>{};
    return list.any((item) => !seen.add(item[key]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloaded
          ? Form(
        key: _formkey,
        child: Container(
          color: mainDarkTheme,
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                  ),
                  Logo(),
                  Container(
                    height: 20,
                  ),
                  Text(
                    "انشاء حساب",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: mainwhitetheme),
                  ),
                  Container(
                    height: 20,
                  ),
                  Text(
                    "انشاء حساب للاستمرار باستخدام التطبيق",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(
                    height: 20,
                  ),
                  Text(
                    "البريد",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: mainwhitetheme),
                  ),
                  Container(
                    height: 10,
                  ),
                  CustomTextFormField(
                      hinttext: "ادخل بريدك هنا",
                      mycontroller: Email,
                      check: false,
                      number: false,
                      isvalidator: true),
                  Container(
                    height: 10,
                  ),
                  Text(
                    "اسم المستخدم",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: mainwhitetheme),
                  ),
                  Container(
                    height: 10,
                  ),
                  CustomTextFormFieldUser(
                      hinttext: "ادخل اسم المستخدم هنا",
                      mycontroler: User_Name,
                      check: false,
                      number: false,
                      isvalidator: true),
                  Container(
                    height: 10,
                  ),
                  Text(
                    "أسم الطالب الثلاثي",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: mainwhitetheme),
                  ),
                  Container(
                    height: 10,
                  ),
                  CustomTextFormFieldSdudentName(
                      hinttext: "ادخل اسمك الثلاثي هنا باللغة العربية",
                      mycontroler: studentName,
                      check: false,
                      number: false,
                      isvalidator: true),
                  Container(
                    height: 10,
                  ),
                  Text(
                    "رقم الهاتف",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: mainwhitetheme),
                  ),
                  Container(
                    height: 10,
                  ),
                  CustomTextFormFieldPhone(
                      hinttext: "ادخل رقم الهاتف هنا",
                      mycontroler: Phone_number,
                      check: false,
                      number: true,
                      isvalidator: true),
                  Container(
                    height: 10,
                  ),
                  Text(
                    "كلمة السر",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: mainwhitetheme),
                  ),
                  Container(
                    height: 10,
                  ),
                  CustomTextFormFieldPassword(
                      hinttext: "ادخل كلمة السري هنا",
                      mycontroler: passward,
                      check: true,
                      number: false,
                      isvalidator: true),
                  Container(
                    height: 10,
                  ),
                  Text(
                    "اعادة كتابة كلمة السر",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: mainwhitetheme),
                  ),
                  Container(
                    height: 10,
                  ),
                  CustomTextFormFieldPassword(
                      hinttext: "ادخل كلمة السري هنا",
                      mycontroler: confirmpassward,
                      check: true,
                      number: false,
                      isvalidator: true),
                  Container(
                    height: 10,
                  ),
                  Text(
                    "المعهد",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: mainwhitetheme),
                  ),
                  Container(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade800,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    hint: Text("اختر المعهد",
                        style: TextStyle(color: mainwhitetheme)),
                    value: selectedInstitute, // Nullable handling
                    items: department.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['id'],
                        child: Text(
                          item['name'],
                          style: TextStyle(color: mainColors),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedInstitute = value;
                        print(
                            "Selected Institute: $selectedInstitute");
                        print(
                            "Number of departments: ${department.length}");
                      });
                    },
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text("لديك حساب بالفعل؟",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1,
                              wordSpacing: 2,
                              color: Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.bold)),
                      Container(
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 4),
                          child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "login");
                              },
                              child: Text("تسجيل الدخول",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 1,
                                      wordSpacing: 2,
                                      color: mainwhitetheme,
                                      fontWeight: FontWeight.bold)))),
                    ],
                  ),
                  custombutton(
                      onPressed: () async {
                        try {
                          if (passward.text != confirmpassward.text) {
                            showSnackbar(
                                context, "كلمة السر غير متطابقة");
                          } else {
                            if (_formkey.currentState!.validate()) {
                              await registerUser();
                            }
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      text: "انشاء حساب"),
                ],
              ),
            ],
          ),
        ),
      )
          : CustomLoadingIndicator(),
    );
  }

  Future<List<dynamic>> getDepartment() async {
    var url = Uri.https(
        "graduate-a29962909a04.herokuapp.com", "/api/Departments/Preview/list");
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        String contentType = response.headers['content-type'] ?? '';

        if (contentType.contains('application/json')) {
          final List<dynamic> departmentList = json.decode(response.body);
          print("Department data fetched successfully: ${response.body}");
          if (hasDuplicates(departmentList, 'id')) {
            print("Duplicate IDs found in department list");
          }
          return departmentList;
        } else if (contentType.contains('text/plain')) {
          print("Received plain text response: ${response.body}");
          return [];
        } else {
          print("Unexpected content type: $contentType");
          return [];
        }
      } else {
        print("Failed to fetch courses. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching department data: $e");
      return [];
    }
  }

  Future<void> registerUser() async {
    try {
      showDialog(
        context: context,
        builder: (context) => CustomLoadingIndicator(),
      );

      var url = Uri.https("graduate-a29962909a04.herokuapp.com", "/api/Auth/Register");

      // إذا كان `selectedInstitute` هو "غير ذلك"، نرسل null
      final Map<String, String?> data = {
        "email": Email.text,
        "password": passward.text,
        "confirmPassword": confirmpassward.text,
        "userName": User_Name.text,
        "phoneNumber": Phone_number.text,
        "fullName": studentName.text,
        "departmentId": selectedInstitute == "null" ? null : selectedInstitute, // إرسال null إذا اختير "غير ذلك"
      };

      final String jsonBody = jsonEncode(data);

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonBody,
      );

      Navigator.of(context).pop(); // Close the loading dialog

      if (response.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => ConfirmationPage(resend_massege: Email.text,)),
              (Route<dynamic> route) => false, // هذا المعامل يضمن إزالة جميع الصفحات السابقة
        );
        print("Registration successful");
      } else {
        if (response.headers['content-type'] == 'application/json; charset=utf-8') {
          final responseJson = json.decode(response.body);
          if (responseJson.containsKey("errors") && responseJson["errors"] is List) {
            final List<dynamic> errors = responseJson["errors"];
            for (var error in errors) {
              if (error == 'DuplicateEmail') {
                showSnackbar(context, "البريد موجود بالفعل يرجى تغير البريد");
              } else if (error == 'DuplicateUserName') {
                showSnackbar(context, 'اسم المستخدم موجود بالفعل يرجى تغيره');
              }
            }
          } else {
            showSnackbar(context, "Unknown error occurred");
          }
        } else {
          showSnackbar(context, "Server error occurred");
        }
      }
    } catch (e) {
      showSnackbar(context, "Error: $e");
    }
  }


  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 6),
      ),
    );
  }

  Future<void> showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'تأكيد البريد الإلكتروني',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 1,
              wordSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'يرجى التحقق من بريدك الإلكتروني لتأكيد الحساب.',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 1,
              wordSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'حسنًا',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 1,
                  wordSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Login()),
                        (route) => false); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
