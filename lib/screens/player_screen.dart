import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, music, _) {
        final song = music.currentSong;
        if (song == null) return const SizedBox();
        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0F),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF7C3AED).withOpacity(0.4),
                  const Color(0xFF0A0A0F),
                  const Color(0xFF0A0A0F),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.white, size: 32),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text('NOW PLAYING',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                letterSpacing: 3,
                                fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(
                            music.isFavorite(song)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: music.isFavorite(song)
                                ? const Color(0xFFFF6B35)
                                : Colors.white,
                          ),
                          onPressed: () => music.toggleFavorite(song),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF7C3AED).withOpacity(0.5),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: song.imageUrl.isNotEmpty
                            ? Image.network(song.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _defaultArt())
                            : _defaultArt(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Text(song.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Text(song.artist,
                            style: const TextStyle(
                                color: Colors.white60, fontSize: 16),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                            activeTrackColor: const Color(0xFFFF6B35),
                            inactiveTrackColor: Colors.white24,
                            thumbColor: const Color(0xFFFF6B35),
                            overlayColor:
                                const Color(0xFFFF6B35).withOpacity(0.2),
                          ),
                          child: Slider(
                            value: music.duration.inSeconds > 0
                                ? music.position.inSeconds
                                    .toDouble()
                                    .clamp(
                                        0,
                                        music.duration.inSeconds
                                            .toDouble())
                                : 0,
                            min: 0,
                            max: music.duration.inSeconds > 0
                                ? music.duration.inSeconds.toDouble()
                                : 1,
                            onChanged: (val) => music
                                .seek(Duration(seconds: val.toInt())),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_fmt(music.position),
                                  style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 12)),
                              Text(_fmt(music.duration),
                                  style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous_rounded,
                            color: Colors.white, size: 44),
                        onPressed: music.playPrevious,
                      ),
                      GestureDetector(
                        onTap:
                            music.isLoading ? null : music.togglePlay,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFF6B35),
                                Color(0xFF7C3AED)
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6B35)
                                    .withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: music.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2)
                              : Icon(
                                  music.isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next_rounded,
                            color: Colors.white, size: 44),
                        onPressed: music.playNext,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _defaultArt() => Container(
        color: const Color(0xFF1A1A2E),
        child: const Icon(Icons.music_note,
            color: Color(0xFF7C3AED), size: 80),
      );

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
