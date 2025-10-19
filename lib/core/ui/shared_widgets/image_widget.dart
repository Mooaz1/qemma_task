import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qemma_task/core/ui/assets_manager/assets_manager.dart';
import 'package:shimmer/shimmer.dart';


class ImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final bool asDecoration;

  const ImageWidget({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.asDecoration = false,
  });

  static ImageProvider getProvider(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return AssetImage(AssetsManager.noImage);
    }
    return CachedNetworkImageProvider(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (asDecoration) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          image: DecorationImage(image: getProvider(imageUrl), fit: fit),
        ),
      );
    }

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallback();
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => _buildShimmer(),
        errorWidget: (context, url, error) => _buildFallback(),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: borderRadius,
        image: DecorationImage(image: AssetImage(AssetsManager.noImage)),
      ),
    );
  }
}
