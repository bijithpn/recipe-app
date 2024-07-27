import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final Widget? errorWidget;
  final Widget? placeHolderWidget;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;

  const ImageWidget({
    super.key,
    required this.imageUrl,
    this.fit,
    this.height,
    this.width,
    this.errorWidget,
    this.placeHolderWidget,
    this.decoration,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      fit: fit,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(4),
        decoration: decoration,
        child: Image(
          image: imageProvider,
          width: double.infinity,
        ),
      ),
      placeholder: (context, url) =>
          placeHolderWidget ??
          SizedBox(
            width: width,
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            width: width,
            height: height,
            color: Colors.grey.shade300,
            child: const Icon(Icons.error_outline),
          ),
    );
  }
}
