class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String imageUrl;
  final String audioUrl;
  final String duration;
  final String language;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.imageUrl,
    required this.audioUrl,
    required this.duration,
    required this.language,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    String audioUrl = '';
    if (json['downloadUrl'] != null && json['downloadUrl'] is List) {
      final urls = json['downloadUrl'] as List;
      if (urls.isNotEmpty) audioUrl = urls.last['url'] ?? '';
    }
    String imageUrl = '';
    if (json['image'] != null && json['image'] is List) {
      final images = json['image'] as List;
      if (images.isNotEmpty) imageUrl = images.last['url'] ?? '';
    }
    return Song(
      id: json['id']?.toString() ?? '',
      title: _clean(json['name']?.toString() ?? 'Unknown'),
      artist: _clean(
        json['artists']?['primary'] != null
            ? (json['artists']['primary'] as List)
                .map((a) => a['name']).join(', ')
            : 'Unknown Artist',
      ),
      album: _clean(json['album']?['name']?.toString() ?? ''),
      imageUrl: imageUrl,
      audioUrl: audioUrl,
      duration: _fmt(
          int.tryParse(json['duration']?.toString() ?? '0') ?? 0),
      language: json['language']?.toString() ?? '',
    );
  }

  static String _clean(String t) => t
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#039;', "'");

  static String _fmt(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sc = (s % 60).toString().padLeft(2, '0');
    return '$m:$sc';
  }
}
