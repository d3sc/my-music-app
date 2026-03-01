import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../application/music_player_service.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayerService>(
      builder: (context, player, _) {
        final music = player.currentMusic;

        if (music == null) {
          return const Scaffold(
            body: Center(child: Text("Tidak ada lagu diputar")),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(music.title)),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  music.title,
                  style: const TextStyle(fontSize: 22),
                ),

                const SizedBox(height: 8),

                Text(music.artist),

                const SizedBox(height: 30),

                StreamBuilder<Duration>(
                  stream: player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;

                    return StreamBuilder<Duration?>(
                      stream: player.durationStream,
                      builder: (context, snapshot2) {
                        final duration =
                            snapshot2.data ?? Duration.zero;

                        return ProgressBar(
                          progress: position,
                          total: duration,
                          onSeek: player.seek,
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 30),

                IconButton(
                  icon: Icon(
                    player.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 60,
                  ),
                  onPressed: () {
                    if (player.isPlaying) {
                      player.pause();
                    } else {
                      player.play(music);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}