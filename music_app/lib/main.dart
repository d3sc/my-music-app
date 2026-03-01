import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'features/music/application/music_player_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider<MusicPlayerService>(
      create: (_) => MusicPlayerService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
    );
  }
}