import 'vpn_server.dart';

enum VpnStatus { disconnected, connecting, connected }

class VpnConnectionState {
  final VpnStatus status;
  final VpnServer? server;
  final int sessionSeconds;
  const VpnConnectionState({
    this.status = VpnStatus.disconnected,
    this.server,
    this.sessionSeconds = 0,
  });
  VpnConnectionState copyWith({
    VpnStatus? status, VpnServer? server, int? sessionSeconds,
  }) => VpnConnectionState(
    status: status ?? this.status,
    server: server ?? this.server,
    sessionSeconds: sessionSeconds ?? this.sessionSeconds,
  );
}
