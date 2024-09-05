import 'package:flutter/material.dart';
import 'package:graduate/Description_section.dart';
import 'package:graduate/login_singup/shortcut/imageview.dart';
class BuyCourse extends StatelessWidget
{
  final String price;
  final String title;
  const BuyCourse({super.key, required this.price, required this.title});
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

              const SizedBox(height:15,),
              Center(child: Text("للمزيد من المعلومات يرجى التواصل مع",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
              const SizedBox(height:15,),
              Center(child: Text("WhatsApp  :07748687725",style:  TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.7)),)),
              Center(child: SizedBox(height:10,)),
              Center(child: Text("Instagram  : g_raduate",style:  TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.7)),)),
              SizedBox(height:10,),
              Center(child: Text("telegram    : g_raduate",style:  TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.7)),)),
            ])
        )
    );
  }

}