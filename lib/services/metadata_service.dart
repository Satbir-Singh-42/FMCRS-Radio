import 'dart:async';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/config.dart';

class MetadataService {
  static final MetadataService _instance = MetadataService._internal();
  factory MetadataService() => _instance;
  MetadataService._internal();

  final StreamController<Map<String, String>> _metadataController =
      StreamController<Map<String, String>>.broadcast();
  Stream<Map<String, String>> get metadataStream => _metadataController.stream;

  String _currentTitle = 'FM-CRS Live Radio';
  String _currentArtist = '90.8 MHz';

  String get currentTitle => _currentTitle;
  String get currentArtist => _currentArtist;

  Future<void> fetchMetadata() async {
    try {
      final response = await http.get(Uri.parse(Config.metadataUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Parse Icecast metadata
        final rawSources = data['icestats']['source'];
        List sources;
        if (rawSources is List) {
          sources = rawSources;
        } else if (rawSources is Map) {
          sources = [rawSources];
        } else {
          sources = [];
        }
        if (sources.isNotEmpty) {
          // Use the first source (or find the main stream)
          final source = sources.firstWhere(
            (s) => s['listenurl'] != null && s['listenurl'].contains('/stream'),
            orElse: () => sources[0],
          );
          final title = source['title'] ?? 'Current Song';
          // Split title into artist and song if possible
          if (title.contains(' - ')) {
            final parts = title.split(' - ');
            _currentArtist = parts[0].trim();
            _currentTitle = parts[1].trim();
          } else {
            _currentTitle = title;
            _currentArtist = 'Artist';
          }

          // Emit metadata update through stream
          _metadataController.add({
            'title': _currentTitle,
            'artist': _currentArtist,
          });
          developer.log('Metadata loaded: $_currentTitle by $_currentArtist');
        } else {
          developer.log('No sources found in metadata');
        }
      } else {
        developer.log('Failed to fetch metadata: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error fetching metadata: $e');
      // Keep current metadata if fetch fails
    }
  }

  void startPolling() {
    // Poll metadata every 5 seconds for faster updates
    Future.delayed(const Duration(seconds: 5), () {
      fetchMetadata();
      startPolling();
    });
  }
}
