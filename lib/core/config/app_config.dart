class AppConfig {
  static const bool useMockData = true;          // ⚠️ dev only
  static const String apiBaseUrl =
  String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.example.com/v1');
  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
}