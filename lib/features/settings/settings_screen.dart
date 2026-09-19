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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.premiumGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium, color: Colors.white, size: 36),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Buy Ad-Free Access',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            )),
                        SizedBox(height: 4),
                        Text('Get Boosted & Ad-free VPN security.',
                            style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ),
          ),
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
            ('Protocol (WireGuard)', Icons.settings_ethernet),
            ('Theme (Dark)', Icons.dark_mode),
            ('Language (English)', Icons.language),
          ]),
          const SizedBox(height: 24),
          const _VersionFooter(),
          const SizedBox(height: 24),
        ],
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
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () {},
          );
        }).toList(),
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
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        );
      },
    );
  }
}
