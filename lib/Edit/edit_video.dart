// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names
import 'package:flutter/material.dart';
import '../login_singup/shortcut/customappbar.dart';
import '../login_singup/shortcut/custombotton.dart';
import '../login_singup/shortcut/customtextformfieldaddvideo.dart';
class EditVideo extends StatelessWidget
{

  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();

  TextEditingController VideoName =TextEditingController();

  TextEditingController VideoUrl =TextEditingController();


  String errorMessage = "";
  @override
  Widget build (BuildContext context)
  {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Container(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 20,),
                  Container(
                    padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent[400],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomAppBar(),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 3, bottom: 15),
                          child: Center(
                            child: Text(
                              "Edit Video",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                wordSpacing: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 10,),
                  Center(child: const Text("رابط الفديو",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                  Container(height: 10,),
                  CustomTextFormFieldAddVideo(hinttext: "ادخل هنا الرابط",mycontroler:VideoUrl ,check: false, number: false,isvalidator: true),
                  Container(height: 10,),
                  custombutton(onPressed: () async{
                    try {
                      if(_formkey.currentState!.validate()) {
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      print(e);
                    }
                  },text:"اضف الفديو"),
                ],
              ),
            ],

          ),
        ),
      ),
    );
  }
}
