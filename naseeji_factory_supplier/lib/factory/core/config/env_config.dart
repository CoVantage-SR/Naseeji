enum AppEnv {
  development,
  production,
}

class EnvConfig {
  final AppEnv environment;
  final String apiBaseUrl;
  final int connectTimeoutMs;
  final int receiveTimeoutMs;

  const EnvConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.connectTimeoutMs = 15000,
    this.receiveTimeoutMs = 15000,
  });

  static EnvConfig get dev => const EnvConfig(
        environment: AppEnv.development,
        apiBaseUrl: 'https://dev-api.naseeji.com/v1',
      );

  static EnvConfig get prod => const EnvConfig(
        environment: AppEnv.production,
        apiBaseUrl: 'https://api.naseeji.com/v1',
      );

  bool get isDevelopment => environment == AppEnv.development;
  bool get isProduction => environment == AppEnv.production;
}


