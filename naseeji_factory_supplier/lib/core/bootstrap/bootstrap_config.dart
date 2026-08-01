enum AppEnvironment { dev, staging, prod }

class BootstrapConfig {
  final AppEnvironment environment;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableAnalytics;

  const BootstrapConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.enableLogging = true,
    this.enableAnalytics = false,
  });

  factory BootstrapConfig.defaultConfig() {
    return const BootstrapConfig(
      environment: AppEnvironment.dev,
      apiBaseUrl: 'https://api.naseeji.com/v1',
      enableLogging: true,
    );
  }
}
