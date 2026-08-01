import 'dependency_container.dart';

class ServiceLocator {
  static T get<T>() => DependencyContainer.get<T>();
  static void register<T>(T instance) => DependencyContainer.register<T>(instance);
  static bool isRegistered<T>() => DependencyContainer.isRegistered<T>();
}
