// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rfq_chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rfqChatControllerHash() => r'4c99c9058c8ec44576d867f048537986c17f7898';

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

abstract class _$RfqChatController
    extends BuildlessAutoDisposeAsyncNotifier<List<ChatMessage>> {
  late final String rfqId;

  FutureOr<List<ChatMessage>> build(
    String rfqId,
  );
}

/// See also [RfqChatController].
@ProviderFor(RfqChatController)
const rfqChatControllerProvider = RfqChatControllerFamily();

/// See also [RfqChatController].
class RfqChatControllerFamily extends Family<AsyncValue<List<ChatMessage>>> {
  /// See also [RfqChatController].
  const RfqChatControllerFamily();

  /// See also [RfqChatController].
  RfqChatControllerProvider call(
    String rfqId,
  ) {
    return RfqChatControllerProvider(
      rfqId,
    );
  }

  @override
  RfqChatControllerProvider getProviderOverride(
    covariant RfqChatControllerProvider provider,
  ) {
    return call(
      provider.rfqId,
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
  String? get name => r'rfqChatControllerProvider';
}

/// See also [RfqChatController].
class RfqChatControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    RfqChatController, List<ChatMessage>> {
  /// See also [RfqChatController].
  RfqChatControllerProvider(
    String rfqId,
  ) : this._internal(
          () => RfqChatController()..rfqId = rfqId,
          from: rfqChatControllerProvider,
          name: r'rfqChatControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rfqChatControllerHash,
          dependencies: RfqChatControllerFamily._dependencies,
          allTransitiveDependencies:
              RfqChatControllerFamily._allTransitiveDependencies,
          rfqId: rfqId,
        );

  RfqChatControllerProvider._internal(
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
  FutureOr<List<ChatMessage>> runNotifierBuild(
    covariant RfqChatController notifier,
  ) {
    return notifier.build(
      rfqId,
    );
  }

  @override
  Override overrideWith(RfqChatController Function() create) {
    return ProviderOverride(
      origin: this,
      override: RfqChatControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<RfqChatController, List<ChatMessage>>
      createElement() {
    return _RfqChatControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RfqChatControllerProvider && other.rfqId == rfqId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, rfqId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RfqChatControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<ChatMessage>> {
  /// The parameter `rfqId` of this provider.
  String get rfqId;
}

class _RfqChatControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<RfqChatController,
        List<ChatMessage>> with RfqChatControllerRef {
  _RfqChatControllerProviderElement(super.provider);

  @override
  String get rfqId => (origin as RfqChatControllerProvider).rfqId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
