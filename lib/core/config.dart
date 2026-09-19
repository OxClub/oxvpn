class AppConfig {
  AppConfig._();
  static const bool useRealVpnEngine = false;
  static const String serversEndpoint = 'https://config.oxvpn.example/servers.json';
  static const String termsUrl = 'https://oxvpn.example/terms';
  static const String privacyUrl = 'https://oxvpn.example/privacy';
  static const String subscriptionUrl = 'https://oxvpn.example/subscription';
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const String subscriptionProductId = 'ad_free_access';
  static const bool enableFirebase = false;
  static const bool enableCrashlytics = false;
  static const int rewardedAdBonusMinutes = 60;
  static const int rewardedAdsPerDayCap = 5;
  static const Duration connectSimulationDuration = Duration(seconds: 2);
}
