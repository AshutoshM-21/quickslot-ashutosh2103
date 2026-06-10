class AppConstants {
  AppConstants._();

  static const String appName = 'QuickSlot';

  /// REST API base URL. Use your Railway URL in production.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// Socket.IO server URL. Must point to a long-running Node server
  /// (`server.js`), not a serverless REST-only deployment.
  static const String socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
