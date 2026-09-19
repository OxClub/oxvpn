import 'vpn_server.dart';

enum VpnStatus { disconnected, connecting, connected, error }

class VpnConnectionState {
  final VpnStatus status;
  final VpnServer? server;
  final int sessionSeconds;
  final String? errorMessage;

  const VpnConnectionState({
    this.status = VpnStatus.disconnected,
    this.server,
    this.sessionSeconds = 0,
    this.errorMessage,
  });

  VpnConnectionState copyWith({
    VpnStatus? status,
    VpnServer? server,
    int? sessionSeconds,
    String? errorMessage,
  }) =>
      VpnConnectionState(
        status: status ?? this.status,
        server: server ?? this.server,
        sessionSeconds: sessionSeconds ?? this.sessionSeconds,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
