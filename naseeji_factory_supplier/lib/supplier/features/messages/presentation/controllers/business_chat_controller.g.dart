// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$businessChatControllerHash() =>
    r'22724893fcb2748298a1a47c09d62e039626b94a';

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

abstract class _$BusinessChatController
    extends BuildlessAutoDisposeAsyncNotifier<List<BusinessMessage>> {
  late final String conversationId;

  FutureOr<List<BusinessMessage>> build(String conversationId);
}

/// See also [BusinessChatController].
@ProviderFor(BusinessChatController)
const businessChatControllerProvider = BusinessChatControllerFamily();

/// See also [BusinessChatController].
class BusinessChatControllerFamily
    extends Family<AsyncValue<List<BusinessMessage>>> {
  /// See also [BusinessChatController].
  const BusinessChatControllerFamily();

  /// See also [BusinessChatController].
  BusinessChatControllerProvider call(String conversationId) {
    return BusinessChatControllerProvider(conversationId);
  }

  @override
  BusinessChatControllerProvider getProviderOverride(
    covariant BusinessChatControllerProvider provider,
  ) {
    return call(provider.conversationId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'businessChatControllerProvider';
}

/// See also [BusinessChatController].
class BusinessChatControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          BusinessChatController,
          List<BusinessMessage>
        > {
  /// See also [BusinessChatController].
  BusinessChatControllerProvider(String conversationId)
    : this._internal(
        () => BusinessChatController()..conversationId = conversationId,
        from: businessChatControllerProvider,
        name: r'businessChatControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$businessChatControllerHash,
        dependencies: BusinessChatControllerFamily._dependencies,
        allTransitiveDependencies:
            BusinessChatControllerFamily._allTransitiveDependencies,
        conversationId: conversationId,
      );

  BusinessChatControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conversationId,
  }) : super.internal();

  final String conversationId;

  @override
  FutureOr<List<BusinessMessage>> runNotifierBuild(
    covariant BusinessChatController notifier,
  ) {
    return notifier.build(conversationId);
  }

  @override
  Override overrideWith(BusinessChatController Function() create) {
    return ProviderOverride(
      origin: this,
      override: BusinessChatControllerProvider._internal(
        () => create()..conversationId = conversationId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conversationId: conversationId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    BusinessChatController,
    List<BusinessMessage>
  >
  createElement() {
    return _BusinessChatControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BusinessChatControllerProvider &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BusinessChatControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<BusinessMessage>> {
  /// The parameter `conversationId` of this provider.
  String get conversationId;
}

class _BusinessChatControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          BusinessChatController,
          List<BusinessMessage>
        >
    with BusinessChatControllerRef {
  _BusinessChatControllerProviderElement(super.provider);

  @override
  String get conversationId =>
      (origin as BusinessChatControllerProvider).conversationId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

