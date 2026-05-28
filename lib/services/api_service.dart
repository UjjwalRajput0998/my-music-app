import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class ApiService {
  static const String baseUrl = 'https://saavn.dev/api';

  static Future<List<Song>> searchSongs(String query) async {
    try {
      final uri = Uri.parse(
          '$baseUrl/search/songs?query=${Uri.encodeComponent(query)}&limit=20');
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data']?['results'] as List? ?? [];
        return results
            .map((s) => Song.fromJson(s))
            .where((s) => s.audioUrl.isNotEmpty)
            .toList();
      }
    } catch (e) {
      print('Search error: $e');
    }
    return [];
  }

  static Future<List<Song>> getTrending(String language) async {
    final queries = {
      'hindi': 'top hindi songs 2024',
      'punjabi': 'top punjabi hits 2024',
      'english': 'top english hits 2024',
      'bhojpuri': 'top bhojpuri songs 2024',
    };
    return await searchSongs(queries[language] ?? 'top songs 2024');
  }

  static Future<List<Song>> get80sSongs(String language) async {
    final queries = {
      'hindi': 'hindi 80s 90s classic hits',
      'english': 'english 80s classic hits',
      'punjabi': 'punjabi old classic songs',
      'bhojpuri': 'bhojpuri purane superhit gane',
    };
    return await searchSongs(queries[language] ?? '80s classic songs');
  }
}
