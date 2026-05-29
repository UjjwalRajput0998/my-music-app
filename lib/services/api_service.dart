import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/song.dart';

class ApiService {
  static final YoutubeExplode _yt = YoutubeExplode();

  static Future<List<Song>> searchSongs(String query) async {
    try {
      final results = await _yt.search.search(query);
      return results
          .take(20)
          .map((v) => Song.fromYoutube(v))
          .toList();
    } catch (e) {
      print('Search error: $e');
      return [];
    }
  }

  static Future<String> getAudioUrl(String videoId) async {
    try {
      final manifest = await _yt.videos.streamsClient
          .getManifest(videoId);
      final audioStream = manifest.audioOnly.withHighestBitrate();
      return audioStream.url.toString();
    } catch (e) {
      print('Audio URL error: $e');
      return '';
    }
  }

  static Future<List<Song>> getTrending(String language) async {
    final queries = {
      'hindi': 'top bollywood songs 2024',
      'punjabi': 'top punjabi songs 2024',
      'english': 'top english hits 2024',
      'bhojpuri': 'top bhojpuri songs 2024',
    };
    return await searchSongs(
        queries[language] ?? 'top songs 2024');
  }

  static Future<List<Song>> get80sSongs(String language) async {
    final queries = {
      'hindi': 'bollywood 80s 90s classic hits',
      'english': 'english 80s classic hits',
      'punjabi': 'punjabi old classic songs',
      'bhojpuri': 'bhojpuri purane superhit',
    };
    return await searchSongs(
        queries[language] ?? '80s classic songs');
  }
}
