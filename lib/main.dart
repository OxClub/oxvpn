import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app.dart';
import 'data/services/vpn_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Mobile Ads SDK
  await MobileAds.instance.initialize();

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
