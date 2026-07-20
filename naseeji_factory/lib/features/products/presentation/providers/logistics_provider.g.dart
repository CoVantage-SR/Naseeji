// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logistics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$logisticsInfoHash() => r'ff1d4543e5347d249a32928da9e8d3e9e9e41cee';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [logisticsInfo].
@ProviderFor(logisticsInfo)
const logisticsInfoProvider = LogisticsInfoFamily();

/// See also [logisticsInfo].
class LogisticsInfoFamily extends Family<AsyncValue<LogisticsInfo>> {
  /// See also [logisticsInfo].
  const LogisticsInfoFamily();

  /// See also [logisticsInfo].
  LogisticsInfoProvider call({
    required String productId,
  }) {
    return LogisticsInfoProvider(
      productId: productId,
    );
  }

  @override
  LogisticsInfoProvider getProviderOverride(
    covariant LogisticsInfoProvider provider,
  ) {
    return call(
      productId: provider.productId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'logisticsInfoProvider';
}

/// See also [logisticsInfo].
class LogisticsInfoProvider extends AutoDisposeFutureProvider<LogisticsInfo> {
  /// See also [logisticsInfo].
  LogisticsInfoProvider({
    required String productId,
  }) : this._internal(
          (ref) => logisticsInfo(
            ref as LogisticsInfoRef,
            productId: productId,
          ),
          from: logisticsInfoProvider,
          name: r'logisticsInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$logisticsInfoHash,
          dependencies: LogisticsInfoFamily._dependencies,
          allTransitiveDependencies:
              LogisticsInfoFamily._allTransitiveDependencies,
          productId: productId,
        );

  LogisticsInfoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    FutureOr<LogisticsInfo> Function(LogisticsInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LogisticsInfoProvider._internal(
        (ref) => create(ref as LogisticsInfoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<LogisticsInfo> createElement() {
    return _LogisticsInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LogisticsInfoProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LogisticsInfoRef on AutoDisposeFutureProviderRef<LogisticsInfo> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _LogisticsInfoProviderElement
    extends AutoDisposeFutureProviderElement<LogisticsInfo>
    with LogisticsInfoRef {
  _LogisticsInfoProviderElement(super.provider);

  @override
  String get productId => (origin as LogisticsInfoProvider).productId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
