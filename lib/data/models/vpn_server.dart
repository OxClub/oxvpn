import 'dart:convert';

class VpnServer {
  final String id;
  final String country;
  final String countryCode;
  final String city;
  final bool isFree;
  final int pingMs;
  final String ip;
  final String ovpnConfig;

  const VpnServer({
    required this.id,
    required this.country,
    required this.countryCode,
    required this.city,
    required this.isFree,
    required this.pingMs,
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
    return VpnServer(
      id: ip,
      country: p[5].trim(),
      countryCode: p[6].trim().toUpperCase(),
      city: p[5].trim(),
      isFree: true,
      pingMs: int.tryParse(p[3].trim()) ?? 999,
      ip: ip,
      ovpnConfig: decoded,
    );
  }

  String get displayName => '$country — $ip';
}
