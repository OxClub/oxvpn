class AdConfig {
  AdConfig._();

  /// Google's official TEST banner ad unit.
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

  /// Google's official TEST rewarded ad unit.
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  /// Bonus minutes added per rewarded ad watch.
  static const int rewardedBonusMinutes = 60;

  /// Max rewarded ads per day.
  static const int dailyAdLimit = 5;
}
