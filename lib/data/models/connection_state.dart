import 'vpn_server.dart';

enum VpnState { disconnected, connecting, connected, error }

class VpnConnectionState {
  final VpnState status;
  final VpnServer? server;
  final int sessionSeconds;
  final String? errorMessage;

  const VpnConnectionState({
    this.status = VpnState.disconnected,
    this.server,
    this.sessionSeconds = 0,
    this.errorMessage,
  });

  VpnConnectionState copyWith({
    VpnState? status,
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
