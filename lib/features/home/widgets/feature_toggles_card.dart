import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class FeatureTogglesCard extends StatefulWidget {
  const FeatureTogglesCard({super.key});
  @override
  State<FeatureTogglesCard> createState() => _State();
}

class _State extends State<FeatureTogglesCard> {
  bool accelerate = true, adBlock = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Column(
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.bolt, color: AppColors.accent),
              title: const Text('Accelerate',
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
              subtitle: const Text('Lightning-fast internet speed.',
                  style: TextStyle(color: AppColors.textSecondary)),
              value: accelerate,
              activeColor: AppColors.accent,
              onChanged: (v) => setState(() => accelerate = v),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.block, color: AppColors.accent),
              title: const Text('AD Blocker',
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
              subtitle: const Text('Block ads for smoother browsing.',
                  style: TextStyle(color: AppColors.textSecondary)),
              value: adBlock,
              activeColor: AppColors.accent,
              onChanged: (v) => setState(() => adBlock = v),
            ),
          ],
        ),
      ),
    );
  }
}
