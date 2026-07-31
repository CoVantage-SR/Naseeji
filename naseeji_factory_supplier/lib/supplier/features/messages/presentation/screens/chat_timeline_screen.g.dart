// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_timeline_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$conversationTimelineHash() =>
    r'5395f0019a5753065636ac3eb90987c717878cbd';

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

/// See also [conversationTimeline].
@ProviderFor(conversationTimeline)
const conversationTimelineProvider = ConversationTimelineFamily();

/// See also [conversationTimeline].
class ConversationTimelineFamily
    extends Family<AsyncValue<List<TimelineStage>>> {
  /// See also [conversationTimeline].
  const ConversationTimelineFamily();

  /// See also [conversationTimeline].
  ConversationTimelineProvider call(
    String conversationId,
  ) {
    return ConversationTimelineProvider(
      conversationId,
    );
  }

  @override
  ConversationTimelineProvider getProviderOverride(
    covariant ConversationTimelineProvider provider,
  ) {
    return call(
      provider.conversationId,
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
  String? get name => r'conversationTimelineProvider';
}

/// See also [conversationTimeline].
class ConversationTimelineProvider
    extends AutoDisposeFutureProvider<List<TimelineStage>> {
  /// See also [conversationTimeline].
  ConversationTimelineProvider(
    String conversationId,
  ) : this._internal(
          (ref) => conversationTimeline(
            ref as ConversationTimelineRef,
            conversationId,
          ),
          from: conversationTimelineProvider,
          name: r'conversationTimelineProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$conversationTimelineHash,
          dependencies: ConversationTimelineFamily._dependencies,
          allTransitiveDependencies:
              ConversationTimelineFamily._allTransitiveDependencies,
          conversationId: conversationId,
        );

  ConversationTimelineProvider._internal(
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
    FutureOr<List<TimelineStage>> Function(ConversationTimelineRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConversationTimelineProvider._internal(
        (ref) => create(ref as ConversationTimelineRef),
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
  AutoDisposeFutureProviderElement<List<TimelineStage>> createElement() {
    return _ConversationTimelineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationTimelineProvider &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ConversationTimelineRef
    on AutoDisposeFutureProviderRef<List<TimelineStage>> {
  /// The parameter `conversationId` of this provider.
  String get conversationId;
}

class _ConversationTimelineProviderElement
    extends AutoDisposeFutureProviderElement<List<TimelineStage>>
    with ConversationTimelineRef {
  _ConversationTimelineProviderElement(super.provider);

  @override
  String get conversationId =>
      (origin as ConversationTimelineProvider).conversationId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
