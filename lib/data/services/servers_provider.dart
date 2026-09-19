import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vpn_server.dart';

final serversProvider = FutureProvider<List<VpnServer>>((ref) async {
  final raw = await rootBundle.loadString('assets/mock_servers.json');
  final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();
  final rng = Random();
  return list.map((j) {
    j['pingMs'] = 20 + rng.nextInt(180);
    return VpnServer.fromJson(j);
  }).toList();
});
