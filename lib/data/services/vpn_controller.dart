import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import '../models/connection_state.dart';
import '../models/vpn_server.dart';

final vpnControllerProvider =
    StateNotifierProvider<VpnController, VpnConnectionState>((_) => VpnController());

class VpnController extends StateNotifier<VpnConnectionState> {
  VpnController() : super(const VpnConnectionState());

  OpenVPN? _openVpn;
  Timer? _timer;
  bool _ready = false;

  void init({required String appName, required String packageId}) {
    if (_ready) return;
    _openVpn = OpenVPN(
      onVpnStatusChanged: (data) {
        final status = data?.status ?? '';
        if (status == 'CONNECTED') {
          state = state.copyWith(status: VpnStatus.connected);
          _startTimer();
        } else if (status == 'DISCONNECTED') {
          _timer?.cancel();
          state = const VpnConnectionState();
        }
      },
      onVpnStageChanged: (stage, raw) {
        if (stage == VPNStage.connecting || stage == VPNStage.authenticating) {
          state = state.copyWith(status: VpnStatus.connecting);
        }
      },
    );
    _openVpn!.initialize(
      groupIdentifier: packageId,
      providerBundleIdentifier: packageId,
      localizedDescription: appName,
      lastStage: (stage) {},
      lastStatus: (status) {},
    );
    _ready = true;
  }

  Future<void> connect(VpnServer server) async {
    if (!_ready || _openVpn == null) return;
    state = state.copyWith(
      status: VpnStatus.connecting,
      server: server,
      errorMessage: null,
    );
    try {
      await _openVpn!.connect(
        server.ovpnConfig,
        server.displayName,
        username: 'vpn',
        password: 'vpn',
        certIsRequired: false,
      );
    } catch (e) {
      state = state.copyWith(
        status: VpnStatus.disconnected,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> disconnect() async {
    if (_openVpn == null) return;
    await _openVpn!.disconnect();
    _timer?.cancel();
    state = const VpnConnectionState();
  }

  Future<void> toggle(VpnServer? server) async {
    if (server == null) return;
    if (state.status == VpnStatus.connected) {
      await disconnect();
    } else if (state.status == VpnStatus.disconnected ||
        state.status == VpnStatus.error) {
      await connect(server);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(sessionSeconds: state.sessionSeconds + 1);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
