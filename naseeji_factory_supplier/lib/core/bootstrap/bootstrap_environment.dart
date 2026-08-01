import 'bootstrap_config.dart';

class BootstrapEnvironment {
  static BootstrapConfig _config = BootstrapConfig.defaultConfig();

  static BootstrapConfig get config => _config;

  static void setEnvironment(BootstrapConfig config) {
    _config = config;
  }
}
