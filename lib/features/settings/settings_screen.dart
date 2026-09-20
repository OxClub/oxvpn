import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool killSwitch = false;
  bool autoConnect = false;
  String themeMode = 'Dark';
  String language = 'English';
  String protocol = 'OpenVPN';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      killSwitch = p.getBool('kill_switch') ?? false;
      autoConnect = p.getBool('auto_connect') ?? false;
      themeMode = p.getString('theme_mode') ?? 'Dark';
      language = p.getString('language') ?? 'English';
      protocol = p.getString('protocol') ?? 'OpenVPN';
    });
  }

  Future<void> _save(String key, Object value) async {
    final p = await SharedPreferences.getInstance();
    if (value is bool) await p.setBool(key, value);
    if (value is String) await p.setString(key, value);
  }

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
          _premiumBanner(context),
          const SizedBox(height: 8),
          _group([
            _tile('Write a review', Icons.rate_review_outlined, () async {
              final uri = Uri.parse('https://play.google.com/store/apps/details?id=com.oxclub.oxvpn');
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            }),
            _tile('Get Help', Icons.help_outline, () => _helpSheet(context)),
            _tile('Rate us', Icons.star_outline, () async {
              final uri = Uri.parse('market://details?id=com.oxclub.oxvpn');
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            }),
            _tile('Terms of use', Icons.description_outlined,
                () => context.push('/web?title=Terms%20of%20use&asset=assets/legal/terms.html')),
            _tile('Privacy Policy', Icons.privacy_tip_outlined,
                () => context.push('/web?title=Privacy%20Policy&asset=assets/legal/privacy.html')),
            _tile('Subscription Info', Icons.receipt_long_outlined,
                () => context.push('/web?title=Subscription%20Info&asset=assets/legal/subscription.html')),
          ]),
          const SizedBox(height: 16),
          _group([
            _switch('Kill switch', Icons.security, killSwitch, (v) {
              setState(() => killSwitch = v);
              _save('kill_switch', v);
            }),
            _switch('Auto-connect on untrusted Wi-Fi', Icons.wifi, autoConnect, (v) {
              setState(() => autoConnect = v);
              _save('auto_connect', v);
            }),
            _tile('Split tunneling', Icons.call_split, () => _splitTunnelSheet(context)),
            _picker('Protocol', Icons.settings_ethernet, protocol, ['OpenVPN', 'WireGuard'], (v) {
              setState(() => protocol = v);
              _save('protocol', v);
            }),
            _picker('Theme', Icons.dark_mode, themeMode, ['Dark', 'Light', 'System'], (v) {
              setState(() => themeMode = v);
              _save('theme_mode', v);
            }),
            _picker('Language', Icons.language, language, ['English', 'हिन्दी', 'Español', 'العربية'], (v) {
              setState(() => language = v);
              _save('language', v);
            }),
          ]),
          const SizedBox(height: 16),
          _group([
            _tile('Debug Log', Icons.bug_report, () => context.push('/debug')),
            _tile('Reset onboarding', Icons.restart_alt, () async {
              final p = await SharedPreferences.getInstance();
              await p.setBool('onboarding_done', false);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Onboarding will show on next launch')),
                );
              }
            }),
          ]),
          const SizedBox(height: 24),
          const _VersionFooter(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _premiumBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _comingSoon(context, 'Paywall'),
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

  Widget _group(List<Widget> items) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(children: items),
      );

  Widget _tile(String title, IconData icon, VoidCallback onTap) => ListTile(
        leading: Icon(icon, color: AppColors.accent, size: 22),
        title: Text(title,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
        trailing:
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
      );

  Widget _switch(String title, IconData icon, bool value, Function(bool) onChanged) =>
      SwitchListTile(
        secondary: Icon(icon, color: AppColors.accent, size: 22),
        title: Text(title,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
        value: value,
        activeColor: AppColors.accent,
        onChanged: onChanged,
      );

  Widget _picker(String title, IconData icon, String current, List<String> options,
      Function(String) onChanged) =>
      ListTile(
        leading: Icon(icon, color: AppColors.accent, size: 22),
        title: Text(title,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
        subtitle: Text(current,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        trailing:
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: () => showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.card,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options
                  .map((o) => ListTile(
                        title: Text(o,
                            style: const TextStyle(color: Colors.white)),
                        trailing: current == o
                            ? const Icon(Icons.check, color: AppColors.accent)
                            : null,
                        onTap: () {
                          onChanged(o);
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ),
          ),
        ),
      );

  void _helpSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Get Help',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('• Check your internet connection\n'
                '• Try a different server\n'
                '• Restart the app\n'
                '• Check Settings → Debug Log for details\n'
                '• Contact: support@oxvpn.example',
                style: TextStyle(color: Colors.white70, height: 1.6)),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _splitTunnelSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Split tunneling',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text(
                'Select which apps should bypass the VPN.\n\nComing in a future update.',
                style: TextStyle(color: Colors.white70, height: 1.6)),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon')),
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
