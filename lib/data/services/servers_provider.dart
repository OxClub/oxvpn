import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vpn_server.dart';
import 'vpngate_service.dart';

final vpngateServiceProvider = Provider<VpngateService>((_) => VpngateService());

final serversProvider = FutureProvider<List<VpnServer>>((ref) async {
  final service = ref.watch(vpngateServiceProvider);
  return service.fetchServers();
});
