class AppConstants {
  AppConstants._();

  static const String appName = 'QuickSlot';

  static const String _rawBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue:
        'https://quickslot-ashutosh2103-production.up.railway.app',
  );

  static const String _rawSocketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue:
        'https://quickslot-ashutosh2103-production.up.railway.app',
  );

  /// REST API base URL. Use your Railway URL in production.
  static String get baseUrl => _ensureScheme(_rawBaseUrl);

  /// Socket.IO server URL. Must point to a long-running Node server.
  static String get socketUrl => _ensureScheme(_rawSocketUrl);

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static String _ensureScheme(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      return trimmed;
    }
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return 'https://$trimmed';
  }
}
