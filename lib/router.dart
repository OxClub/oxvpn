import 'package:go_router/go_router.dart';
import 'features/home/home_screen.dart';
import 'features/servers/servers_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/debug/log_screen.dart';
import 'features/web/webview_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/servers', builder: (_, __) => const ServersScreen()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    GoRoute(path: '/debug', builder: (_, __) => const LogScreen()),
    GoRoute(
      path: '/web',
      builder: (_, state) {
        final q = state.uri.queryParameters;
        return WebViewScreen(
          title: q['title'] ?? '',
          assetPath: q['asset'] ?? 'assets/legal/terms.html',
        );
      },
    ),
  ],
);
