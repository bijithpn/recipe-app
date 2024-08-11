import 'package:flutter/material.dart';

import '../../../core/core.dart';

class NextPageButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NextPageButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: const EdgeInsets.all(16),
      elevation: 0.0,
      shape: const CircleBorder(),
      fillColor: ColorPalette.primary,
      onPressed: onPressed,
      child: const Icon(
        Icons.arrow_forward,
        color: Colors.white,
        size: 32.0,
      ),
    );
  }
}
