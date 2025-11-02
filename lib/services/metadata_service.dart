import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/config.dart';

class MetadataService {
  Future<Map<String, String>> fetchMetadata() async {
    try {
      final response = await http.get(Uri.parse(Config.metadataUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final source = data['icestats']['source'];
        if (source != null && source.isNotEmpty) {
          return {
            'title': source[0]['title'] ?? 'Current Song',
            'artist': source[0]['artist'] ?? 'Artist Name',
          };
        }
      }
    } catch (e) {
      // Handle error
    }
    return {'title': 'Loading...', 'artist': 'Artist'};
  }
}
