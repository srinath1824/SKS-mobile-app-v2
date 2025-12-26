import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String title;
  final String assetPath;
  final VoidCallback? onClose;

  const AudioPlayerWidget({
    Key? key,
    required this.title,
    required this.assetPath,
    this.onClose,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayerService _audioService = AudioPlayerService.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    setState(() => _isLoading = true);
    try {
      await _audioService.loadAudio(widget.assetPath, widget.title);
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
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/Guruji_Meditation.PNG'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkBrown,
                      ),
                    ),
                    const Text(
                      'SKS Spiritual App',
                      style: TextStyle(
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
                    onPressed: () => _audioService.seek(Duration.zero),
                    icon: const Icon(Icons.replay_10, size: 32),
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
                    onPressed: () => _audioService.stop(),
                    icon: const Icon(Icons.stop, size: 32),
                    color: AppTheme.saffron,
                  ),
                ],
              );
            },
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