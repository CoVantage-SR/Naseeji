class DependencyContainer {
  static final Map<Type, dynamic> _instances = {};

  static void register<T>(T instance) {
    _instances[T] = instance;
  }

  static T get<T>() {
    final instance = _instances[T];
    if (instance == null) {
      throw Exception('Dependency $T not registered in DependencyContainer');
    }
    return instance as T;
  }

  static bool isRegistered<T>() => _instances.containsKey(T);

  static void reset() {
    _instances.clear();
  }
}
