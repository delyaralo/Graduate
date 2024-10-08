import 'package:flutter/material.dart';
import 'package:graduate/main.dart';

class Logo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(right: 4),
        height: 80,
        child: Image.asset("images/logo4.png"),
        decoration: BoxDecoration(
          color: Color(0xff002837),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}