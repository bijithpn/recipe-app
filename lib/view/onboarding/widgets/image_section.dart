import 'package:flutter/material.dart';

class ImageSection extends StatelessWidget {
  final String imgpath;
  const ImageSection({
    super.key,
    required this.imgpath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Image.asset(imgpath),
        )
      ],
    );
  }
}
