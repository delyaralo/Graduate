import 'package:flutter/material.dart';
import 'package:graduate/main.dart';


class CustomTextFormFieldUser extends StatelessWidget
{
  final bool number;
  final bool check;
  final bool isvalidator;
  final String hinttext;
  final TextEditingController mycontroler;
  const CustomTextFormFieldUser({super.key, required this.hinttext ,required this.mycontroler, required this.check, required this.number, required this.isvalidator});
  @override
  Widget build (BuildContext context)
  {
    return TextFormField(
      style: TextStyle(color: mainwhitetheme),
      autovalidateMode: isvalidator?AutovalidateMode.onUserInteraction:null,
      validator: isvalidator?
          (value){
        if(value==null ||value.isEmpty)
          return 'يرجى ادخل النص هنا';
        if(value.length<4)
          return 'يجب ان يكون عدد الاحرف على الاقل 4';
        if(value.length>20)
          return 'حد اقصى 20 حرف';
        else
          return null;
      }:null,
      obscureText: check,
      controller: mycontroler,
      keyboardType:number==true?  TextInputType.number:null,
      decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: TextStyle(fontSize: 16,color: mainwhitetheme),
          contentPadding: const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
          filled: true,
          fillColor: mainDarkgray,
          border: OutlineInputBorder(
            borderRadius:BorderRadius.circular(50),
            borderSide:  BorderSide(color: mainwhitetheme),
          ),
        focusedBorder: OutlineInputBorder(
          borderRadius:BorderRadius.circular(50),
          borderSide:  BorderSide(color: mainwhitetheme),
        ),
      ),
    );
  }
}