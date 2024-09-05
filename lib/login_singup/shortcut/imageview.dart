import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../video_player.dart';

class ImageView extends StatelessWidget {
  final bool isArrow;
  final String img;
  final String trailerVideo;
  const ImageView({Key? key, required this.img, required this.isArrow, required this.trailerVideo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFF5F3FF),
          image:DecorationImage(
            image: CachedNetworkImageProvider(img),
            fit: BoxFit.cover,
          )
      ),
      child: isArrow
          ? Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: MaterialButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoPlayer(url:trailerVideo,phone_number:''),));
            },
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.indigoAccent[400],
              size: 45,
            ),
          ),
        ),
      )
          : null,
    );
  }
}
