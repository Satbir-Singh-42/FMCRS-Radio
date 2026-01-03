import 'package:just_audio/just_audio.dart';
import '../utils/config.dart';
import 'package:audio_service/audio_service.dart';
import 'metadata_service.dart';

class RadioAudioService extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool isOnline = true;
  final MetadataService _metadataService = MetadataService();

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  String get currentTitle => _metadataService.currentTitle;
  String get currentArtist => _metadataService.currentArtist;

  RadioAudioService() {
    _init();
  }

  Future<void> _init() async {
    try {
      // Set up audio source with metadata
      final audioSource = AudioSource.uri(
        Uri.parse(Config.liveStreamUrl),
        tag: MediaItem(
          id: 'live_stream',
          album: '90.8 MHz FM-CRS',
          title: currentTitle,
          artist: currentArtist,
          artUri: Uri.parse(
            'file:///android_asset/flutter_assets/assets/logo.png',
          ),
        ),
        headers: {
          'Cache-Control': 'no-cache',
          'User-Agent': 'FMCRS-Radio-App/1.0',
        }, // Prevent caching for live stream
      );

      await _audioPlayer.setAudioSource(audioSource);
      await _audioPlayer.setVolume(1.0); // Set volume to maximum

      // Listen to player state changes
      _audioPlayer.playerStateStream.listen((state) {
        _isPlaying = state.playing;
        playbackState.add(
          playbackState.value.copyWith(
            controls: [
              MediaControl.skipToPrevious,
              _isPlaying ? MediaControl.pause : MediaControl.play,
              MediaControl.stop,
              MediaControl.skipToNext,
            ],
            systemActions: {
              MediaAction.seek,
              MediaAction.seekForward,
              MediaAction.seekBackward,
            },
            androidCompactActionIndices: [0, 1, 3],
            processingState: {
              ProcessingState.idle: AudioProcessingState.idle,
              ProcessingState.loading: AudioProcessingState.loading,
              ProcessingState.buffering: AudioProcessingState.buffering,
              ProcessingState.ready: AudioProcessingState.ready,
              ProcessingState.completed: AudioProcessingState.completed,
            }[state.processingState]!,
            playing: state.playing,
            updatePosition: _audioPlayer.position,
            bufferedPosition: _audioPlayer.bufferedPosition,
            speed: _audioPlayer.speed,
            queueIndex: 0,
          ),
        );
      });

      // Fetch initial metadata
      await _metadataService.fetchMetadata();

      // Set up periodic metadata fetching
      _metadataService.startPolling();
    } catch (e) {
      isOnline = false;
    }
  }

  @override
  Future<void> play() async {
    await _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
