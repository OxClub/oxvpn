import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vpn_server.dart';
import 'vpngate_service.dart';

final vpngateServiceProvider = Provider<VpngateService>((_) => VpngateService());

/// Sorted by real ping, fastest first.
final serversProvider = FutureProvider<List<VpnServer>>((ref) async {
  final service = ref.watch(vpngateServiceProvider);
  final servers = await service.fetchServers();
  if (servers.isEmpty) return servers;

  // Measure real TCP latency to the top 30 servers only
  final toPing = servers.take(30).toList();
  final pings = await Future.wait(toPing.map(_measureLatency));
  for (var i = 0; i < toPing.length; i++) {
    toPing[i] = toPing[i].copyWith(pingMs: pings[i]);
  }
  toPing.sort((a, b) => a.pingMs.compareTo(b.pingMs));

  // Append the rest with their API-reported ping
  final rest = servers.skip(30).toList()
    ..sort((a, b) => a.pingMs.compareTo(b.pingMs));

  return [...toPing, ...rest];
});

/// Measures TCP connect time to the server's IP:port.
/// Times out at 2 seconds and returns 9999 for unreachable.
Future<int> _measureLatency(VpnServer server) async {
  final stopwatch = Stopwatch()..start();
  try {
    final socket = await Socket.connect(
      server.ip,
      server.port,
      timeout: const Duration(seconds: 2),
    );
    stopwatch.stop();
    socket.destroy();
    return stopwatch.elapsedMilliseconds;
  } catch (_) {
    return 9999;
  }
}
