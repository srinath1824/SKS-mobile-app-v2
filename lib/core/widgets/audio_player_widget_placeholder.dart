// Placeholder audio player widget - preserves UI layout without audio functionality
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AudioPlayerWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;

  const AudioPlayerWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.saffron.withOpacity(0.1),
            AppTheme.lightOrange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.saffron.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Placeholder album art
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.saffron.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.music_note,
                  color: AppTheme.saffron,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkBrown,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.darkBrown.withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Audio controls placeholder
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(Icons.skip_previous, () {}),
              const SizedBox(width: 20),
              _buildControlButton(Icons.play_arrow, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Audio features will be available in the next update'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }),
              const SizedBox(width: 20),
              _buildControlButton(Icons.skip_next, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.saffron,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.saffron.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}