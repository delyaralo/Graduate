import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../custombutton.dart';
import '../../video_player.dart';

class ImageView extends StatelessWidget {
  final bool isArrow;
  final String img;
  final String trailerVideo;

  const ImageView({
    Key? key,
    required this.img,
    required this.isArrow,
    required this.trailerVideo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // الحصول على حجم الشاشة
    final screenSize = MediaQuery.of(context).size;

    // تحديد حجم الصورة والأيقونة بناءً على حجم الشاشة
    final double imageSize = screenSize.width * 0.5; // نصف عرض الشاشة
    final double iconSize = imageSize * 0.25; // 25% من حجم الصورة

    return Container(
      padding: const EdgeInsets.all(5),
      child:  Center(
        child: Stack(
          alignment: Alignment.center, // توسيط الأيقونة في وسط الصورة
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: img,
                width: imageSize,
                height: imageSize,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child:isArrow
                    ? MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Video_Player(url: trailerVideo, phone_number: ''),
                      ),
                    );
                  },
                  child:isArrow
                      ? Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.indigoAccent[400],
                    size: iconSize,
                  ):null,
                ):null,
              ),
            ),
          ],
        ),
      )
      ,
    );
  }
}
