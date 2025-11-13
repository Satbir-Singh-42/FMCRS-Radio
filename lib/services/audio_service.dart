import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/config.dart';

class RadioAudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String _currentTitle = 'Loading...';
  String _currentArtist = 'Artist';
  bool isOnline = true;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  String get currentTitle => _currentTitle;
  String get currentArtist => _currentArtist;
  // isOnline is public field, no getter needed

  Future<void> init() async {
    try {
      await _audioPlayer.setUrl(Config.liveStreamUrl);
      _audioPlayer.playerStateStream.listen((state) {
        _isPlaying = state.playing;
      });

      // Fetch initial metadata
      await _fetchMetadata();

      // Set up periodic metadata fetching
      _startMetadataPolling();
    } catch (e) {
      isOnline = false;
      _currentTitle = 'Station Offline';
      _currentArtist = 'Please try again later';
    }
  }

  Future<void> _fetchMetadata() async {
    try {
      final response = await http.get(Uri.parse(Config.metadataUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Parse Icecast metadata - find the schlagerinstrumental source
        final sources = data['icestats']['source'];
        if (sources != null && sources.isNotEmpty) {
          // Find the source for schlagerinstrumental
          final instrumentalSource = sources.firstWhere(
            (source) =>
                source['listenurl'] != null &&
                source['listenurl'].contains('schlagerinstrumental'),
            orElse: () => null,
          );
          if (instrumentalSource != null) {
            final title = instrumentalSource['title'] ?? 'Current Song';
            // Split title into artist and song if possible
            if (title.contains(' - ')) {
              final parts = title.split(' - ');
              _currentArtist = parts[0].trim();
              _currentTitle = parts[1].trim();
            } else {
              _currentTitle = title;
              _currentArtist = 'Artist';
            }
          }
        }
      }
    } catch (e) {
      // Keep current metadata if fetch fails
    }
  }

  void _startMetadataPolling() {
    // Poll metadata every 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      _fetchMetadata();
      _startMetadataPolling();
    });
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
