import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduate/course.dart';
import 'package:graduate/course_page/category.dart';
import 'package:graduate/course_page/free_coures.dart';
import 'package:graduate/course_page/meet.dart';
import 'package:graduate/course_page/mlazm.dart';
import 'package:graduate/course_page/projects.dart';
import 'package:graduate/main.dart';
import 'package:graduate/screens.dart';
import 'package:graduate/screens/appBar.dart';
import 'package:graduate/screens/teacherFreeCourse.dart';
import 'login_singup/shortcut/projectview.dart';
class HomePage extends StatefulWidget
{
  final List<String> catNames;
  final List<Color> catColors ;
  final List<Icon> catIcons ;
  const HomePage({super.key, required this.catNames, required this.catColors, required this.catIcons});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build (BuildContext context)
  {
    return ListView(
      physics:BouncingScrollPhysics(),
        children: [
          CustomAppBarWidget(text:"Home Page",),
          Padding(padding: const EdgeInsets.only(top: 20,left: 15,right: 15),
            child:Column(children: [
               GridView.builder(
                  itemCount:widget.catIcons.length,
                    shrinkWrap: true,
                    gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.1,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(children: [
                              InkWell(
                                child: Container(
                                 height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: widget.catColors[index],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: widget.catIcons[index],
                                  ),
                                ),
                                onTap: (){
                                  if (index==0) {
                                    Navigator.of(context).push(MaterialPageRoute(builder:(context) => Category1()));
                                  }
                                    else if (index==1) {
                                        setState(() {
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Screens(currentindex: 1),), (route) => false);
                                        });
                                      }
                                     else if (index==2) {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>TeachersFreeCourse()));
                                      }
                                      else  if (index==3) {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Mlazm()));
                                        }
                                       else  if (index==4) {
                                           Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Meet() ));
                                         }
                                         else   if (index==5) {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Projects()));
                                            }
                                      },
                              ),

                        const SizedBox(height: 10,),
                        Text(widget.catNames[index],style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.7)),)
                      ],
                      );
                    },
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  const Text("الدورات",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 23),),
                  InkWell(
                      onTap: (){
                    setState(() {
                   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Screens(currentindex: 1),), (route) => false);
                         });
                      },
                      child: Text("مشاهدة المزيد",style: TextStyle(color: Colors.indigoAccent[400],fontWeight: FontWeight.w500,fontSize: 18),)),
                ],
              ),
              const SizedBox(height: 10,),
            const Course(),
              const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    const Text("المشاريع",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 23),),
                    InkWell(
                        onTap: (){
                      setState(() {
                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => Projects(),));
                           });
                        },
                        child: Text("مشاهدة المزيد",style: TextStyle(color: Colors.indigoAccent[400],fontWeight: FontWeight.w500,fontSize: 18),)),
                  ],
                ),
            const SizedBox(height: 10,),
             const ProjectView(check:false)
            ],
            ),
          ),
        ],
      );
  }
}