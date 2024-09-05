import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:graduate/main.dart';
import 'package:graduate/screens/department.dart';
import 'package:graduate/screens/favorites.dart';
import 'package:graduate/screens/profile.dart';
import 'add_data/new_teacher.dart';
import 'home_screen.dart';

class Screens extends StatefulWidget {
  int currentindex;
  Screens({super.key, required this.currentindex});

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
  List<String> appBarTitle = [
    "الرئيسية",
    "الاقسام",
    "دوراتك",
    "الحساب",
  ];
  List<String> catNames = [
    "الاقسام",
    "الدورات المجانية",
    "المشاريع",
  ];
  List<Color> catColors = [
    const Color(0xFF6fe08d),
    const Color(0xFF61BDFD),
    const Color(0xFF78E667),
  ];

  List<Icon> catIcons = [
    const Icon(Icons.video_library, color: Colors.white, size: 30),
    const Icon(Icons.store, color: Colors.white, size: 30),
    const Icon(Icons.emoji_events, color: Colors.white, size: 30),
  ];

  void addteacher(String name, String img) {
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
  Widget build(BuildContext context) {
    List<Widget> widgetpages = [
      HomePage(catNames: catNames, catColors: catColors, catIcons: catIcons),
      Department(),
      Favorites(),
      Profile(),
    ];
    return Scaffold(
      appBar:widget.currentindex!=0 ? AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        title: Text(
          appBarTitle[widget.currentindex],
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ):null,
      body: widgetpages.elementAt(widget.currentindex),
      floatingActionButton: widget.currentindex == 1 && isadmin
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewTeacher(),));
        },
        child: Icon(Icons.add),
        backgroundColor: mainColors,
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        iconSize: 32,
        selectedItemColor: mainColors,
        selectedFontSize: 18,
        unselectedItemColor: Colors.grey,
        currentIndex: widget.currentindex,
        onTap: (index) {
          setState(() {
            widget.currentindex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: appBarTitle[0],

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: appBarTitle[1],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ondemand_video),
            label: appBarTitle[2],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: appBarTitle[3],
          ),
        ],
      ),
    );
  }
}
