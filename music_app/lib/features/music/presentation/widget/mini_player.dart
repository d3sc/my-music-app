import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../../application/music_player_service.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayerService>(
      builder: (context, player, _) {
        final music = player.currentMusic;

        if (music == null) return const SizedBox();

        return Container(
          padding: const EdgeInsets.all(12),
          height: 120,
          color: Colors.grey[900],
          child: Column(
            children: [
              const Text(
                "Anda sedang memutar",
                style: TextStyle(color: Colors.white70),
              ),

              Text(
                music.title,
                style: const TextStyle(color: Colors.white),
              ),

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
                        onSeek: (d) {},
                      );
                    },
                  );
                },
              ),

              IconButton(
                icon: Icon(
                  player.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (player.isPlaying) {
                    player.pause();
                  } else {
                    player.play(music);
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}