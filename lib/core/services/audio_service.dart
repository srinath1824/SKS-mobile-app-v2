import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService extends BaseAudioHandler {
  static AudioPlayerService? _instance;
  static AudioPlayerService get instance => _instance ??= AudioPlayerService._();
  
  AudioPlayerService._();
  
  final AudioPlayer _player = AudioPlayer();
  
  @override
  Future<void> play() async {
    try {
      await _player.play();
      playbackState.add(playbackState.value.copyWith(
        controls: [MediaControl.pause, MediaControl.stop],
        systemActions: {MediaAction.seek},
        playing: true,
        processingState: AudioProcessingState.ready,
      ));
    } catch (e) {
      playbackState.add(playbackState.value.copyWith(
        processingState: AudioProcessingState.error,
      ));
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _player.pause();
      playbackState.add(playbackState.value.copyWith(
        controls: [MediaControl.play, MediaControl.stop],
        playing: false,
      ));
    } catch (e) {
      playbackState.add(playbackState.value.copyWith(
        processingState: AudioProcessingState.error,
      ));
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _player.stop();
      playbackState.add(playbackState.value.copyWith(
        controls: [MediaControl.play],
        playing: false,
        processingState: AudioProcessingState.idle,
      ));
    } catch (e) {
      playbackState.add(playbackState.value.copyWith(
        processingState: AudioProcessingState.error,
      ));
    }
  }

  @override
  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      // Handle seek error
    }
  }

  Future<void> loadAudio(String assetPath, String title) async {
    try {
      await _player.setAsset(assetPath);
      
      mediaItem.add(MediaItem(
        id: assetPath,
        title: title,
        artist: 'SKS Spiritual App',
        duration: _player.duration,
        artUri: Uri.parse('asset:///assets/images/Guruji_Meditation.PNG'),
      ));

      playbackState.add(PlaybackState(
        controls: [MediaControl.play],
        systemActions: {MediaAction.seek},
        playing: false,
        processingState: AudioProcessingState.ready,
      ));

      _player.positionStream.listen((position) {
        playbackState.add(playbackState.value.copyWith(
          updatePosition: position,
        ));
      });

      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          stop();
        }
      });
    } catch (e) {
      playbackState.add(playbackState.value.copyWith(
        processingState: AudioProcessingState.error,
      ));
    }
  }

  AudioPlayer get player => _player;
  
  void dispose() {
    _player.dispose();
  }
}