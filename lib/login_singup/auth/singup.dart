// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import '../../main.dart';
import '../shortcut/CustomTextFormFieldStudentName.dart';
import '../shortcut/Customtextformfieldpassword.dart';
import '../shortcut/custombotton.dart';
import '../shortcut/customtextformfieldphone.dart';
import '../shortcut/customtextformfielduser.dart';
import '../shortcut/logo.dart';
import '../shortcut/textformfield.dart';
import 'package:http/http.dart' as http;
class Signup extends StatefulWidget
{
  const Signup({super.key});
  @override
  _Signup createState() =>_Signup();
}
class _Signup extends State<Signup>
{
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  TextEditingController Email =TextEditingController();
  TextEditingController Phone_number =TextEditingController();
  TextEditingController User_Name =TextEditingController();
  TextEditingController passward =TextEditingController();
  TextEditingController confirmpassward =TextEditingController();
  TextEditingController studentName =TextEditingController();
  String errorMessage = "";
  @override
  Widget build (BuildContext context)
  {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Container(
          color: mainDarkTheme,
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 20,),
                  Logo(),
                  Container(height: 20,),
                  Text("انشاء حساب",style: TextStyle(fontWeight: FontWeight.bold,fontSize:30,color: mainwhitetheme ),),
                  Container(height: 20,),
                  Text("انشاء حساب للاستمرار باستخدام التطبيق",style: TextStyle(color:Colors.grey),),
                  Container(height: 20,),
                  Text("البريد",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: mainwhitetheme),),
                  Container(height: 10,),
                  CustomTextFormField(hinttext: "ادخل بريدك هنا",mycontroler:Email ,check: false, number: false,isvalidator: true),
                  Container(height: 10,),
                  Text("اسم المستخدم",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: mainwhitetheme),),
                  Container(height: 10,),
                  CustomTextFormFieldUser(hinttext: "ادخل اسم المستخدم هنا",mycontroler:User_Name ,check: false, number: false,isvalidator: true),
                  Container(height: 10,),
                  Text("أسم الطالب الثلاثي",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: mainwhitetheme),),
                  Container(height: 10,),
                  CustomTextFormFieldSdudentName(hinttext: "ادخل اسمك الثلاثي هنا باللغة العربية",mycontroler:studentName ,check: false, number: false,isvalidator: true),
                  Container(height: 10,),
                  Text("رقم الهاتف",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: mainwhitetheme),),
                  Container(height: 10,),
                  CustomTextFormFieldPhone(hinttext: "ادخل رقم الهاتف هنا",mycontroler:Phone_number,check: false, number: true,isvalidator: true),
                  Container(height: 10,),
                  Text("الرمز السري",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: mainwhitetheme),),
                  Container(height: 10,),
                  CustomTextFormFieldPassword(hinttext: "ادخل الرمز السري هنا",mycontroler:passward,check: true, number: false,isvalidator: true),
                  Container(height: 10,),
                  Text("اعادة كتابة كلمة السر",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: mainwhitetheme),),
                  Container(height: 10,),
                  CustomTextFormFieldPassword(hinttext: "ادخل الرمز السري هنا",mycontroler:confirmpassward,check: true, number: false,isvalidator: true),

                  Row(
                    children: [
                      Text("لديك حساب بالفعل ؟",style: TextStyle(fontSize: 14 ,letterSpacing: 1,wordSpacing: 2,color: Colors.white.withOpacity(0.6),fontWeight: FontWeight.bold)),
                      Container(
                          margin: const EdgeInsets.only(top: 10,bottom: 10,left:4),
                          child: InkWell(
                              onTap: (){
                                Navigator.pushNamed(context,"login");
                              },
                              child: Text("تسجيل الدخول",style: TextStyle(fontSize: 14 ,letterSpacing: 1,wordSpacing: 2,color: mainwhitetheme,fontWeight: FontWeight.bold)))),
                    ],
                  ),
                  custombutton(onPressed: () async{
                    try {
                      if (passward.text !=confirmpassward.text)
                        {
                          showSnackbar(context,"كلمة السر غير متطابقة");
                        }
                      else {
                      if(_formkey.currentState!.validate()) {
                        await registerUser();

                      }
                      }
                    } catch (e) {
                      print(e);
                    }
                  },text:"انشاء حساب"),
                ],
              ),
            ],

          ),
        ),
      ),
    );
  }
  Future<void> registerUser() async {
    try {
      showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      var url = Uri.https("graduate-a29962909a04.herokuapp.com", "/api/Auth/Register");

      final Map<String, String> data = {
        "email": Email.text,
        "password": passward.text,
        "confirmPassword": confirmpassward.text,
        "userName": User_Name.text,
        "phoneNumber": Phone_number.text,
        "fullName":studentName.text,
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
        // Registration successful
        showConfirmationDialog();
        print("Registration successful");
        // You can navigate to a new screen or show a success message here.
      } else {
        // Registration failed
        if (response.headers['content-type'] == 'application/json; charset=utf-8') {
          final responseJson = json.decode(response.body);
          if (responseJson.containsKey("errors") && responseJson["errors"] is List) {
            final List<dynamic> errors = responseJson["errors"];
            for (var error in errors) {
              if (error == 'DuplicateEmail') {
                showSnackbar(context, "البريد  موجود بالفعل يرجى تغير البريد");
              } else if (error == 'DuplicateUserName') {
                showSnackbar(context, 'اسم المستخدم موجود بالفعل يرجى تغيره');
              }
            }
          } else {
            // Handle other error cases
            showSnackbar(context, "Unknown error occurred");
          }
        } else {
          // Handle non-JSON responses (e.g., server error)
          showSnackbar(context, "Server error occurred");
        }
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      showSnackbar(context, "Error: $e");
    }
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 6), // Adjust the duration as needed
      ),
    );
}

  Future<void> showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد البريد الإلكتروني',style:TextStyle(fontSize: 14 ,letterSpacing: 1,wordSpacing: 2,fontWeight: FontWeight.bold,),textAlign:TextAlign.center),
          content: Text('يرجى التحقق من بريدك الإلكتروني لتأكيد الحساب.',style:TextStyle(fontSize: 14 ,letterSpacing: 1,wordSpacing: 2,fontWeight: FontWeight.bold),textAlign:TextAlign.center),
          actions: <Widget>[
            TextButton(
              child: Text('حسنًا',style:TextStyle(fontSize: 14 ,letterSpacing: 1,wordSpacing: 2,fontWeight: FontWeight.bold),textAlign:TextAlign.center),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>Login()), (route) => false);// Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
