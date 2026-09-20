import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ad_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/remaining_time.dart';
import '../../../data/services/rewarded_ad_service.dart';

class RemainingTimeCard extends ConsumerStatefulWidget {
  const RemainingTimeCard({super.key});

  @override
  ConsumerState<RemainingTimeCard> createState() => _RemainingTimeCardState();
}

class _RemainingTimeCardState extends ConsumerState<RemainingTimeCard> {
  final _adService = RewardedAdService();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _adService.preload();
  }

  String _format(int seconds) {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Future<void> _onPlusPressed() async {
    if (_busy) return;

    final watched = ref.read(adsWatchedTodayProvider);
    if (watched >= AdConfig.dailyAdLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Daily limit reached (${AdConfig.dailyAdLimit} ads/day)'),
          backgroundColor: AppColors.card,
        ),
      );
      return;
    }

    setState(() => _busy = true);

    final earned = await _adService.show();

    if (!mounted) return;
    setState(() => _busy = false);

    if (earned) {
      await ref
          .read(remainingTimeProvider.notifier)
          .addMinutes(AdConfig.rewardedBonusMinutes);
      await ref.read(adsWatchedTodayProvider.notifier).increment();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('+${AdConfig.rewardedBonusMinutes} minutes added'),
          backgroundColor: AppColors.accentGreen,
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad not available — try again in a moment'),
          backgroundColor: AppColors.card,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final remaining = ref.watch(remainingTimeProvider);
    final watched = ref.watch(adsWatchedTodayProvider);
    final atLimit = watched >= AdConfig.dailyAdLimit;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.access_time, color: AppColors.accent, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'REMAINING VPN TIME',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
              Text(
                _format(remaining),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _busy || atLimit ? null : _onPlusPressed,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _busy || atLimit
                        ? AppColors.textSecondary.withOpacity(0.4)
                        : AppColors.accent,
                  ),
                  child: _busy
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          atLimit ? Icons.block : Icons.add,
                          color: Colors.white,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
