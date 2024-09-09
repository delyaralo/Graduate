import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:graduate/Description_section.dart';
import 'package:graduate/login_singup/shortcut/imageview.dart';

import '../../main.dart';
class ProjctViewScile extends StatelessWidget
{
  final String price;
  final String img;
  final String projectdescription;
  final String title;
  final showPrice;
   ProjctViewScile({super.key, required this.img, required this.projectdescription, required this.price, required this.title, this.showPrice});
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
            child: ListView(children: [
              ImageView(img: img, isArrow:false, trailerVideo: ''),
              const SizedBox(height:15,),
              Text("$title Project",style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
              const SizedBox(height:5,),
              Text("Created by Dear Programmer",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.7)),),
              const SizedBox(height:15,),
              projectdescription!=null?DescriptionSection(description:projectdescription,):SizedBox(height: 30,),
              const SizedBox(height:5,),
              showPrice == true ?Center(
                child: Column(
                  children: [
                    Text(
                      "Price",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      price,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                    ),

                  ],
                ),
              ):Text(
                  "     ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
              const SizedBox(height:15,),
              Text("For more details contact with ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              const SizedBox(height:15,),
              Text("WhatsApp  :07748687725",style:  TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.7)),),
              SizedBox(height:10,),
              Text("Instagram  : g_raduate",style:  TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.7)),),
              SizedBox(height:10,),
              Text("telegram    : g_raduate",style:  TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.7)),),
            ])
        )
    );
  }

}