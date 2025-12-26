import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class PlaylistAudioService extends BaseAudioHandler {
  static PlaylistAudioService? _instance;
  static PlaylistAudioService get instance => _instance ??= PlaylistAudioService._();
  
  PlaylistAudioService._();
  
  final AudioPlayer _player = AudioPlayer();
  List<MediaItem> _playlist = [];
  int _currentIndex = 0;
  
  @override
  Future<void> play() async {
    try {
      await _player.play();
      _updatePlaybackState(playing: true);
    } catch (e) {
      _updatePlaybackState(error: true);
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _player.pause();
      _updatePlaybackState(playing: false);
    } catch (e) {
      _updatePlaybackState(error: true);
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _player.stop();
      _updatePlaybackState(playing: false, stopped: true);
    } catch (e) {
      _updatePlaybackState(error: true);
    }
  }

  @override
  Future<void> skipToNext() async {
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0; // Loop to first song
    }
    await _loadCurrentTrack();
    await play();
  }

  @override
  Future<void> skipToPrevious() async {
    if (_currentIndex > 0) {
      _currentIndex--;
    } else {
      _currentIndex = _playlist.length - 1; // Loop to last song
    }
    await _loadCurrentTrack();
    await play();
  }

  @override
  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      // Handle seek error
    }
  }

  Future<void> loadPlaylist(List<Map<String, String>> songs, int startIndex) async {
    try {
      _currentIndex = startIndex;
      _playlist = songs.map((song) => MediaItem(
        id: song['url']!,
        title: song['title']!,
        artist: song['artist']!,
        artUri: Uri.parse('asset:///${song['imageUrl']!}'),
      )).toList();

      await _loadCurrentTrack();
      _setupPlayerListeners();
    } catch (e) {
      _updatePlaybackState(error: true);
    }
  }

  Future<void> _loadCurrentTrack() async {
    if (_playlist.isEmpty) return;
    
    try {
      final currentTrack = _playlist[_currentIndex];
      await _player.setAsset(currentTrack.id);
      
      mediaItem.add(currentTrack);
      _updatePlaybackState(playing: false);
    } catch (e) {
      _updatePlaybackState(error: true);
    }
  }

  void _setupPlayerListeners() {
    _player.positionStream.listen((position) {
      playbackState.add(playbackState.value.copyWith(
        updatePosition: position,
      ));
    });

    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        skipToNext(); // Auto-play next song
      }
    });
  }

  void _updatePlaybackState({bool? playing, bool stopped = false, bool error = false}) {
    playbackState.add(PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        playing == true ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      systemActions: {MediaAction.seek},
      playing: playing ?? false,
      processingState: error 
          ? AudioProcessingState.error 
          : stopped 
              ? AudioProcessingState.idle 
              : AudioProcessingState.ready,
      updatePosition: _player.position,
    ));
  }

  AudioPlayer get player => _player;
  List<MediaItem> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  
  void dispose() {
    _player.dispose();
  }
}