import 'package:flutter/material.dart';

import '../../../core/core.dart';

class TextColumn extends StatelessWidget {
  final String title;
  final String text;

  const TextColumn({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: ColorPalette.primary, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
