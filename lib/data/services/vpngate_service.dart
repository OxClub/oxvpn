import 'package:dio/dio.dart';
import '../models/vpn_server.dart';

class VpngateService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    responseType: ResponseType.plain,
  ));

  static const String _apiUrl = 'http://www.vpngate.net/api/iphone/';

  Future<List<VpnServer>> fetchServers() async {
    final res = await _dio.get<String>(_apiUrl);
    final raw = res.data ?? '';
    final lines = raw.split('\n');
    final servers = <VpnServer>[];
    for (final line in lines) {
      if (line.isEmpty) continue;
      if (line.startsWith('*') || line.startsWith('#')) continue;
      final parts = line.split(',');
      if (parts.length < 15) continue;
      try {
        servers.add(VpnServer.fromVpngate(parts));
      } catch (_) {
        // Skip malformed rows silently.
      }
    }
    // Sort fastest first
    servers.sort((a, b) => a.pingMs.compareTo(b.pingMs));
    return servers;
  }
}
