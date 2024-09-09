import 'package:flutter/material.dart';
import 'package:graduate/Description_section.dart';
import 'package:graduate/login_singup/shortcut/imageview.dart';

import '../main.dart';
class BuyCourse extends StatelessWidget
{
  final String price;
  final String title;
  final String depWhatsApp;
  final bool showPrice;
  BuyCourse({super.key, required this.price, required this.title, required this.depWhatsApp, required this.showPrice});
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar
          (
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(title,style: const TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1),),
        ),
        body:Padding(padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            child: ListView(

                children: [
                  Container(height:MediaQuery.of(context).size.height/4,),
                  showPrice == true
                      ? Center(
                    child: Column(
                      children: [
                        Text(
                          "السعر",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          price,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                      ],
                    ),
                  )
                      : SizedBox.shrink(), // يعرض عنصر فارغ يأخذ أقل مساحة ممكنة,
                  const SizedBox(height:15,),
                  Center(child: Text("للمزيد من المعلومات يرجى التواصل مع",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                  const SizedBox(height:15,),
                  Center(child: Text(depWhatsApp,style:  TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.7)),)),
                ])
        )
    );
  }

}