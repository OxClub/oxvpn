import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/connection_state.dart';
import '../models/vpn_server.dart';

final vpnControllerProvider =
    StateNotifierProvider<VpnController, VpnConnectionState>((_) => VpnController());

class VpnController extends StateNotifier<VpnConnectionState> {
  VpnController() : super(const VpnConnectionState());
  Timer? _timer;

  Future<void> connect(VpnServer server) async {
    state = state.copyWith(status: VpnStatus.connecting, server: server);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(status: VpnStatus.connected, sessionSeconds: 0);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(sessionSeconds: state.sessionSeconds + 1);
    });
  }

  void disconnect() {
    _timer?.cancel();
    state = const VpnConnectionState();
  }

  Future<void> toggle(VpnServer? server) async {
    if (server == null) return;
    switch (state.status) {
      case VpnStatus.disconnected:
        await connect(server);
      case VpnStatus.connected:
        disconnect();
      case VpnStatus.connecting:
        break;
    }
  }
}
