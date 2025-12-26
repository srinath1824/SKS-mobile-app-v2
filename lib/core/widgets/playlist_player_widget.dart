import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import '../services/playlist_audio_service.dart';
import '../theme/app_theme.dart';

class PlaylistPlayerWidget extends StatefulWidget {
  final List<Map<String, String>> playlist;
  final int startIndex;
  final VoidCallback? onClose;

  const PlaylistPlayerWidget({
    Key? key,
    required this.playlist,
    this.startIndex = 0,
    this.onClose,
  }) : super(key: key);

  @override
  State<PlaylistPlayerWidget> createState() => _PlaylistPlayerWidgetState();
}

class _PlaylistPlayerWidgetState extends State<PlaylistPlayerWidget> {
  final PlaylistAudioService _audioService = PlaylistAudioService.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPlaylist();
  }

  Future<void> _loadPlaylist() async {
    setState(() => _isLoading = true);
    try {
      await _audioService.loadPlaylist(widget.playlist, widget.startIndex);
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.spiritualGradient,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [AppTheme.softShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<MediaItem?>(
            stream: _audioService.mediaItem,
            builder: (context, snapshot) {
              final mediaItem = snapshot.data;
              return Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: mediaItem?.artUri != null
                          ? DecorationImage(
                              image: AssetImage(mediaItem!.artUri!.path.substring(1)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: mediaItem?.artUri == null
                        ? const Icon(Icons.music_note, color: AppTheme.saffron)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mediaItem?.title ?? 'Loading...',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.darkBrown,
                          ),
                        ),
                        Text(
                          mediaItem?.artist ?? 'SKS Spiritual App',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.darkBrown,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.close, color: AppTheme.darkBrown),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          StreamBuilder<Duration>(
            stream: _audioService.player.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = _audioService.player.duration ?? Duration.zero;
              
              return Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppTheme.saffron,
                      inactiveTrackColor: AppTheme.saffron.withOpacity(0.3),
                      thumbColor: AppTheme.saffron,
                      overlayColor: AppTheme.saffron.withOpacity(0.2),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: duration.inMilliseconds > 0 
                          ? position.inMilliseconds / duration.inMilliseconds 
                          : 0.0,
                      onChanged: (value) {
                        final newPosition = Duration(
                          milliseconds: (value * duration.inMilliseconds).round(),
                        );
                        _audioService.seek(newPosition);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(position),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.darkBrown,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${_audioService.currentIndex + 1}/${widget.playlist.length}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.darkBrown,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.loop,
                              size: 16,
                              color: AppTheme.saffron,
                            ),
                          ],
                        ),
                        Text(
                          _formatDuration(duration),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.darkBrown,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          StreamBuilder<PlaybackState>(
            stream: _audioService.playbackState,
            builder: (context, snapshot) {
              final playbackState = snapshot.data;
              final isPlaying = playbackState?.playing ?? false;
              final isLoading = _isLoading || 
                  playbackState?.processingState == AudioProcessingState.loading;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _audioService.skipToPrevious(),
                    icon: const Icon(Icons.skip_previous, size: 32),
                    color: AppTheme.saffron,
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: AppTheme.saffronGradient,
                      shape: BoxShape.circle,
                      boxShadow: [AppTheme.glowShadow],
                    ),
                    child: IconButton(
                      onPressed: isLoading ? null : () {
                        if (isPlaying) {
                          _audioService.pause();
                        } else {
                          _audioService.play();
                        }
                      },
                      icon: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 32,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () => _audioService.skipToNext(),
                    icon: const Icon(Icons.skip_next, size: 32),
                    color: AppTheme.saffron,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _audioService.stop(),
                icon: const Icon(Icons.stop, size: 24),
                color: AppTheme.saffron,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}