import 'package:go_router/go_router.dart';
import 'package:music_app/features/music/presentation/music_collection_page.dart';
import 'features/auth/presentation/login_page.dart';

final router = GoRouter(
  initialLocation: "/login", // ini bagus tetap ada
  routes: [
    GoRoute(
      path: "/",
      redirect: (context, state) => "/login",
    ),
    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: "/music",
      builder: (context, state) => const MusicCollectionPage(),
    ),
  ],
);