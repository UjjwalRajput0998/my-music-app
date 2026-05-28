import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../screens/player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, music, _) {
        final song = music.currentSong;
        if (song == null) return const SizedBox();
        return GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PlayerScreen())),
          child: Container(
            margin: const EdgeInsets.all(12),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF1A0A2E), Color(0xFF2D1B4E)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: song.imageUrl.isNotEmpty
                      ? Image.network(
                          song.imageUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _defaultArt(),
                        )
                      : _defaultArt(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(song.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1),
                      Text(song.artist,
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    music.isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_filled_rounded,
                    color: const Color(0xFFFF6B35),
                    size: 36,
                  ),
                  onPressed: music.togglePlay,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded,
                      color: Colors.white70, size: 28),
                  onPressed: music.playNext,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _defaultArt() => Container(
        width: 48,
        height: 48,
        color: const Color(0xFF1A1A2E),
        child: const Icon(Icons.music_note,
            color: Color(0xFF7C3AED), size: 24),
      );
}
