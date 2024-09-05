import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:graduate/main.dart';
import 'package:graduate/screens/favorites.dart';
import 'package:graduate/screens/profile.dart';
import 'package:graduate/screens/teachers.dart';
import 'package:graduate/themee/themme.dart';
import 'add_data/new_teacher.dart';
import 'home_screen.dart';
class Screens extends StatefulWidget
{
  int currentindex;
  Screens({super.key,required this.currentindex});
  @override
  State<Screens> createState() => _Screens();
}
class _Screens extends State<Screens> {
  List<String> teachers_name = [
    "حسين خريج",
  ];
  List<String> teachersimg = [
    "hussein",
  ];
  List<String> catNames = [
    "الفئات",
    "الدورات",
    "الدورات المجانية",
    "الملازم",
    "الدورات التفاعلية",
    "المشاريع",
  ];
  List<Color> catColors = [
    const Color(0xFFffcf2f),
    const Color(0xFF6fe08d),
    const Color(0xFF61BDFD),
    const Color(0xFFFC7C7F),
    const Color(0xFFCB84FB),
    const Color(0xFF78E667),
  ];

  List<Icon> catIcons = [
    const Icon(Icons.category, color: Colors.white, size: 30,),
    const Icon(Icons.video_library, color: Colors.white, size: 30,),
    const Icon(Icons.store, color: Colors.white, size: 30,),
    const Icon(Icons.assignment, color: Colors.white, size: 30,),
    const Icon(Icons.play_circle_fill, color: Colors.white, size: 30,),
    const Icon(Icons.emoji_events, color: Colors.white, size: 30,),
  ];


  void addteacher(String name, String img)
  {
    setState(() {
      teachers_name.add(name);
      teachersimg.add(img);
    });
}
  @override
  void initState() {
    super.initState();
    AutoOrientation.portraitUpMode();
  }
  @override
  Widget build (BuildContext context)
  {
    List<Widget>widgetpages = [
      HomePage(catNames: catNames, catColors: catColors, catIcons: catIcons),
      Teachers(),
      Favorites(),
      Profile(),
    ];
    return Scaffold(
      body:widgetpages.elementAt(widget.currentindex),
      floatingActionButton: widget.currentindex==1&&isadmin?FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewTeacher(),));
      },child: Icon(Icons.add),backgroundColor: mainColors,):null,
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        iconSize: 32,
        selectedItemColor: mainColors,
        selectedFontSize: 18,
        unselectedItemColor: Colors.grey,
        currentIndex: widget.currentindex,
        onTap: (index){
          setState(() {
            widget.currentindex=index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label:'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment),label: 'الأساتذة'),
          BottomNavigationBarItem(icon: Icon(Icons.ondemand_video),label: 'كورساتك'),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: 'الحساب'),
        ],
      ),
    );
  }
}