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

  factory Song.fromItunes(Map<String, dynamic> json) {
    final ms = json['trackTimeMillis'] ?? 0;
    final totalSec = (ms / 1000).round();
    final m = (totalSec ~/ 60).toString().padLeft(2, '0');
    final s = (totalSec % 60).toString().padLeft(2, '0');
    String image = json['artworkUrl100'] ?? '';
    image = image.replaceAll('100x100', '500x500');
    return Song(
      id: json['trackId']?.toString() ?? '',
      title: json['trackName'] ?? 'Unknown',
      artist: json['artistName'] ?? 'Unknown Artist',
      album: json['collectionName'] ?? '',
      imageUrl: image,
      audioUrl: json['previewUrl'] ?? '',
      duration: '$m:$s',
      language: json['primaryGenreName'] ?? '',
    );
  }
}
