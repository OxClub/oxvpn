class VpnServer {
  final String id, country, countryCode, city;
  final bool isFree;
  final int pingMs;
  const VpnServer({
    required this.id, required this.country, required this.countryCode,
    required this.city, required this.isFree, required this.pingMs,
  });
  factory VpnServer.fromJson(Map<String, dynamic> j) => VpnServer(
    id: j['id'] as String,
    country: j['country'] as String,
    countryCode: (j['countryCode'] as String).toUpperCase(),
    city: j['city'] as String,
    isFree: j['isFree'] as bool? ?? false,
    pingMs: j['pingMs'] as int? ?? 0,
  );
  String get displayName => '$country — $city';
}
