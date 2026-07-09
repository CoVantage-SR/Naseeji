import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/message_attachment.dart';
import '../../data/repositories/messages_repository_impl.dart';

part 'attachments_screen.g.dart';

@riverpod
Future<List<MessageAttachment>> conversationAttachments(
  ConversationAttachmentsRef ref,
  String conversationId,
) async {
  final repo = ref.watch(messagesRepositoryProvider);
  return repo.getAttachments(conversationId);
}

class AttachmentsScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const AttachmentsScreen({super.key, required this.conversationId});

  @override
  ConsumerState<AttachmentsScreen> createState() => _AttachmentsScreenState();
}

class _AttachmentsScreenState extends ConsumerState<AttachmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<_AttachTab> _tabs = [
    _AttachTab(label: 'الصور', type: AttachmentType.image),
    _AttachTab(label: 'فيديو', type: AttachmentType.video),
    _AttachTab(label: 'مستندات', type: AttachmentType.document),
    _AttachTab(label: 'PDF', type: AttachmentType.pdf),
    _AttachTab(label: 'فواتير', type: AttachmentType.invoice),
    _AttachTab(label: 'شهادات', type: AttachmentType.certificate),
    _AttachTab(label: 'جودة', type: AttachmentType.qualityReport),
    _AttachTab(label: 'شحن', type: AttachmentType.shippingDoc),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attachmentsAsync = ref.watch(conversationAttachmentsProvider(widget.conversationId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: Text('الملفات والمرفقات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.sort), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.outline,
            indicatorColor: AppColors.primary,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            tabs: _tabs.map((t) => Tab(text: t.label)).toList(),
          ),
        ),
      ),
      body: attachmentsAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (attachments) {
          return TabBarView(
            controller: _tabController,
            children: _tabs.map((tab) {
              final filtered = attachments.where((a) => a.type == tab.type).toList();
              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.folder_open_outlined, size: 64, color: AppColors.outlineVariant),
                      SizedBox(height: 12),
                      Text('لا توجد ${tab.label}', style: TextStyle(color: AppColors.outline)),
                    ],
                  ),
                );
              }
              if (tab.type == AttachmentType.image || tab.type == AttachmentType.video) {
                return _GridView(attachments: filtered);
              }
              return _ListView(attachments: filtered);
            }).toList(),
          );
        },
      ),
    );
  }
}

class _GridView extends StatelessWidget {
  final List<MessageAttachment> attachments;
  const _GridView({required this.attachments});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: attachments.length,
      itemBuilder: (_, i) {
        final att = attachments[i];
        return GestureDetector(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (att.type == AttachmentType.video)
                    const Icon(Icons.play_circle_outline, color: AppColors.outline, size: 40),
                  if (att.type == AttachmentType.image)
                    const Icon(Icons.image_outlined, color: AppColors.outline, size: 40),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      color: Colors.black.withValues(alpha: 0.4),
                      child: Text(
                        att.fileSize,
                        style: TextStyle(fontSize: 9, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ListView extends StatelessWidget {
  final List<MessageAttachment> attachments;
  const _ListView({required this.attachments});

  IconData _iconFor(AttachmentType type) {
    switch (type) {
      case AttachmentType.pdf: return Icons.picture_as_pdf_outlined;
      case AttachmentType.invoice: return Icons.receipt_outlined;
      case AttachmentType.certificate: return Icons.verified_outlined;
      case AttachmentType.qualityReport: return Icons.assignment_outlined;
      case AttachmentType.shippingDoc: return Icons.local_shipping_outlined;
      default: return Icons.description_outlined;
    }
  }

  Color _colorFor(AttachmentType type) {
    switch (type) {
      case AttachmentType.pdf: return Colors.red;
      case AttachmentType.invoice: return AppColors.secondary;
      case AttachmentType.certificate: return AppColors.primary;
      case AttachmentType.qualityReport: return Colors.purple;
      case AttachmentType.shippingDoc: return Colors.teal;
      default: return AppColors.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: attachments.length,
      separatorBuilder: (_, __) => SizedBox(height: 8),
      itemBuilder: (_, i) {
        final att = attachments[i];
        final color = _colorFor(att.type);
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
          ),
          child: Row(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.download_outlined, color: AppColors.primary, size: 20),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, color: AppColors.outline, size: 20),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
              const Spacer(),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(att.filename, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface), overflow: TextOverflow.ellipsis),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(att.uploadedAt, style: TextStyle(fontSize: 10, color: AppColors.outline)),
                        Text(' · ', style: TextStyle(color: AppColors.outline)),
                        Text(att.fileSize, style: TextStyle(fontSize: 10, color: AppColors.outline)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(_iconFor(att.type), color: color, size: 22),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AttachTab {
  final String label;
  final AttachmentType type;
  const _AttachTab({required this.label, required this.type});
}
