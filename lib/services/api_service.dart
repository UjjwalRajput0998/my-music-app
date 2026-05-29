import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class ApiService {
  static const String baseUrl = 'https://itunes.apple.com/search';

  static Future<List<Song>> searchSongs(String query) async {
    try {
      final uri = Uri.parse(
          '$baseUrl?term=${Uri.encodeComponent(query)}&media=music&limit=20&country=in');
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List? ?? [];
        return results
            .map((s) => Song.fromItunes(s))
            .where((s) => s.audioUrl.isNotEmpty)
            .toList();
      }
    } catch (e) {
      print('Error: $e');
    }
    return [];
  }

  static Future<List<Song>> getTrending(String language) async {
    final queries = {
      'hindi': 'bollywood hindi hits 2024',
      'punjabi': 'punjabi hits 2024',
      'english': 'top english hits 2024',
      'bhojpuri': 'bhojpuri hits 2024',
    };
    return await searchSongs(queries[language] ?? 'top songs 2024');
  }

  static Future<List<Song>> get80sSongs(String language) async {
    final queries = {
      'hindi': 'bollywood 80s 90s classic',
      'english': 'english 80s classic hits',
      'punjabi': 'punjabi classic songs',
      'bhojpuri': 'bhojpuri classic songs',
    };
    return await searchSongs(queries[language] ?? '80s classic songs');
  }
}
