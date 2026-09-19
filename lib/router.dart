import 'package:go_router/go_router.dart';
import 'features/home/home_screen.dart';
import 'features/servers/servers_screen.dart';
import 'features/settings/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/servers', builder: (_, __) => const ServersScreen()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
  ],
);
