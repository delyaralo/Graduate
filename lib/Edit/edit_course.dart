// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../login_singup/shortcut/costumtextformfieldaddteacher.dart';
import '../login_singup/shortcut/customappbar.dart';
import '../login_singup/shortcut/custombotton.dart';
class EditCourse extends StatefulWidget
{


  EditCourse({super.key});

  @override
  State<EditCourse> createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();

  TextEditingController courseName =TextEditingController();

  TextEditingController Description =TextEditingController();

  TextEditingController imageCourse =TextEditingController();

  TextEditingController CoursePrice =TextEditingController();
  String errorMessage = "";
  late File CourseImage;

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
                              "Edit Course",
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
                  Center(child: const Text("اسم الكورس",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                  Container(height: 10,),
                  CustomTextFormFieldAddTeacher(hinttext: "ادخل هنا الاسم",mycontroler:courseName ,check: false, number: false,isvalidator: true),
                  Container(height: 10,),
                  Center(child: const Text("الوصف",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                  Container(height: 10,),
                  CustomTextFormFieldAddTeacher(hinttext: "ادخل هنا الوصف",mycontroler:Description ,check: false, number: false,isvalidator: true),
                  Container(height: 10,),
                  Center(child: const Text("السعر",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                  Container(height: 10,),
                  CustomTextFormFieldAddTeacher(hinttext: "ادخل هنا السعر",mycontroler:CoursePrice ,check: false, number:true,isvalidator: true),
                  Container(height: 10,),
                  Center(child: const Text("صورة الكورس",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                  Container(height: 10,),
                  Center(
                    child: IconButton(onPressed:add_photo, icon:Icon(Icons.add_photo_alternate_outlined,color: Colors.indigoAccent[400],size: 50,)),
                  ),
                  Container(height: 10,),
                  custombutton(onPressed: () async{
                    try {
                      if(_formkey.currentState!.validate()) {
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      print(e);
                    }
                  },text:"حفظ التعديل"),
                ],
              ),
            ],

          ),
        ),
      ),
    );
  }

  Future add_photo() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      CourseImage = File(image!.path);
    });
  }
}
