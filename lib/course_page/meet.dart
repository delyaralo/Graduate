import 'package:flutter/material.dart';

import '../login_singup/shortcut/customappbar.dart';
class Meet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      body: ListView(

        children: [
          Container(
            padding: const EdgeInsets.only(top: 15,left: 15,right: 15,bottom: 10),
            decoration: BoxDecoration(
              color: Colors.indigoAccent[400],
              borderRadius: const BorderRadius.only(bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20)),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(),
                  const SizedBox(height: 20,),
                  const Padding(padding: EdgeInsets.only(left: 3,bottom: 15),
                    child: Center(child: Text("الدورات التفاعلية",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600,letterSpacing: 1,wordSpacing: 2,color: Colors.white),)),
                  ),
                ]
            ),
          ),
          SizedBox(height: 100,),
          Center(
            child: Text("قريبا",style: TextStyle(fontSize: 35,fontWeight: FontWeight.w900,letterSpacing: 1,wordSpacing: 2,color: Colors.indigoAccent[400]),),
          )
        ],
      ),
    );
  }
}
