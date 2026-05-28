import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, music, _) {
        final favorites = music.favorites;
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
                  child: const Text('Favorites',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900)),
                ),
              ),
              if (favorites.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_outline,
                            size: 80,
                            color: const Color(0xFFFF6B35)
                                .withOpacity(0.4)),
                        const SizedBox(height: 16),
                        const Text('Abhi koi favorite nahi!',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 16)),
                        const SizedBox(height: 8),
                        const Text('Song sunke ❤️ dabao',
                            style: TextStyle(
                                color: Colors.white38, fontSize: 13)),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: favorites.length,
                    itemBuilder: (context, i) {
                      final song = favorites[i];
                      final isPlaying =
                          music.currentSong?.id == song.id &&
                              music.isPlaying;
                      return GestureDetector(
                        onTap: () =>
                            music.playSong(song, queue: favorites),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: isPlaying
                                ? const Color(0xFF7C3AED)
                                    .withOpacity(0.2)
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
                                        errorBuilder: (_, __, ___) =>
                                            _defaultArt())
                                    : _defaultArt(),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
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
                                            color: Colors.white54,
                                            fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.favorite_rounded,
                                    color: Color(0xFFFF6B35)),
                                onPressed: () =>
                                    music.toggleFavorite(song),
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
                  ),
                ),
            ],
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
