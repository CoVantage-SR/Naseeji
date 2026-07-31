import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/chat_provider.dart';
import '../widgets/conversations_list_widgets.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  final List<Map<String, String>> _chatTabs = const [
    {'key': 'all', 'label': 'الكل'},
    {'key': 'negotiating', 'label': 'تفاوض نشط'},
    {'key': 'agreed', 'label': 'صفقات معتمدة'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _chatTabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allConversations = ref.watch(chatNotifierProvider);
    final activeTabKey = _chatTabs[_tabController.index]['key']!;
    final notifier = ref.read(chatNotifierProvider.notifier);

    // Apply Filters (exclude archived / blocked)
    var filtered = allConversations.where((c) => !c.isArchived && !c.isBlocked).toList();

    if (activeTabKey != 'all') {
      filtered = filtered.where((c) => c.negotiationStatus == activeTabKey).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((c) => c.supplierName.contains(_searchQuery)).toList();
    }

    // Sort by pinned first, then last message time (represented by id in mock data)
    filtered.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.id.compareTo(a.id);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('محادثات التوريد والمفاوضات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.archive_outlined),
            tooltip: 'المحادثات المؤرشفة',
            onPressed: () => context.push('/chat/archived'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppSearchBar(
                hintText: 'ابحث عن اسم المورد...',
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                onFilterTap: () {},
              ),
            ),
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              tabs: _chatTabs.map((t) => Tab(text: t['label'])).toList(),
            ),
            const Divider(height: 1),
            Expanded(
              child: filtered.isEmpty
                  ? const EmptyState(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'لا توجد محادثات نشطة حالياً',
                      description: 'ستظهر هنا جولات التفاوض والمحادثات المفتوحة مع الموردين حول طلباتك.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) => AppSpacing.hMD,
                      itemBuilder: (context, index) {
                        final conv = filtered[index];
                        return ConversationCardWidget(
                          conversation: conv,
                          onTap: () => context.push('/chat/${conv.id}'),
                          onPinToggle: () => notifier.togglePin(conv.id),
                          onMuteToggle: () => notifier.toggleMute(conv.id),
                          onArchiveToggle: () => notifier.toggleArchive(conv.id),
                          onDelete: () {
                            notifier.deleteConversation(conv.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم حذف المحادثة.')),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


