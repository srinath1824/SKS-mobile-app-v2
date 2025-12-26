import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';
import '../utils/performance_utils.dart';

class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? placeholder;

  const OptimizedImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
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
        memCacheWidth: _getOptimizedCacheWidth(),
        memCacheHeight: _getOptimizedCacheHeight(),
        maxWidthDiskCache: _getOptimizedDiskCacheWidth(),
        maxHeightDiskCache: _getOptimizedDiskCacheHeight(),
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildErrorWidget(),
        fadeInDuration: PerformanceUtils.getAnimationDuration(),
        fadeOutDuration: PerformanceUtils.getAnimationDuration(),
      ),
    );
  }

  int? _getOptimizedCacheWidth() {
    if (width == null) return null;
    final devicePixelRatio = WidgetsBinding.instance.window.devicePixelRatio;
    return (width! * devicePixelRatio).round();
  }

  int? _getOptimizedCacheHeight() {
    if (height == null) return null;
    final devicePixelRatio = WidgetsBinding.instance.window.devicePixelRatio;
    return (height! * devicePixelRatio).round();
  }

  int? _getOptimizedDiskCacheWidth() {
    if (width == null) return null;
    return PerformanceUtils.shouldReduceAnimations() 
        ? (width! * 1.5).round() 
        : (width! * 2.0).round();
  }

  int? _getOptimizedDiskCacheHeight() {
    if (height == null) return null;
    return PerformanceUtils.shouldReduceAnimations() 
        ? (height! * 1.5).round() 
        : (height! * 2.0).round();
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
            size: 32,
          ),
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: AppTheme.softGray,
      highlightColor: AppTheme.white,
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
          size: 32,
        ),
      ),
    );
  }
}

class OptimizedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const OptimizedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PerformanceUtils.optimizedBuilder(
      builder: () => OptimizedImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}