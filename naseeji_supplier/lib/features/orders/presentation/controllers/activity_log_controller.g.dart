// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activityLogControllerHash() =>
    r'2113f4d8832e7d004b74d71ef8689008e083c0c3';

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

abstract class _$ActivityLogController
    extends BuildlessAutoDisposeAsyncNotifier<List<ActivityLogItem>> {
  late final String rfqId;

  FutureOr<List<ActivityLogItem>> build(String rfqId);
}

/// See also [ActivityLogController].
@ProviderFor(ActivityLogController)
const activityLogControllerProvider = ActivityLogControllerFamily();

/// See also [ActivityLogController].
class ActivityLogControllerFamily
    extends Family<AsyncValue<List<ActivityLogItem>>> {
  /// See also [ActivityLogController].
  const ActivityLogControllerFamily();

  /// See also [ActivityLogController].
  ActivityLogControllerProvider call(String rfqId) {
    return ActivityLogControllerProvider(rfqId);
  }

  @override
  ActivityLogControllerProvider getProviderOverride(
    covariant ActivityLogControllerProvider provider,
  ) {
    return call(provider.rfqId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'activityLogControllerProvider';
}

/// See also [ActivityLogController].
class ActivityLogControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ActivityLogController,
          List<ActivityLogItem>
        > {
  /// See also [ActivityLogController].
  ActivityLogControllerProvider(String rfqId)
    : this._internal(
        () => ActivityLogController()..rfqId = rfqId,
        from: activityLogControllerProvider,
        name: r'activityLogControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$activityLogControllerHash,
        dependencies: ActivityLogControllerFamily._dependencies,
        allTransitiveDependencies:
            ActivityLogControllerFamily._allTransitiveDependencies,
        rfqId: rfqId,
      );

  ActivityLogControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.rfqId,
  }) : super.internal();

  final String rfqId;

  @override
  FutureOr<List<ActivityLogItem>> runNotifierBuild(
    covariant ActivityLogController notifier,
  ) {
    return notifier.build(rfqId);
  }

  @override
  Override overrideWith(ActivityLogController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ActivityLogControllerProvider._internal(
        () => create()..rfqId = rfqId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        rfqId: rfqId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    ActivityLogController,
    List<ActivityLogItem>
  >
  createElement() {
    return _ActivityLogControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityLogControllerProvider && other.rfqId == rfqId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, rfqId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ActivityLogControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<ActivityLogItem>> {
  /// The parameter `rfqId` of this provider.
  String get rfqId;
}

class _ActivityLogControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ActivityLogController,
          List<ActivityLogItem>
        >
    with ActivityLogControllerRef {
  _ActivityLogControllerProviderElement(super.provider);

  @override
  String get rfqId => (origin as ActivityLogControllerProvider).rfqId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
