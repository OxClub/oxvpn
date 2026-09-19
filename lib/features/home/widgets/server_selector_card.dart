import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class ServerSelectorCard extends StatelessWidget {
  const ServerSelectorCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        child: ListTile(
          onTap: () => context.push('/servers'),
          leading: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(color: AppColors.accent, width: 2),
            ),
            child: const Icon(Icons.bolt, color: AppColors.accent, size: 22),
          ),
          title: const Text('Fastest Server',
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          subtitle: const Text('Tap to choose location',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          trailing: const Icon(Icons.unfold_more, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
