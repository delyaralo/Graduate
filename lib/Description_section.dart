import 'package:flutter/material.dart';

import 'add_data/new_course.dart';
import 'login_singup/shortcut/custombotton.dart';

class DescriptionSection extends StatelessWidget
{
  final String description;
  const DescriptionSection({super.key, required this.description});
  @override
  Widget build(BuildContext context )
  {
    return Column(
      children: [
        Text(description,
        style: TextStyle(fontSize: 16,letterSpacing: 0.6,height: 1.3),textAlign: TextAlign.start,),
      ],
  );
  }

}