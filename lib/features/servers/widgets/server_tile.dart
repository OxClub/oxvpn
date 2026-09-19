import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/vpn_server.dart';

class ServerTile extends StatelessWidget {
  final VpnServer server;
  final bool selected;
  final VoidCallback onTap;
  const ServerTile({
    super.key,
    required this.server,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44, height: 44,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.input,
        ),
        child: Text(server.countryCode,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            )),
      ),
      title: Text(server.country,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          )),
      subtitle: Text(server.city,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (server.isFree)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text('Free',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          const SizedBox(width: 8),
          Text('${server.pingMs} ms',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          const SizedBox(width: 8),
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? AppColors.accent : AppColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }
}
