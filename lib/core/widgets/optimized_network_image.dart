import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DefaultCacheManager {
  // Placeholder for cache manager
}
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';
import '../utils/performance_utils.dart';

class OptimizedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const OptimizedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: _getOptimizedWidth(),
        memCacheHeight: _getOptimizedHeight(),
        maxWidthDiskCache: _getOptimizedWidth(),
        maxHeightDiskCache: _getOptimizedHeight(),
        placeholder: (context, url) => placeholder ?? _buildPlaceholder(),
        errorWidget: (context, url, error) => errorWidget ?? _buildErrorWidget(),
        fadeInDuration: PerformanceUtils.getAnimationDuration(),
        fadeOutDuration: const Duration(milliseconds: 100),
        useOldImageOnUrlChange: true,
        cacheManager: null,
      ),
    );
  }

  int? _getOptimizedWidth() {
    if (width == null) return null;
    final devicePixelRatio = WidgetsBinding.instance.window.devicePixelRatio;
    final optimizedWidth = (width! * devicePixelRatio).round();
    return PerformanceUtils.shouldReduceAnimations() 
        ? (optimizedWidth * 0.8).round() 
        : optimizedWidth;
  }

  int? _getOptimizedHeight() {
    if (height == null) return null;
    final devicePixelRatio = WidgetsBinding.instance.window.devicePixelRatio;
    final optimizedHeight = (height! * devicePixelRatio).round();
    return PerformanceUtils.shouldReduceAnimations() 
        ? (optimizedHeight * 0.8).round() 
        : optimizedHeight;
  }

  Widget _buildPlaceholder() {
    if (PerformanceUtils.shouldReduceAnimations()) {
      return Container(
        width: width,
        height: height,
        color: AppTheme.softGray,
        child: const Center(
          child: Icon(
            Icons.image,
            color: AppTheme.darkBrown,
            size: 24,
          ),
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: AppTheme.softGray,
      highlightColor: AppTheme.white,
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: width,
        height: height,
        color: AppTheme.softGray,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: AppTheme.softGray,
      child: const Center(
        child: Icon(
          Icons.error_outline,
          color: AppTheme.darkBrown,
          size: 24,
        ),
      ),
    );
  }
}