// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supportChatControllerHash() =>
    r'951d3a7ece704b2a593463516772ac04c295b354';

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

abstract class _$SupportChatController
    extends BuildlessAutoDisposeAsyncNotifier<SupportTicket?> {
  late final String ticketId;

  FutureOr<SupportTicket?> build(String ticketId);
}

/// See also [SupportChatController].
@ProviderFor(SupportChatController)
const supportChatControllerProvider = SupportChatControllerFamily();

/// See also [SupportChatController].
class SupportChatControllerFamily extends Family<AsyncValue<SupportTicket?>> {
  /// See also [SupportChatController].
  const SupportChatControllerFamily();

  /// See also [SupportChatController].
  SupportChatControllerProvider call(String ticketId) {
    return SupportChatControllerProvider(ticketId);
  }

  @override
  SupportChatControllerProvider getProviderOverride(
    covariant SupportChatControllerProvider provider,
  ) {
    return call(provider.ticketId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'supportChatControllerProvider';
}

/// See also [SupportChatController].
class SupportChatControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          SupportChatController,
          SupportTicket?
        > {
  /// See also [SupportChatController].
  SupportChatControllerProvider(String ticketId)
    : this._internal(
        () => SupportChatController()..ticketId = ticketId,
        from: supportChatControllerProvider,
        name: r'supportChatControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$supportChatControllerHash,
        dependencies: SupportChatControllerFamily._dependencies,
        allTransitiveDependencies:
            SupportChatControllerFamily._allTransitiveDependencies,
        ticketId: ticketId,
      );

  SupportChatControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ticketId,
  }) : super.internal();

  final String ticketId;

  @override
  FutureOr<SupportTicket?> runNotifierBuild(
    covariant SupportChatController notifier,
  ) {
    return notifier.build(ticketId);
  }

  @override
  Override overrideWith(SupportChatController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SupportChatControllerProvider._internal(
        () => create()..ticketId = ticketId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ticketId: ticketId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SupportChatController, SupportTicket?>
  createElement() {
    return _SupportChatControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SupportChatControllerProvider && other.ticketId == ticketId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ticketId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SupportChatControllerRef
    on AutoDisposeAsyncNotifierProviderRef<SupportTicket?> {
  /// The parameter `ticketId` of this provider.
  String get ticketId;
}

class _SupportChatControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SupportChatController,
          SupportTicket?
        >
    with SupportChatControllerRef {
  _SupportChatControllerProviderElement(super.provider);

  @override
  String get ticketId => (origin as SupportChatControllerProvider).ticketId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

