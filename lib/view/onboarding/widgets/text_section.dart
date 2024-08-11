import 'package:flutter/material.dart';

import 'text_column.dart';

class TextSection extends StatelessWidget {
  final String title;
  final String subTitle;
  const TextSection({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return TextColumn(
      title: title,
      text: subTitle,
    );
  }
}
