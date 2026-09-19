import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/connection_state.dart';

class PowerButton extends StatelessWidget {
  final VpnConnectionState vpn;
  final VoidCallback onTap;
  const PowerButton({super.key, required this.vpn, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final connected = vpn.status == VpnStatus.connected;
    final connecting = vpn.status == VpnStatus.connecting;
    final color = connected ? AppColors.accentGreen : AppColors.accent;
    final label = connected ? 'CONNECTED' : connecting ? 'CONNECTING' : 'DISCONNECTED';

    return GestureDetector(
      onTap: connecting ? null : onTap,
      child: Container(
        width: 260,
        height: 260,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(70),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 40,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (connecting)
              const SizedBox(
                width: 68, height: 68,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 5),
              )
            else
              const Icon(Icons.power_settings_new, color: Colors.white, size: 72),
            const SizedBox(height: 16),
            Text(label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                )),
          ],
        ),
      ),
    );
  }
}
