import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/core.dart';

class LottieLoader extends StatelessWidget {
  const LottieLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(LottieAssets.panLoader, animate: true, width: 300);
  }
}
