import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/servers_provider.dart';
import '../../data/services/vpn_controller.dart';
import 'widgets/feature_toggles_card.dart';
import 'widgets/power_button.dart';
import 'widgets/remaining_time_card.dart';
import 'widgets/server_selector_card.dart';
import 'widgets/world_map_painter.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpn = ref.watch(vpnControllerProvider);
    final serversAsync = ref.watch(serversProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => context.push('/settings'),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.support_agent, color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.chat_bubble_outline, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: WorldMapPainter())),
          Column(
            children: [
              const FeatureTogglesCard(),
              const Spacer(),
              serversAsync.when(
                data: (servers) {
                  final fastest =
                      servers.isEmpty ? null : servers.first;
                  return PowerButton(
                    vpn: vpn,
                    onTap: () {
                      if (vpn.server != null) {
                        ref.read(vpnControllerProvider.notifier).toggle(vpn.server);
                      } else {
                        ref.read(vpnControllerProvider.notifier).toggle(fastest);
                      }
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Server list failed:\n$e',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
              const Spacer(),
              const ServerSelectorCard(),
              const RemainingTimeCard(),
              const SizedBox(height: 24),
            ],
          ),
        ],
      ),
    );
  }
}
