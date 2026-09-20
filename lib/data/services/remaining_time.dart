import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kBalanceSeconds = 'vpn_balance_seconds';
const _kAdCountDate = 'rewarded_ad_date';
const _kAdCountToday = 'rewarded_ad_count_today';

/// VPN balance in seconds remaining (0 = nothing left).
final remainingTimeProvider =
    StateNotifierProvider<RemainingTimeController, int>((_) => RemainingTimeController());

class RemainingTimeController extends StateNotifier<int> {
  RemainingTimeController() : super(0) {
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    state = p.getInt(_kBalanceSeconds) ?? 0;
  }

  Future<void> _persist() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kBalanceSeconds, state);
  }

  Future<void> addMinutes(int minutes) async {
    state = state + minutes * 60;
    await _persist();
  }

  Future<void> tickSecond() async {
    if (state <= 0) return;
    state = state - 1;
    // Persist only every 10 seconds to reduce writes
    if (state % 10 == 0) await _persist();
  }

  Future<void> reset() async {
    state = 0;
    await _persist();
  }
}

/// Tracks how many rewarded ads were watched today.
final adsWatchedTodayProvider =
    StateNotifierProvider<AdsWatchedController, int>((_) => AdsWatchedController());

class AdsWatchedController extends StateNotifier<int> {
  AdsWatchedController() : super(0) {
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final savedDate = p.getString(_kAdCountDate);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (savedDate == today) {
      state = p.getInt(_kAdCountToday) ?? 0;
    } else {
      state = 0;
      await p.setString(_kAdCountDate, today);
      await p.setInt(_kAdCountToday, 0);
    }
  }

  Future<void> increment() async {
    state = state + 1;
    final p = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await p.setString(_kAdCountDate, today);
    await p.setInt(_kAdCountToday, state);
  }
}
