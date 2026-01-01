// Placeholder playlist player widget - preserves UI layout without audio functionality
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PlaylistPlayerWidget extends StatelessWidget {
  final List<Map<String, String>> songs;

  const PlaylistPlayerWidget({
    super.key,
    required this.songs,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.saffron.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.queue_music,
                  color: AppTheme.saffron,
                  size: 40,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Spiritual Playlist',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${songs.length} tracks',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.darkBrown.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Playlist controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(Icons.shuffle, 'Shuffle', () {
                _showComingSoonMessage(context);
              }),
              _buildControlButton(Icons.play_arrow, 'Play All', () {
                _showComingSoonMessage(context);
              }),
              _buildControlButton(Icons.repeat, 'Repeat', () {
                _showComingSoonMessage(context);
              }),
            ],
          ),
          const SizedBox(height: 16),
          // Current track placeholder
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.music_note,
                  color: AppTheme.saffron,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    songs.isNotEmpty 
                        ? songs.first['title'] ?? 'Unknown Track'
                        : 'No tracks available',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.darkBrown,
                    ),
                  ),
                ),
                Text(
                  'Ready to play',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.darkBrown.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
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
            icon: Icon(icon, color: Colors.white, size: 24),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.darkBrown,
          ),
        ),
      ],
    );
  }

  void _showComingSoonMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Audio features will be available in the next update'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}