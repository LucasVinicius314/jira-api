class Dotenv {
  static String get apiAuthority =>
      const String.fromEnvironment('API_AUTHORITY');

  static String get sslMode => const String.fromEnvironment('SSL_MODE');
}
