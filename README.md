# OxVPN

Flutter VPN app (Android). Built via GitHub Actions.

## Cloud build
Every push to `main` triggers `.github/workflows/build.yml`:
- JDK 17 setup
- Flutter 3.22.3 stable
- analyze + test
- debug APK, release APK, release AAB artifacts

## Assumptions
- Package: com.oxclub.oxvpn
- WireGuard engine stubbed (AppConfig.useRealVpnEngine = false)
- Firebase disabled by default
- AdMob uses Google TEST unit IDs
