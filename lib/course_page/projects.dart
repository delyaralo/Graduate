import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import '../add_data/new_project.dart';
import '../login_singup/shortcut/projectview.dart';
import '../screens/appBar.dart';
class Projects extends StatelessWidget {
  final bool showPrice;
  const Projects({super.key, required this.showPrice});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        title: Text(
          "المشاريع",
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          ProjectView(check: true,showPrice:showPrice,),
        ],
      ),
      floatingActionButton:isadmin? FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewProject(),));
        },
        child: Icon(Icons.add,),
      ):null,
    );
  }

}
