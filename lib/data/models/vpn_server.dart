import 'dart:convert';

class VpnServer {
  final String id;
  final String country;
  final String countryCode;
  final String city;
  final bool isFree;
  final int pingMs;
  final int port;
  final String ip;
  final String ovpnConfig;

  const VpnServer({
    required this.id,
    required this.country,
    required this.countryCode,
    required this.city,
    required this.isFree,
    required this.pingMs,
    this.port = 443,
    required this.ip,
    required this.ovpnConfig,
  });

  factory VpnServer.fromJson(Map<String, dynamic> j) => VpnServer(
        id: j['id'] as String,
        country: j['country'] as String,
        countryCode: (j['countryCode'] as String).toUpperCase(),
        city: j['city'] as String,
        isFree: j['isFree'] as bool? ?? true,
        pingMs: j['pingMs'] as int? ?? 0,
        port: j['port'] as int? ?? 443,
        ip: j['ip'] as String? ?? '',
        ovpnConfig: j['ovpnConfig'] as String? ?? '',
      );

  /// VPN Gate CSV format:
  /// [0]=HostName, [1]=IP, [2]=Score, [3]=Ping, [4]=Speed,
  /// [5]=CountryLong, [6]=CountryShort, [7]=NumVpnSessions,
  /// [8]=Uptime, [9]=TotalUsers, [10]=TotalTraffic,
  /// [11]=LogType, [12]=Operator, [13]=Message,
  /// [14]=OpenVPN_ConfigData_Base64
  factory VpnServer.fromVpngate(List<String> p) {
    final ip = p[1].trim();
    final b64 = p[14].replaceAll('\r', '').replaceAll('\n', '').trim();
    final decoded = utf8.decode(base64.decode(b64));

    // Extract port from the config's "remote <ip> <port>" line
    int port = 443;
    final remoteMatch = RegExp(r'remote\s+\S+\s+(\d+)').firstMatch(decoded);
    if (remoteMatch != null) {
      port = int.tryParse(remoteMatch.group(1) ?? '443') ?? 443;
    }

    return VpnServer(
      id: ip,
      country: p[5].trim(),
      countryCode: p[6].trim().toUpperCase(),
      city: p[5].trim(),
      isFree: true,
      pingMs: int.tryParse(p[3].trim()) ?? 999,
      port: port,
      ip: ip,
      ovpnConfig: decoded,
    );
  }

  VpnServer copyWith({
    String? id,
    String? country,
    String? countryCode,
    String? city,
    bool? isFree,
    int? pingMs,
    int? port,
    String? ip,
    String? ovpnConfig,
  }) {
    return VpnServer(
      id: id ?? this.id,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      city: city ?? this.city,
      isFree: isFree ?? this.isFree,
      pingMs: pingMs ?? this.pingMs,
      port: port ?? this.port,
      ip: ip ?? this.ip,
      ovpnConfig: ovpnConfig ?? this.ovpnConfig,
    );
  }

  String get displayName => '$country — $ip';
}
