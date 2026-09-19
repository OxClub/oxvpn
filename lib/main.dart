import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'data/services/vpn_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  container.read(vpnControllerProvider.notifier).init(
        appName: 'OxVPN',
        packageId: 'com.oxclub.oxvpn',
      );
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const OxVpnApp(),
    ),
  );
}
