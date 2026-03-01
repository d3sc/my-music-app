import 'package:flutter/material.dart';
import '../data/music_repository.dart';
import 'music_page.dart';
import '../application/music_player_service.dart';
import 'package:provider/provider.dart';
import 'widget/mini_player.dart';

class MusicCollectionPage extends StatelessWidget {
  const MusicCollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MusicRepository();
    final musicService =
        Provider.of<MusicPlayerService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Music List")),
      body: Stack(
        children: [
          FutureBuilder(
            future: repository.getAllMusic(),
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }

              final musics = snapshot.data!;

              // add playlist
              musicService.setPlaylist(musics);

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 130),
                itemCount: musics.length,
                itemBuilder: (context, index) {
                  final music = musics[index];

                  return Consumer<MusicPlayerService>(
                    builder: (context, player, _) {

                      final isCurrent =
                          player.currentMusic?.id == music.id;
                      final isPlaying =
                          isCurrent && player.isPlaying;

                      return Card(
                        child: ListTile(
                          onTap: () {
                            if (player.currentMusic?.id != music.id) {
                              player.play(music);
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const MusicPlayerPage(),
                              ),
                            );
                          },

                          title: Text(music.title),
                          subtitle: Text(music.artist),

                          trailing: GestureDetector(
                            onTap: () {
                              if (isCurrent && isPlaying) {
                                player.pause();
                              } else {
                                player.play(music);
                              }
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}