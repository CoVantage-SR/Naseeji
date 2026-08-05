import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/conversation.dart';
import '../controllers/messages_controller.dart';
import 'widgets/conversation_card.dart';
import 'package:naseeji_factory/supplier/core/widgets/app_bottom_navigation_bar.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  MessagesFilter _activeFilter = MessagesFilter.all;

  static const List<_TabItem> _tabs = [
    _TabItem(label: 'الكل', filter: MessagesFilter.all),
    _TabItem(label: 'شغل', filter: MessagesFilter.business),
    _TabItem(label: 'دعم', filter: MessagesFilter.support),
    _TabItem(label: 'مش مقروء', filter: MessagesFilter.unread),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _activeFilter = _tabs[_tabController.index].filter);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(messagesControllerProvider);

    return Scaffold(
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 3),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        title: Text(
          'مركز الرسائل',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            isScrollable: false,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.outline,
            indicatorColor: AppColors.primary,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: _tabs.map((t) => Tab(text: t.label)).toList(),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: TextField(
              controller: _searchController,
              textAlign: TextAlign.right,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'دور في الشاتات...',
                hintStyle: TextStyle(fontSize: 13, color: AppColors.outline),
                prefixIcon: const Icon(Icons.search, color: AppColors.outline, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          // Body
          Expanded(
            child: stateAsync.when(
              loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, _) => Center(child: Text('خطأ: $e')),
              data: (state) {
                final controller = ref.read(messagesControllerProvider.notifier);
                final filtered = controller.filterConversations(
                  state.conversations,
                  _activeFilter,
                  _searchQuery,
                );

                if (filtered.isEmpty) {
                  return _EmptyState(filter: _activeFilter, searchQuery: _searchQuery);
                }

                final pinned = filtered.where((c) => c.isPinned).toList();
                final unpinned = filtered.where((c) => !c.isPinned).toList();

                return RefreshIndicator(
                  onRefresh: () => ref.refresh(messagesControllerProvider.future),
                  child: ListView(
                    children: [
                      _buildArchivedChatsShortcut(context, state.conversations),
                      // Pinned section
                      if (pinned.isNotEmpty) ...[
                        _SectionHeader(
                          icon: Icons.push_pin,
                          label: 'شاتات متثبتة (${pinned.length})',
                          color: AppColors.primary,
                        ),
                        ...pinned.map((conv) => _buildDismissible(conv, context)),
                        const SizedBox(height: 4),
                      ],
                      // Recent section
                      if (unpinned.isNotEmpty) ...[
                        if (pinned.isNotEmpty)
                          const _SectionHeader(icon: Icons.forum_outlined, label: 'أحدث الشاتات', color: AppColors.outline),
                        ...unpinned.map((conv) => _buildDismissible(conv, context)),
                      ],
                      SizedBox(height: 80),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchivedChatsShortcut(BuildContext context, List<Conversation> conversations) {
    final archivedCount = conversations.where((c) => c.status == ConversationStatus.archived).length;
    if (archivedCount == 0) return const SizedBox.shrink();

    return InkWell(
      onTap: () => context.push('/messages/archived'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerLow, width: 1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$archivedCount',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Text(
              'الشاتات المتأرشفة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(width: 12),
            const Icon(Icons.archive_outlined, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissible(Conversation conv, BuildContext context) {
    return Dismissible(
      key: ValueKey(conv.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        color: Colors.red.shade700,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white),
            Text('حذف', style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 11)),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.primary.withValues(alpha: 0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.more_horiz, color: Colors.white),
            Text('خيارات', style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 11)),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteDialog(context, conv.companyName);
        } else {
          _showConversationOptions(context, conv);
          return false;
        }
      },
      onDismissed: (_) {
        ref.read(messagesControllerProvider.notifier).deleteConversation(conv.id);
      },
      child: Column(
        children: [
          ConversationCard(
            conversation: conv,
            onTap: () {
              if (conv.type == ConversationType.support) {
                context.push('/messages/support/${conv.id}');
              } else {
                context.push('/messages/chat/${conv.id}');
              }
            },
            onLongPress: () => _showConversationOptions(context, conv),
          ),
          const Divider(height: 1, indent: 80),
        ],
      ),
    );
  }

  Future<bool> _showDeleteDialog(BuildContext context, String name) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('مسح الشات', textAlign: TextAlign.right),
            content: Text('عايز تمسح الشات مع $name؟', textAlign: TextAlign.right),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('مسح', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showConversationOptions(BuildContext context, Conversation conv) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(conv.isPinned ? Icons.push_pin_outlined : Icons.push_pin, color: AppColors.primary),
              title: Text(conv.isPinned ? 'فك التثبيت' : 'تثبيت الشات', textAlign: TextAlign.right),
              onTap: () {
                ref.read(messagesControllerProvider.notifier).pinConversation(conv.id, !conv.isPinned);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(conv.isMuted ? Icons.volume_up_outlined : Icons.volume_off_outlined, color: AppColors.primary),
              title: Text(conv.isMuted ? 'شغل الإشعارات' : 'كتم الإشعارات', textAlign: TextAlign.right),
              onTap: () {
                ref.read(messagesControllerProvider.notifier).muteConversation(conv.id, !conv.isMuted);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.mark_chat_read_outlined, color: AppColors.primary),
              title: const Text('خليه مقروء', textAlign: TextAlign.right),
              onTap: () {
                ref.read(messagesControllerProvider.notifier).markAsRead(conv.id);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive_outlined, color: AppColors.outline),
              title: Text('أرشفة', textAlign: TextAlign.right),
              onTap: () {
                ref.read(messagesControllerProvider.notifier).archiveConversation(conv.id);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  final String label;
  final MessagesFilter filter;
  const _TabItem({required this.label, required this.filter});
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SectionHeader({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final MessagesFilter filter;
  final String searchQuery;
  const _EmptyState({required this.filter, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final isSearch = searchQuery.isNotEmpty;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isSearch ? Icons.search_off : Icons.forum_outlined, size: 64, color: AppColors.outlineVariant),
          SizedBox(height: 16),
          Text(
            isSearch ? 'ملقناش أي شات لـ "$searchQuery"' : 'مفيش أي شاتات هنا',
            style: const TextStyle(fontSize: 15, color: AppColors.outline),
          ),
        ],
      ),
    );
  }
}



