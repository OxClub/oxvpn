import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: [
          _banner(context),
          const SizedBox(height: 8),
          _group(context, [
            ('Write a review', Icons.rate_review_outlined),
            ('Get Help', Icons.help_outline),
            ('Rate us', Icons.star_outline),
            ('Terms of use', Icons.description_outlined),
            ('Privacy Policy', Icons.privacy_tip_outlined),
            ('Subscription Info', Icons.receipt_long_outlined),
          ]),
          const SizedBox(height: 16),
          _group(context, [
            ('Kill switch', Icons.security),
            ('Auto-connect on untrusted Wi-Fi', Icons.wifi),
            ('Split tunneling', Icons.call_split),
            ('Protocol (OpenVPN)', Icons.settings_ethernet),
            ('Theme (Dark)', Icons.dark_mode),
            ('Language (English)', Icons.language),
          ]),
          const SizedBox(height: 16),
          _debugGroup(context),
          const SizedBox(height: 24),
          const _VersionFooter(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _banner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _snack(context, 'Paywall — coming soon'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.premiumGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.workspace_premium, color: Colors.white, size: 36),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Buy Ad-Free Access',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    SizedBox(height: 4),
                    Text('Get Boosted & Ad-free VPN security.',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _group(BuildContext context, List<(String, IconData)> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: items.map((item) {
          return ListTile(
            leading: Icon(item.$2, color: AppColors.accent, size: 22),
            title: Text(item.$1,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 15)),
            trailing: const Icon(Icons.chevron_right,
                color: AppColors.textSecondary),
            onTap: () => _snack(context, '${item.$1} — tapped'),
          );
        }).toList(),
      ),
    );
  }

  Widget _debugGroup(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: const Icon(Icons.bug_report,
            color: AppColors.accent, size: 22),
        title: const Text('Debug Log',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
        trailing: const Icon(Icons.chevron_right,
            color: AppColors.textSecondary),
        onTap: () => context.push('/debug'),
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.card,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _VersionFooter extends StatelessWidget {
  const _VersionFooter();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (_, snap) {
        final v = snap.data;
        return Center(
          child: Text(
            v == null ? 'Version' : 'Version ${v.version} (${v.buildNumber})',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12),
          ),
        );
      },
    );
  }
}
