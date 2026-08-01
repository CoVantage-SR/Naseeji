import 'register_datasources.dart';
import 'register_repositories.dart';
import 'register_services.dart';
import 'register_usecases.dart';

class Injector {
  static void init() {
    RegisterServices.init();
    RegisterDatasources.init();
    RegisterRepositories.init();
    RegisterUseCases.init();
  }
}
