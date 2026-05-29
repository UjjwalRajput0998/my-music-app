import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../models/song.dart';
import '../services/api_service.dart';

class MusicProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  Song? _currentSong;
  List<Song> _queue = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  List<Song> _favorites = [];

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  Duration get position => _position;
  Duration get duration => _duration;
  List<Song> get favorites => _favorites;

  MusicProvider() {
    _initAudioSession();
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });
    _player.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });
    _player.durationStream.listen((dur) {
      _duration = dur ?? Duration.zero;
      notifyListeners();
    });
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        playNext();
      }
    });
  }

  Future<void> _initAudioSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(
          const AudioSessionConfiguration.music());
    } catch (e) {
      print('Session error: $e');
    }
  }

  Future<void> playSong(Song song, {List<Song>? queue}) async {
    try {
      _isLoading = true;
      _currentSong = song;
      if (queue != null && queue.isNotEmpty) {
        _queue = queue;
        _currentIndex = queue.indexWhere((s) => s.id == song.id);
        if (_currentIndex == -1) _currentIndex = 0;
      }
      notifyListeners();

      if (song.audioUrl.isEmpty) {
        final url = await ApiService.getAudioUrl(song.id);
        song.audioUrl = url;
      }

      if (song.audioUrl.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      await _player.setUrl(song.audioUrl);
      await _player.play();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      print('Play error: $e');
      notifyListeners();
    }
  }

  Future<void> togglePlay() async {
    try {
      _isPlaying ? await _player.pause() : await _player.play();
    } catch (e) {}
  }

  Future<void> playNext() async {
    if (_queue.isEmpty) return;
    if (_currentIndex < _queue.length - 1) {
      _currentIndex++;
      await playSong(_queue[_currentIndex]);
    }
  }

  Future<void> playPrevious() async {
    if (_queue.isEmpty) return;
    if (_position.inSeconds > 3) {
      await _player.seek(Duration.zero);
    } else if (_currentIndex > 0) {
      _currentIndex--;
      await playSong(_queue[_currentIndex]);
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  void toggleFavorite(Song song) {
    if (_favorites.any((s) => s.id == song.id)) {
      _favorites.removeWhere((s) => s.id == song.id);
    } else {
      _favorites.add(song);
    }
    notifyListeners();
  }

  bool isFavorite(Song song) =>
      _favorites.any((s) => s.id == song.id);

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
