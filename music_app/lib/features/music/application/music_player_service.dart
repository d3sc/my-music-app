import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../domain/music.dart';
import '../../../core/storage/secure_storage.dart';

class MusicPlayerService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  List<Music> _playlist = [];

  List<Music> get playlist => _playlist;

  Music? get currentMusic {
    final index = _player.currentIndex;
    if (index == null || index >= _playlist.length) return null;
    return _playlist[index];
  }

  bool get isPlaying => _player.playing;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  MusicPlayerService() {
    _init();
  }

  Future<void> _init() async {
    await _player.setLoopMode(LoopMode.all);

    _player.playerStateStream.listen((_) {
      notifyListeners();
    });

    _player.currentIndexStream.listen((_) {
      notifyListeners();
    });
  }

  Future<void> setPlaylist(List<Music> musics) async {
    _playlist = musics;

    if (_playlist.isEmpty) {
      debugPrint("Playlist kosong saat diset");
      return;
    }

    final token = await SecureStorage.getToken();

    final sources = musics.map((music) {
      return AudioSource.uri(
        Uri.parse(music.url),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
    }).toList();

    await _player.setAudioSource(
      ConcatenatingAudioSource(children: sources),
    );

    debugPrint("Playlist berhasil diset: ${_playlist.length}");
  }

  Future<void> play(Music music) async {
    // await setPlaylist();
    debugPrint("Playlist length: ${_playlist.length}");
    // debugPrint("Music ID: ${music}");
    debugPrint("Available IDs: ${_playlist.map((e) => e.id).toList()}");

    if (_playlist.isEmpty) {
      debugPrint("Playlist kosong!");
      return;
    }


    final index = _playlist.indexWhere((m) => m.id == music.id);

    if (index == -1) {
      debugPrint("Music tidak ditemukan di playlist");
      return;
    }

    await _player.seek(Duration.zero, index: index);
    await _player.play();
  }

  Future<void> pause() async => await _player.pause();
  Future<void> seek(Duration position) async => await _player.seek(position);
}