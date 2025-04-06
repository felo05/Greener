import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greener/core/constants/kcolors.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    this.height,
    required this.image,
    this.fit,
    this.width,
  });
  final double? width;
  final double? height;
  final String image;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      width: width??double.infinity,
      height: height?.h,
      fit: fit ?? BoxFit.contain,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator(color: baseColor,)),
      errorWidget: (context, url, error) =>
          const Center(child: Icon(Icons.error)),
    );
  }
}
