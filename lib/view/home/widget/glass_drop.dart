import 'dart:ui';

import 'package:flutter/material.dart';

class GlassDropEffect extends StatelessWidget {
  final BoxShape shape;
  final Widget child;
  final double sigma;
  const GlassDropEffect(
      {super.key,
      this.sigma = 7,
      this.shape = BoxShape.rectangle,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: shape == BoxShape.circle
          ? BorderRadius.circular(100)
          : BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: shape,
              color: Colors.black.withOpacity(0.3),
              borderRadius:
                  shape == BoxShape.circle ? null : BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: child),
      ),
    );
  }
}
