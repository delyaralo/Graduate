import 'package:flutter/material.dart';
import 'package:graduate/main.dart'; // Ensure this contains the definition of `mainColors`
import '../login_singup/shortcut/customappbar.dart'; // Ensure this is the correct path

class CustomAppBarWidget extends StatelessWidget {
  final String text;
  const CustomAppBarWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
        color: mainColors, // Ensure `mainColors` is defined in `main.dart`
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Center(
              child: Text(
                text, // Accessing the text parameter correctly
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  wordSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
