import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/agreements_controller.dart';
import '../widgets/agreement_timeline_widget.dart';
import '../widgets/agreement_history_card.dart';

class AgreementHistoryScreen extends ConsumerStatefulWidget {
  final String agreementId;

  const AgreementHistoryScreen({super.key, required this.agreementId});

  @override
  ConsumerState<AgreementHistoryScreen> createState() => _AgreementHistoryScreenState();
}

class _AgreementHistoryScreenState extends ConsumerState<AgreementHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['الخط الزمني للمشروع', 'سجل المراجعات والأرشفة'];

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
    final stateAsync = ref.watch(agreementsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            'سجل وزمن الاتفاقية ${widget.agreementId}',
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
            onPressed: () => context.pop(),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF0040E0),
            unselectedLabelColor: AppColors.onSurfaceVariant,
            indicatorColor: const Color(0xFF0040E0),
            labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            tabs: _tabs.map((title) => Tab(text: title)).toList(),
          ),
        ),
        body: stateAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (agreements) {
            final agreementIndex = agreements.indexWhere((a) => a.id == widget.agreementId);
            if (agreementIndex == -1) {
              return const Center(child: Text('الاتفاقية غير موجودة'));
            }
            final a = agreements[agreementIndex];

            return TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Timeline Steps
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                      child: const Text(
                        'يتتبع الخط الزمني التالي مسار الإنتاج، والتحميل والفسح الجمركي، وحالة التوصيل الفعلي وتأكيد استلام وفحص الجودة.',
                        style: TextStyle(fontSize: 10, color: Colors.blue, height: 1.4),
                      ),
                    ),
                    AgreementTimelineWidget(steps: a.timeline),
                  ],
                ),

                // Tab 2: Change History Revision Logs
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(12)),
                      child: const Text(
                        'سجل مراجعات غير قابل للتعديل (Immutable). يتم تسجيل أي تعديل يطرأ على شروط العقد مع حفظ رقم الإصدار للتوافق مع الفوترة والفسح اللوجستي.',
                        style: TextStyle(fontSize: 10, color: Colors.amber, height: 1.4),
                      ),
                    ),
                    if (a.history.isEmpty)
                      const Center(child: Text('لا توجد مراجعات سابقة مسجلة.', style: TextStyle(fontSize: 11, color: AppColors.outline)))
                    else
                      ...a.history.map((record) => AgreementHistoryCard(record: record)),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
