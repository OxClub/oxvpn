import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart' hide VpnStatus;
import '../models/connection_state.dart';
import '../models/vpn_server.dart';
import 'log_store.dart';

final vpnControllerProvider =
    StateNotifierProvider<VpnController, VpnConnectionState>((ref) => VpnController(ref));

class VpnController extends StateNotifier<VpnConnectionState> {
  final Ref _ref;
  VpnController(this._ref) : super(const VpnConnectionState());

  OpenVPN? _openVpn;
  Timer? _timer;
  bool _ready = false;

  LogStore get _log => _ref.read(logStoreProvider.notifier);

  void init({required String appName, required String packageId}) {
    if (_ready) return;
    _log.add('INIT appName=$appName pkg=$packageId');
    _openVpn = OpenVPN(
      onVpnStatusChanged: (data) {
        _log.add('STATUS: $data');
      },
      onVpnStageChanged: (stage, raw) {
        _log.add('STAGE: $raw');
        final st = raw.toLowerCase();
        if (st.contains('connected') && !st.contains('disconnect')) {
          state = state.copyWith(status: VpnState.connected);
          _startTimer();
        } else if (st.contains('connecting') ||
            st.contains('authenticating') ||
            st.contains('waiting')) {
          state = state.copyWith(status: VpnState.connecting);
        } else if (st.contains('disconnect') || st.contains('exiting')) {
          _timer?.cancel();
          state = const VpnConnectionState();
        } else if (st.contains('error') || st.contains('fail')) {
          state = state.copyWith(status: VpnState.error, errorMessage: raw);
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
    _log.add('INIT done, ready=$_ready');
  }

  Future<void> connect(VpnServer server) async {
    if (!_ready || _openVpn == null) {
      _log.add('CONNECT aborted: not ready');
      return;
    }
    _log.add('CONNECT ${server.displayName} (${server.ip})');
    _log.add('CONFIG length=${server.ovpnConfig.length}');
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
      _log.add('CONNECT called');
    } catch (e) {
      _log.add('CONNECT ERROR: $e');
      state = state.copyWith(
        status: VpnState.disconnected,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> disconnect() async {
    if (_openVpn == null) return;
    _log.add('DISCONNECT');
    _openVpn!.disconnect();
    _timer?.cancel();
    state = const VpnConnectionState();
  }

  Future<void> toggle(VpnServer? server) async {
    if (server == null) {
      _log.add('TOGGLE: server is null');
      return;
    }
    if (state.status == VpnState.connected) {
      await disconnect();
    } else {
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
