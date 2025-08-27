import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final String errorAsset;
  final BorderRadius? borderRadius;

  const CachedImageWidget({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.errorAsset = AppAssets.appIcon, // Default error icon
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        cacheKey: imageUrl,
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        errorWidget: (context, url, error) {
          print(error);
          return Image.asset(errorAsset, height: height, width: width, fit: fit);
        },
      ),
    );
  }
}


class SVGImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Widget errorWidget;
  final BorderRadius? borderRadius;

  const SVGImageWidget({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.errorWidget = const SizedBox(),
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: SvgPicture.network(
        imageUrl,
        height: height,
        width: width,
        errorBuilder: (context, error, stackTrace) {
          print("svg error ${error.toString()}");
          return errorWidget;
        },
        placeholderBuilder: (context) => CircularProgressIndicator(),
      ),
    );
  }
}


