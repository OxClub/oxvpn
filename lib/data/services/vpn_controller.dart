import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart' hide VpnStatus;
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
        // data is a String status from the plugin
        final s = data ?? '';
        if (s == 'CONNECTED' || s == 'connected') {
          state = state.copyWith(status: VpnState.connected);
          _startTimer();
        } else if (s == 'DISCONNECTED' || s == 'disconnected') {
          _timer?.cancel();
          state = const VpnConnectionState();
        }
      },
      onVpnStageChanged: (stage, raw) {
        final st = raw.toLowerCase();
        if (st.contains('connecting') || st.contains('authenticating')) {
          state = state.copyWith(status: VpnState.connecting);
        }
        if (st.contains('connected')) {
          state = state.copyWith(status: VpnState.connected);
          _startTimer();
        }
        if (st.contains('disconnect')) {
          _timer?.cancel();
          state = const VpnConnectionState();
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
      status: VpnState.connecting,
      server: server,
      errorMessage: null,
    );
    try {
      _openVpn!.connect(
        server.ovpnConfig,
        server.displayName,
        username: 'vpn',
        password: 'vpn',
        certIsRequired: false,
      );
    } catch (e) {
      state = state.copyWith(
        status: VpnState.disconnected,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> disconnect() async {
    if (_openVpn == null) return;
    _openVpn!.disconnect();
    _timer?.cancel();
    state = const VpnConnectionState();
  }

  Future<void> toggle(VpnServer? server) async {
    if (server == null) return;
    if (state.status == VpnState.connected) {
      await disconnect();
    } else if (state.status == VpnState.disconnected ||
        state.status == VpnState.error) {
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
