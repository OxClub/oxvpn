import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/servers_provider.dart';
import '../../data/services/vpn_controller.dart';
import 'widgets/server_tile.dart';

enum ServerTab { all, free, premium }

class ServersScreen extends ConsumerStatefulWidget {
  const ServersScreen({super.key});
  @override
  ConsumerState<ServersScreen> createState() => _State();
}

class _State extends ConsumerState<ServersScreen> {
  ServerTab tab = ServerTab.all;
  String query = '';

  @override
  Widget build(BuildContext context) {
    final serversAsync = ref.watch(serversProvider);
    return Scaffold(
      backgroundColor: AppColors.serversBg,
      appBar: AppBar(
        backgroundColor: AppColors.serversBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Servers', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Done',
                style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: serversAsync.when(
        data: (servers) {
          var filtered = servers.where((s) {
            switch (tab) {
              case ServerTab.free:
                if (!s.isFree) return false;
              case ServerTab.premium:
                if (s.isFree) return false;
              case ServerTab.all:
                break;
            }
            if (query.isEmpty) return true;
            final q = query.toLowerCase();
            return s.country.toLowerCase().contains(q) ||
                s.city.toLowerCase().contains(q);
          }).toList();

          return Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: ServerTab.values.map((t) {
                    final selected = t == tab;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => tab = t),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.accent : AppColors.input,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            t.name[0].toUpperCase() + t.name.substring(1),
                            style: TextStyle(
                              color: selected ? Colors.white : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (v) => setState(() => query = v),
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.input,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text('No servers found',
                            style: TextStyle(color: AppColors.textSecondary)),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final s = filtered[i];
                          final current = ref.watch(vpnControllerProvider);
                          final selected = current.server?.id == s.id;
                          return ServerTile(
                            server: s,
                            selected: selected,
                            onTap: () async {
                              await ref
                                  .read(vpnControllerProvider.notifier)
                                  .connect(s);
                              if (context.mounted) context.pop();
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: AppColors.textSecondary)),
        ),
      ),
    );
  }
}
