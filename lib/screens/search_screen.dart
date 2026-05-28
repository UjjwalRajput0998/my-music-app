import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../services/api_service.dart';
import '../providers/music_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<Song> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });
    final results = await ApiService.searchSongs(query);
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFF7C3AED)],
              ).createShader(bounds),
              child: const Text('Search',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFF1A1A2E),
                border: Border.all(
                    color: const Color(0xFF7C3AED).withOpacity(0.3)),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Song, artist ya album...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: Color(0xFF7C3AED)),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear,
                              color: Colors.white54),
                          onPressed: () {
                            _controller.clear();
                            setState(() {
                              _results = [];
                              _hasSearched = false;
                            });
                          })
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16),
                ),
                onChanged: (v) => setState(() {}),
                onSubmitted: _search,
                textInputAction: TextInputAction.search,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Expanded(
              child: Center(
                  child: CircularProgressIndicator(
                      color: Color(0xFFFF6B35))),
            )
          else if (!_hasSearched)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.music_note_rounded,
                        size: 80,
                        color:
                            const Color(0xFF7C3AED).withOpacity(0.5)),
                    const SizedBox(height: 16),
                    const Text('Koi bhi song dhundho!',
                        style: TextStyle(
                            color: Colors.white54, fontSize: 16)),
                    const SizedBox(height: 8),
                    const Text(
                        'Hindi • Punjabi • English • Bhojpuri',
                        style: TextStyle(
                            color: Colors.white38, fontSize: 13)),
                  ],
                ),
              ),
            )
          else if (_results.isEmpty)
            const Expanded(
              child: Center(
                child: Text('Koi result nahi mila 😔',
                    style: TextStyle(
                        color: Colors.white54, fontSize: 16)),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _results.length,
                itemBuilder: (context, i) =>
                    _buildSongTile(_results[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSongTile(Song song) {
    return Consumer<MusicProvider>(
      builder: (context, music, _) {
        final isPlaying =
            music.currentSong?.id == song.id && music.isPlaying;
        return GestureDetector(
          onTap: () => music.playSong(song, queue: _results),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isPlaying
                  ? const Color(0xFF7C3AED).withOpacity(0.2)
                  : const Color(0xFF1A1A2E),
              border: Border.all(
                color: isPlaying
                    ? const Color(0xFF7C3AED)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: song.imageUrl.isNotEmpty
                      ? Image.network(song.imageUrl,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _defaultArt())
                      : _defaultArt(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(song.title,
                          style: TextStyle(
                              color: isPlaying
                                  ? const Color(0xFFFF6B35)
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(song.artist,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(song.duration,
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                ),
                Icon(
                  isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_outline_rounded,
                  color: isPlaying
                      ? const Color(0xFFFF6B35)
                      : Colors.white38,
                  size: 32,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _defaultArt() => Container(
        width: 56,
        height: 56,
        color: const Color(0xFF1A1A2E),
        child: const Icon(Icons.music_note,
            color: Color(0xFF7C3AED), size: 24),
      );
}
