import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import '../add_data/new_project.dart';
import '../login_singup/shortcut/projectview.dart';
import '../screens/appBar.dart';
class Projects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          CustomAppBarWidget(text:"المشاريع",),
          SizedBox(height: 20),
          ProjectView(check: true),
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
