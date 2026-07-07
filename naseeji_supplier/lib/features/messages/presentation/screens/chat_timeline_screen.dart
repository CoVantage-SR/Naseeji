import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/timeline_stage.dart';
import '../../data/repositories/messages_repository_impl.dart';
import 'widgets/timeline_event_tile.dart';

part 'chat_timeline_screen.g.dart';

@riverpod
Future<List<TimelineStage>> conversationTimeline(
  ConversationTimelineRef ref,
  String conversationId,
) async {
  final repo = ref.watch(messagesRepositoryProvider);
  return repo.getTimelineStages(conversationId);
}

class ChatTimelineScreen extends ConsumerWidget {
  final String conversationId;

  const ChatTimelineScreen({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagesAsync = ref.watch(conversationTimelineProvider(conversationId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: const Text('الخط الزمني', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: stagesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (stages) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(conversationTimelineProvider(conversationId).future),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: List.generate(stages.length, (i) {
                  final stage = stages[i];
                  return TimelineEventTile(
                    stage: stage.label,
                    timestamp: stage.timestamp,
                    user: stage.user,
                    notes: stage.notes,
                    isActive: stage.isActive,
                    isCompleted: stage.isCompleted,
                    icon: stage.icon,
                    isLast: i == stages.length - 1,
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
