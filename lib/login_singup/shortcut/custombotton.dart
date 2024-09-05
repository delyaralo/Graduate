import 'package:flutter/material.dart';
import 'package:graduate/main.dart';
class custombutton extends StatelessWidget {

  final void Function()? onPressed;
  final String text;
  final dynamic color;
  const custombutton({super.key,required this.onPressed, required this.text, this.color});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color:color==null? mainColors:color,
              borderRadius: BorderRadius.circular(50)
          ),
          child: MaterialButton(
            onPressed: onPressed
            ,child: Text(text,style: TextStyle(color: Colors.white,fontSize: 18)),),
        )
    );
  }
}