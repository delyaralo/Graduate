import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Welcome_Screen extends StatelessWidget
{
  @override
  Widget build (BuildContext context){
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Material(
    child: Container(
    width:MediaQuery.of(context).size.width,
    height:MediaQuery.of(context).size.height,
    child: Stack(
      children: [
        Stack(
          children:[ Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/1.6,
            decoration: BoxDecoration(
              color:Colors.white
            ),
          ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/1.6,
          decoration: BoxDecoration(
              color:Colors.indigoAccent[400],
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(80))
          ),
          child: Center(
            child: Image.asset("images/books.png"),
          ),
        ),
        ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/2.666,
            decoration: BoxDecoration(
              color: Colors.indigoAccent[400],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/2.666,
            padding: EdgeInsets.only(top: 40,bottom: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(80))
            ),
            child: Column(children: [
                Text("Learning is Everything",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600,wordSpacing: 2,letterSpacing: 1),),
              SizedBox(height: 15,),
              Padding(padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text("Learing with Pleasure with Dear programmer (Graduate),"
                  "Wherever you are. ",style: TextStyle(fontSize: 17,color: Colors.black.withOpacity(0.6)),textAlign: TextAlign.center,),
              ),
              SizedBox(height: 50,),
              Material(
                color:Colors.indigoAccent[400],
                borderRadius: BorderRadius.circular(12),
                child: InkWell(onTap: (){Navigator.pushReplacementNamed(context,"homepage");},
                child:Container(
                  padding: EdgeInsets.symmetric(vertical:15,horizontal: 80),
                  child: Text("Get Start",style:TextStyle(color: Colors.white,fontSize:22,fontWeight: FontWeight.bold,letterSpacing: 1) ,),
                ),),
              )
            ],
            ),
          ),
        ),
      ],
    ),
  ),
  );
  }
}