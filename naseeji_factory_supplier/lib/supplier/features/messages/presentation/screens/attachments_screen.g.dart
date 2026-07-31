// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachments_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$conversationAttachmentsHash() =>
    r'07d994b4067abc9194a1eab27dc162ef1804c4fc';

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

/// See also [conversationAttachments].
@ProviderFor(conversationAttachments)
const conversationAttachmentsProvider = ConversationAttachmentsFamily();

/// See also [conversationAttachments].
class ConversationAttachmentsFamily
    extends Family<AsyncValue<List<MessageAttachment>>> {
  /// See also [conversationAttachments].
  const ConversationAttachmentsFamily();

  /// See also [conversationAttachments].
  ConversationAttachmentsProvider call(String conversationId) {
    return ConversationAttachmentsProvider(conversationId);
  }

  @override
  ConversationAttachmentsProvider getProviderOverride(
    covariant ConversationAttachmentsProvider provider,
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
  String? get name => r'conversationAttachmentsProvider';
}

/// See also [conversationAttachments].
class ConversationAttachmentsProvider
    extends AutoDisposeFutureProvider<List<MessageAttachment>> {
  /// See also [conversationAttachments].
  ConversationAttachmentsProvider(String conversationId)
    : this._internal(
        (ref) => conversationAttachments(
          ref as ConversationAttachmentsRef,
          conversationId,
        ),
        from: conversationAttachmentsProvider,
        name: r'conversationAttachmentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$conversationAttachmentsHash,
        dependencies: ConversationAttachmentsFamily._dependencies,
        allTransitiveDependencies:
            ConversationAttachmentsFamily._allTransitiveDependencies,
        conversationId: conversationId,
      );

  ConversationAttachmentsProvider._internal(
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
  Override overrideWith(
    FutureOr<List<MessageAttachment>> Function(
      ConversationAttachmentsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConversationAttachmentsProvider._internal(
        (ref) => create(ref as ConversationAttachmentsRef),
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
  AutoDisposeFutureProviderElement<List<MessageAttachment>> createElement() {
    return _ConversationAttachmentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationAttachmentsProvider &&
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
mixin ConversationAttachmentsRef
    on AutoDisposeFutureProviderRef<List<MessageAttachment>> {
  /// The parameter `conversationId` of this provider.
  String get conversationId;
}

class _ConversationAttachmentsProviderElement
    extends AutoDisposeFutureProviderElement<List<MessageAttachment>>
    with ConversationAttachmentsRef {
  _ConversationAttachmentsProviderElement(super.provider);

  @override
  String get conversationId =>
      (origin as ConversationAttachmentsProvider).conversationId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

