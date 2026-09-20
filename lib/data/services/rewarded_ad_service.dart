import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/ad_config.dart';

class RewardedAdService {
  RewardedAd? _ad;
  bool _loading = false;

  bool get isReady => _ad != null;

  Future<void> preload() async {
    if (_ad != null || _loading) return;
    _loading = true;
    try {
      await RewardedAd.load(
        adUnitId: AdConfig.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _ad = ad;
            _loading = false;
            debugPrint('OXVPN_AD: rewarded loaded');
          },
          onAdFailedToLoad: (err) {
            _loading = false;
            debugPrint('OXVPN_AD: load failed ${err.message}');
          },
        ),
      );
    } catch (e) {
      _loading = false;
      debugPrint('OXVPN_AD: exception $e');
    }
  }

  /// Shows the ad. Returns true if the user earned the reward.
  Future<bool> show() async {
    if (_ad == null) {
      await preload();
      await Future.delayed(const Duration(milliseconds: 500));
      if (_ad == null) return false;
    }

    final completer = Completer<bool>();
    _ad!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ad = null;
        preload();
        if (!completer.isCompleted) completer.complete(false);
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _ad = null;
        preload();
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    _ad!.show(onUserEarnedReward: (ad, reward) {
      if (!completer.isCompleted) completer.complete(true);
    });

    return completer.future;
  }
}

