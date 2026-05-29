class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String imageUrl;
  String audioUrl;
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

  factory Song.fromYoutube(dynamic video) {
    String thumb = '';
    try {
      thumb = video.thumbnails.highResUrl ?? '';
    } catch (e) {}

    String dur = '0:00';
    try {
      final d = video.duration;
      if (d != null) {
        final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
        final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
        dur = '$m:$s';
      }
    } catch (e) {}

    return Song(
      id: video.id.value,
      title: video.title ?? 'Unknown',
      artist: video.author ?? 'Unknown',
      album: '',
      imageUrl: thumb,
      audioUrl: '',
      duration: dur,
      language: '',
    );
  }
}
