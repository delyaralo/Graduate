import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final bool isArrow;
  final String img;

  const ImageView({Key? key, required this.img, required this.isArrow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFFF5F3FF),
        image: DecorationImage(
          image: NetworkImage(img), // Use NetworkImage to load an image from a URL
          fit: BoxFit.fitHeight, // Adjust the fit to your needs
        ),
      ),
      child: isArrow
          ? Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.play_arrow_rounded,
            color: Colors.indigoAccent[400],
            size: 45,
          ),
        ),
      )
          : null,
    );
  }
}
