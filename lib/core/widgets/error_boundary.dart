import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget? fallback;
  final Function(Object error, StackTrace stackTrace)? onError;

  const ErrorBoundary({
    Key? key,
    required this.child,
    this.fallback,
    this.onError,
  }) : super(key: key);

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _hasError = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.fallback ?? _buildDefaultErrorWidget();
    }

    return Builder(
      builder: (context) {
        try {
          return widget.child;
        } catch (error, stackTrace) {
          _handleError(error, stackTrace);
          return widget.fallback ?? _buildDefaultErrorWidget();
        }
      },
    );
  }

  void _handleError(Object error, StackTrace stackTrace) {
    setState(() {
      _hasError = true;
      _error = error;
    });

    widget.onError?.call(error, stackTrace);
  }

  Widget _buildDefaultErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.saffron.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 30,
              color: AppTheme.saffron,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkBrown,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please try again',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.darkBrown,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _hasError = false;
                _error = null;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.saffron,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class SafeWidget extends StatelessWidget {
  final Widget child;
  final Widget? fallback;

  const SafeWidget({
    Key? key,
    required this.child,
    this.fallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      fallback: fallback,
      child: child,
    );
  }
}