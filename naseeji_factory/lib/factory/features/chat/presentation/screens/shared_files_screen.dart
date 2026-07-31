import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/chat_provider.dart';
import '../widgets/shared_files_widgets.dart';

class SharedFilesScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const SharedFilesScreen({super.key, required this.conversationId});

  @override
  ConsumerState<SharedFilesScreen> createState() => _SharedFilesScreenState();
}

class _SharedFilesScreenState extends ConsumerState<SharedFilesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _fileTabs = const [
    {'key': 'pdf', 'label': 'مستندات PDF'},
    {'key': 'image', 'label': 'الصور'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _fileTabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesNotifierProvider)[widget.conversationId] ?? [];
    final activeTabKey = _fileTabs[_tabController.index]['key']!;

    // Filter shared files from chat messages
    final sharedMessages = messages.where((m) => m.type == activeTabKey).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملفات المشتركة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              tabs: _fileTabs.map((t) => Tab(text: t['label'])).toList(),
            ),
            const Divider(height: 1),
            Expanded(
              child: sharedMessages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.folder_open_rounded, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'لا توجد ملفات تمت مشاركتها في هذا التصنيف.',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: sharedMessages.length,
                      separatorBuilder: (context, index) => AppSpacing.hMD,
                      itemBuilder: (context, index) {
                        final msg = sharedMessages[index];
                        return FileCardWidget(
                          fileName: msg.content,
                          size: activeTabKey == 'pdf' ? '١.٤ ميجابايت' : '٨٥٠ كيلوبايت',
                          date: msg.time,
                          onView: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('معاينة الملف: ${msg.content}')),
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
