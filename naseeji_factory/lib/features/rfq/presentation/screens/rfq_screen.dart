import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/rfq_provider.dart';
import '../widgets/rfq_list_widgets.dart';

class RfqScreen extends ConsumerStatefulWidget {
  const RfqScreen({super.key});

  @override
  ConsumerState<RfqScreen> createState() => _RfqScreenState();
}

class _RfqScreenState extends ConsumerState<RfqScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  final List<Map<String, String>> _statusTabs = const [
    {'key': 'all', 'label': 'الكل'},
    {'key': 'open', 'label': 'مفتوحة'},
    {'key': 'negotiation', 'label': 'تفاوض'},
    {'key': 'approved', 'label': 'معتمدة'},
    {'key': 'rejected', 'label': 'مرفوضة'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allRfqs = ref.watch(rFQNotifierProvider);
    final activeStatusKey = _statusTabs[_tabController.index]['key']!;

    var filteredRfqs = allRfqs;
    if (activeStatusKey != 'all') {
      filteredRfqs = filteredRfqs.where((r) => r.status == activeStatusKey).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filteredRfqs = filteredRfqs
          .where((r) => r.title.contains(_searchQuery) || r.id.contains(_searchQuery))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('طلبات عروض الأسعار (RFQ)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('نظام RFQ يتيح لك طلب عروض أسعار فنية مخصصة من كبار الموردين.')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingCreateRFQButton(
        onTap: () {
          checkGuestAction(
            context,
            ref,
            () => context.push('/rfq/create'),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppSearchBar(
                hintText: 'ابحث برقم الطلب أو العنوان...',
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
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              tabs: _statusTabs.map((tab) => Tab(text: tab['label'])).toList(),
            ),
            const Divider(height: 1),
            Expanded(
              child: filteredRfqs.isEmpty
                  ? const EmptyState(
                      icon: Icons.request_quote_rounded,
                      title: 'لا توجد طلبات تطابق الفلتر الحالي',
                      description: 'ابدأ بالضغط على الزر بالأسفل لإنشاء أول طلب عرض سعر مخصص لمصنعك.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: filteredRfqs.length,
                      separatorBuilder: (context, index) => AppSpacing.hMD,
                      itemBuilder: (context, index) {
                        final rfq = filteredRfqs[index];
                        return RFQCardWidget(
                          rfq: rfq,
                          onTap: () => context.push('/rfq/${rfq.id}'),
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
