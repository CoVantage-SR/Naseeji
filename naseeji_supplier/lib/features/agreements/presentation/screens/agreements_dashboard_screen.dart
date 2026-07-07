import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/features/dashboard/presentation/screens/drawer/navigation_drawer_view.dart';
import '../../domain/entities/agreement_model.dart';
import '../controllers/agreements_controller.dart';
import '../widgets/agreement_summary_card.dart';

class AgreementsDashboardScreen extends ConsumerStatefulWidget {
  const AgreementsDashboardScreen({super.key});

  @override
  ConsumerState<AgreementsDashboardScreen> createState() => _AgreementsDashboardScreenState();
}

class _AgreementsDashboardScreenState extends ConsumerState<AgreementsDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _tabs = ['الكل', 'قيد الموافقة', 'نشطة', 'مكتملة', 'ملغاة', 'منتهية'];
  String _searchQuery = '';
  String _sortBy = 'date_desc'; // 'date_desc', 'date_asc', 'price_desc', 'price_asc'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
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
        key: _scaffoldKey,
        drawer: const NavigationDrawerView(),
        backgroundColor: const Color(0xFFF8F9FF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: const Text(
            'مركز إدارة الاتفاقيات والعقود B2B',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: AppColors.onSurfaceVariant),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: const Color(0xFF0040E0),
            unselectedLabelColor: AppColors.onSurfaceVariant,
            indicatorColor: const Color(0xFF0040E0),
            labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            tabs: _tabs.map((title) => Tab(text: title)).toList(),
          ),
        ),
        body: stateAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (agreements) {
            // Apply search & tab filters
            final filtered = _filterAndSort(agreements);

            // Calculate status totals
            final totalCount = agreements.length;
            final pendingCount = agreements.where((a) => a.status == AgreementStatus.pendingApproval).length;
            final activeCount = agreements.where((a) => a.status == AgreementStatus.active).length;
            final completedCount = agreements.where((a) => a.status == AgreementStatus.completed).length;

            return RefreshIndicator(
              onRefresh: () => ref.read(agreementsControllerProvider.notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Top Summary Horizontal Grid Scroll
                  SizedBox(
                    height: 64,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildSummaryMiniCard('إجمالي العقود', '$totalCount', Colors.blue),
                        _buildSummaryMiniCard('بانتظار موافقتك', '$pendingCount', Colors.orange),
                        _buildSummaryMiniCard('العقود النشطة', '$activeCount', Colors.green),
                        _buildSummaryMiniCard('المسواة المكتملة', '$completedCount', Colors.purple),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search and Sort Row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 4)],
                          ),
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'ابحث باسم المصنع أو رقم العقد...',
                              hintStyle: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 18),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 4)],
                        ),
                        child: DropdownButton<String>(
                          value: _sortBy,
                          underline: const SizedBox.shrink(),
                          icon: const Icon(Icons.swap_vert, size: 18, color: AppColors.outline),
                          items: const [
                            DropdownMenuItem(value: 'date_desc', child: Text('الأحدث تاريخاً', style: TextStyle(fontSize: 10))),
                            DropdownMenuItem(value: 'date_asc', child: Text('الأقدم تاريخاً', style: TextStyle(fontSize: 10))),
                            DropdownMenuItem(value: 'price_desc', child: Text('الأعلى قيمة', style: TextStyle(fontSize: 10))),
                            DropdownMenuItem(value: 'price_asc', child: Text('الأقل قيمة', style: TextStyle(fontSize: 10))),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _sortBy = val;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (filtered.isEmpty)
                    _buildEmptyState()
                  else
                    ...filtered.map((a) => AgreementSummaryCard(a: a)),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryMiniCard(String label, String count, Color color) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(count, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.outline, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  List<B2BAgreement> _filterAndSort(List<B2BAgreement> list) {
    List<B2BAgreement> filtered = List.from(list);

    // Apply Tab Filter
    switch (_tabController.index) {
      case 1:
        filtered = filtered.where((a) => a.status == AgreementStatus.pendingApproval).toList();
        break;
      case 2:
        filtered = filtered.where((a) => a.status == AgreementStatus.active).toList();
        break;
      case 3:
        filtered = filtered.where((a) => a.status == AgreementStatus.completed).toList();
        break;
      case 4:
        filtered = filtered.where((a) => a.status == AgreementStatus.cancelled).toList();
        break;
      case 5:
        filtered = filtered.where((a) => a.status == AgreementStatus.expired).toList();
        break;
    }

    // Apply Search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((a) => 
        a.id.toLowerCase().contains(_searchQuery.toLowerCase()) || 
        a.factoryInfo.factoryName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        a.product.name.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Apply Sorting
    switch (_sortBy) {
      case 'date_asc':
        filtered.sort((x, y) => x.createdDate.compareTo(y.createdDate));
        break;
      case 'price_desc':
        filtered.sort((x, y) => y.pricing.grandTotal.compareTo(x.pricing.grandTotal));
        break;
      case 'price_asc':
        filtered.sort((x, y) => x.pricing.grandTotal.compareTo(y.pricing.grandTotal));
        break;
      default: // date_desc
        filtered.sort((x, y) => y.createdDate.compareTo(x.createdDate));
        break;
    }

    return filtered;
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      alignment: Alignment.center,
      child: const Column(
        children: [
          Icon(Icons.handshake_outlined, size: 54, color: AppColors.outlineVariant),
          SizedBox(height: 12),
          Text('لا توجد اتفاقيات أو عقود مطابقة حالياً', style: TextStyle(color: AppColors.outline, fontSize: 11)),
        ],
      ),
    );
  }
}
