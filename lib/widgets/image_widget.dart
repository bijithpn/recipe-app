import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/core.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final Widget? errorWidget;
  final Widget? placeHolderWidget;
  final Widget Function(BuildContext, ImageProvider<Object>)? imagePlaceholder;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const ImageWidget({
    Key? key,
    required this.imageUrl,
    this.fit,
    this.height,
    this.width,
    this.errorWidget,
    this.placeHolderWidget,
    this.imagePlaceholder,
    this.decoration,
    this.padding,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      fit: fit,
      imageUrl: imageUrl,
      imageBuilder: imagePlaceholder ??
          (context, imageProvider) => Container(
                width: width,
                height: height,
                padding: padding,
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(image: imageProvider, fit: fit)),
              ),
      placeholder: (context, url) =>
          placeHolderWidget ??
          SizedBox(
            width: width,
            height: height,
            child: Center(
                child: Lottie.asset(LottieAssets.spoonLoader, animate: true)),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            child: const Icon(Icons.error_outline),
          ),
    );
  }
}
