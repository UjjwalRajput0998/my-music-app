import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../services/api_service.dart';
import '../providers/music_provider.dart';
import '../widgets/mini_player.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedLanguage = 'hindi';
  List<Song> _trendingSongs = [];
  List<Song> _classicSongs = [];
  bool _isLoading = true;

  final List<Map<String, String>> _languages = [
    {'key': 'hindi', 'label': '🇮🇳 Hindi'},
    {'key': 'punjabi', 'label': '🎵 Punjabi'},
    {'key': 'english', 'label': '🌍 English'},
    {'key': 'bhojpuri', 'label': '🎶 Bhojpuri'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    setState(() => _isLoading = true);
    final trending = await ApiService.getTrending(_selectedLanguage);
    final classics = await ApiService.get80sSongs(_selectedLanguage);
    setState(() {
      _trendingSongs = trending;
      _classicSongs = classics;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHome(),
          const SearchScreen(),
          const FavoritesScreen(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: const Color(0xFF7C3AED).withOpacity(0.3),
              labelTextStyle: MaterialStateProperty.all(
                const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
            child: NavigationBar(
              backgroundColor: const Color(0xFF0D0D1A),
              selectedIndex: _selectedIndex,
              onDestinationSelected: (i) =>
                  setState(() => _selectedIndex = i),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, color: Colors.white54),
                  selectedIcon: Icon(Icons.home_rounded,
                      color: Color(0xFFFF6B35)),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.search_outlined, color: Colors.white54),
                  selectedIcon: Icon(Icons.search_rounded,
                      color: Color(0xFFFF6B35)),
                  label: 'Search',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_outline, color: Colors.white54),
                  selectedIcon: Icon(Icons.favorite_rounded,
                      color: Color(0xFFFF6B35)),
                  label: 'Favorites',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHome() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Good Vibes Only 🎵',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 4),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFFF6B35), Color(0xFF7C3AED)],
                        ).createShader(bounds),
                        child: const Text('BeatBox',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1)),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF7C3AED).withOpacity(0.3),
                          const Color(0xFFFF6B35).withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: const Icon(Icons.headphones_rounded,
                        color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _languages.length,
                itemBuilder: (context, i) {
                  final lang = _languages[i];
                  final isSelected = _selectedLanguage == lang['key'];
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedLanguage = lang['key']!);
                      _loadSongs();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: isSelected
                            ? const LinearGradient(colors: [
                                Color(0xFFFF6B35),
                                Color(0xFF7C3AED)
                              ])
                            : null,
                        color: isSelected
                            ? null
                            : const Color(0xFF1A1A2E),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.white24,
                        ),
                      ),
                      child: Text(lang['label']!,
                          style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white60,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 13)),
                    ),
                  );
                },
              ),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                    color: Color(0xFFFF6B35)),
              ),
            )
          else ...[
            _sectionHeader('🔥 Trending Now'),
            _songsList(_trendingSongs),
            _sectionHeader('🎸 80s & 90s Classics'),
            _songsList(_classicSongs),
          ],
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _songsList(List<Song> songs) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: songs.length,
          itemBuilder: (context, i) {
            final song = songs[i];
            return GestureDetector(
              onTap: () => context
                  .read<MusicProvider>()
                  .playSong(song, queue: songs),
              child: Container(
                width: 150,
                margin: const EdgeInsets.only(right: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: song.imageUrl.isNotEmpty
                          ? Image.network(song.imageUrl,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _defaultArt())
                          : _defaultArt(),
                    ),
                    const SizedBox(height: 8),
                    Text(song.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(song.artist,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _defaultArt() => Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF1A1A2E),
        ),
        child: const Icon(Icons.music_note,
            color: Color(0xFF7C3AED), size: 40),
      );
}
