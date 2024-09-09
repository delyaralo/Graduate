// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../main.dart';
import '../shortcut/custombotton.dart';
import '../shortcut/logo.dart';
import '../shortcut/textformfield.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
class ForgetPassword extends StatefulWidget
{
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController Forget_Password=TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: mainDarkTheme,
        child: ListView(
          children: [
            Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: MediaQuery.of(context).size.height/5,),
                Logo(),
                Container(height: 20,),
                Text("نسيت كلمة السر",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color:mainwhitetheme),),
                Container(height: 10,),
                Text("البريد",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color:mainwhitetheme),),
                Container(height: 10,),
                CustomTextFormField(hinttext: "ادخل الحساب هنا",mycontroller:Forget_Password ,check: false, number: false,isvalidator: true),
                Container(height: 10,),
                custombutton(onPressed: () async {
                  try {
                    ForgetPasswordAuth();
                  }  catch (e) {
                  }
                }
                    , text: "ارسال رسالة تاكيد للبريد"),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(' البريد الإلكتروني',style:TextStyle(fontSize: 14 ,letterSpacing: 1,wordSpacing: 2,fontWeight: FontWeight.bold,),textAlign:TextAlign.center),
          content: const Text('يرجى التحقق من بريدك لاعادة تعين كلمة السر',style:TextStyle(fontSize: 14 ,letterSpacing: 1,wordSpacing: 2,fontWeight: FontWeight.bold),textAlign:TextAlign.center),
          actions: <Widget>[
            TextButton(
              child: const Text('حسنًا',style:TextStyle(fontSize: 14 ,letterSpacing: 1,wordSpacing: 2,fontWeight: FontWeight.bold),textAlign:TextAlign.center),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),), (route) => false);// Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
  void ForgetPasswordAuth() async {

    showDialog(context: context, builder: (context) =>
        const Center(child: CircularProgressIndicator())
    );
    var url = Uri.https(URL,"/api/Auth/ForgotPassword");
    // Create a map with the email and password data
    Map<String, String> data = {
      "email": Forget_Password.text,
    };
    // Encode the data as JSON
    String jsonBody = jsonEncode(data);
    // Set the headers for the request
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    // Make the POST request
    var response = await http.post(
      url,
      headers: headers,
      body: jsonBody,
    );

    // Check the response
    if (response.statusCode == 200)
      {
        showConfirmationDialog();

      }
      else
        {
          final responseJson = json.decode(response.body);
          List<dynamic> Errors=responseJson['errors'];
          for (var error in Errors) {
            if(error=='USER_NOT_FOUND') {
              showSnackbar(context, "المستخدم غير موجود");
            } else if(error=='EMAIL_NOT_CONFIRMED')
              showSnackbar(context, "البريد ألكتروني لم يتم توثيقة");
            else if(error=='UNEXPECTED_ERROR')
              showSnackbar(context, "حدث خطا غير معروف");
          }
          Navigator.of(context).pop();
        }
    }
  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3), // Adjust the duration as needed
      ),
    );
  }
}
