import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/quotations_controller.dart';
import '../../domain/entities/quotation_model.dart';
import '../widgets/quotation_summary_card.dart';
import '../../../dashboard/presentation/screens/drawer/navigation_drawer_view.dart';

class QuotationsDashboardScreen extends ConsumerStatefulWidget {
  const QuotationsDashboardScreen({super.key});

  @override
  ConsumerState<QuotationsDashboardScreen> createState() => _QuotationsDashboardScreenState();
}

class _QuotationsDashboardScreenState extends ConsumerState<QuotationsDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final List<String> _tabs = [
    'الكل',
    'مسودة',
    'مرسلة',
    'تحت المفاوضات',
    'مقبولة',
    'مرفوضة',
    'منتهية الصلاحية'
  ];

  String _searchQuery = '';
  String _selectedFactory = 'الكل';
  String _selectedCategory = 'الكل';
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

  List<QuotationModel> _filterAndSort(List<QuotationModel> list) {
    // 1. Tab status filter
    List<QuotationModel> filtered = list;
    if (_tabController.index > 0) {
      final QuotationStatus expectedStatus;
      switch (_tabController.index) {
        case 1:
          expectedStatus = QuotationStatus.draft;
          break;
        case 2:
          expectedStatus = QuotationStatus.sent;
          break;
        case 3:
          expectedStatus = QuotationStatus.underNegotiation;
          break;
        case 4:
          expectedStatus = QuotationStatus.accepted;
          break;
        case 5:
          expectedStatus = QuotationStatus.rejected;
          break;
        case 6:
        default:
          expectedStatus = QuotationStatus.expired;
          break;
      }
      filtered = filtered.where((q) => q.status == expectedStatus).toList();
    }

    // 2. Search query filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((q) =>
        q.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        q.rfqNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        q.productName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        q.factoryInfo.factoryName.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // 3. Factory filter
    if (_selectedFactory != 'الكل') {
      filtered = filtered.where((q) => q.factoryInfo.factoryName == _selectedFactory).toList();
    }

    // 4. Category filter
    if (_selectedCategory != 'الكل') {
      filtered = filtered.where((q) => q.productCategory == _selectedCategory).toList();
    }

    // 5. Sorting
    if (_sortBy == 'date_desc') {
      filtered.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    } else if (_sortBy == 'date_asc') {
      filtered.sort((a, b) => a.createdDate.compareTo(b.createdDate));
    } else if (_sortBy == 'price_desc') {
      filtered.sort((a, b) => b.grandTotal.compareTo(a.grandTotal));
    } else if (_sortBy == 'price_asc') {
      filtered.sort((a, b) => a.grandTotal.compareTo(b.grandTotal));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(quotationsControllerProvider);

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
            'لوحة عروض الأسعار والمناقصات',
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
          data: (quotations) {
            final filtered = _filterAndSort(quotations);

            // Calculations for Summary
            final totalCount = quotations.length;
            final draftCount = quotations.where((q) => q.status == QuotationStatus.draft).length;
            final sentCount = quotations.where((q) => q.status == QuotationStatus.sent).length;
            final negoCount = quotations.where((q) => q.status == QuotationStatus.underNegotiation).length;
            final acceptedCount = quotations.where((q) => q.status == QuotationStatus.accepted).length;
            final rejectedCount = quotations.where((q) => q.status == QuotationStatus.rejected).length;
            final expiredCount = quotations.where((q) => q.status == QuotationStatus.expired).length;

            final totalValue = quotations
                .where((q) => q.status != QuotationStatus.rejected && q.status != QuotationStatus.expired)
                .map((q) => q.grandTotal)
                .fold(0.0, (prev, element) => prev + element);

            final acceptanceRate = totalCount > 0 ? (acceptedCount / totalCount) * 100 : 0.0;
            final negotiationSuccess = (acceptedCount + negoCount) > 0 
                ? (acceptedCount / (acceptedCount + rejectedCount + negoCount)) * 100 
                : 0.0;

            return RefreshIndicator(
              onRefresh: () => ref.read(quotationsControllerProvider.notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Horizontal Scrolling Summary Cards
                  SizedBox(
                    height: 75,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildSummaryMiniCard('إجمالي العروض', '$totalCount', Colors.blue),
                        _buildSummaryMiniCard('المسودات الحالية', '$draftCount', Colors.grey),
                        _buildSummaryMiniCard('العروض المرسلة', '$sentCount', Colors.blue.shade800),
                        _buildSummaryMiniCard('مفاوضات نشطة', '$negoCount', Colors.orange),
                        _buildSummaryMiniCard('عروض مقبولة', '$acceptedCount', Colors.green),
                        _buildSummaryMiniCard('عروض مرفوضة', '$rejectedCount', Colors.red),
                        _buildSummaryMiniCard('عروض منتهية', '$expiredCount', Colors.purple),
                        _buildSummaryMiniCard('القيمة المتداولة الكلية', '${totalValue.toStringAsFixed(0)} ر.س', Colors.teal),
                        _buildSummaryMiniCard('معدل قبول العروض', '${acceptanceRate.toStringAsFixed(1)}%', Colors.green.shade800),
                        _buildSummaryMiniCard('نجاح المفاوضات', '${negotiationSuccess.toStringAsFixed(1)}%', Colors.cyan),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search, Sort & Filters Row
                  _buildSearchAndFiltersRow(context, quotations),
                  const SizedBox(height: 12),

                  // List Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'عروض الأسعار المتاحة (${filtered.length})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.onSurface),
                      ),
                      IconButton(
                        icon: const Icon(Icons.sync_outlined, size: 18, color: AppColors.outline),
                        onPressed: () => ref.read(quotationsControllerProvider.notifier).refresh(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (filtered.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Text(
                          'لا توجد عروض أسعار تطابق خيارات التصفية الحالية.',
                          style: TextStyle(fontSize: 11, color: AppColors.outline),
                        ),
                      ),
                    )
                  else
                    ...filtered.map((q) => QuotationSummaryCard(
                      quotation: q,
                      onView: () => context.push('/quotations/details/${q.id}'),
                      onOpenChat: () => context.push('/orders/chat?rfqId=${q.rfqNumber}'),
                      onTimeline: () => context.push('/quotations/history/${q.id}'),
                      onDuplicate: () {
                        ref.read(quotationsControllerProvider.notifier).duplicate(q.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم تكرار عرض السعر ${q.id} كمسودة جديدة')),
                        );
                      },
                      onSharePdf: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم توليد ومشاركة ملف PDF المعتمد لعرض السعر ${q.id}')),
                        );
                      },
                    )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryMiniCard(String label, String value, Color color) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x03000000), blurRadius: 6)],
        border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 8, color: AppColors.outline)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFiltersRow(BuildContext context, List<QuotationModel> allQuotations) {
    final factories = ['الكل', ...allQuotations.map((q) => q.factoryInfo.factoryName).toSet()];
    final categories = ['الكل', ...allQuotations.map((q) => q.productCategory).toSet()];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x02000000), blurRadius: 8)],
      ),
      child: Column(
        children: [
          // Search Field
          TextField(
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            decoration: InputDecoration(
              hintText: 'ابحث برقم العرض أو RFQ أو اسم المنتج...',
              hintStyle: const TextStyle(color: AppColors.outline, fontSize: 11),
              prefixIcon: const Icon(Icons.search, color: AppColors.outline, size: 18),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE2E1EF)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE2E1EF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 1),
              ),
              fillColor: AppColors.background,
              filled: true,
            ),
          ),
          const SizedBox(height: 10),

          // Filters and Sorting Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Factory Filter
                _buildDropdownFilter(
                  label: 'المصنع',
                  value: _selectedFactory,
                  items: factories,
                  onChanged: (val) {
                    setState(() {
                      _selectedFactory = val ?? 'الكل';
                    });
                  },
                ),
                const SizedBox(width: 8),

                // Category Filter
                _buildDropdownFilter(
                  label: 'التصنيف',
                  value: _selectedCategory,
                  items: categories,
                  onChanged: (val) {
                    setState(() {
                      _selectedCategory = val ?? 'الكل';
                    });
                  },
                ),
                const SizedBox(width: 8),

                // Sort Dropdown
                _buildDropdownFilter(
                  label: 'ترتيب حسب',
                  value: _sortBy,
                  items: const ['date_desc', 'date_asc', 'price_desc', 'price_asc'],
                  labels: const {
                    'date_desc': 'التاريخ (الأحدث)',
                    'date_asc': 'التاريخ (الأقدم)',
                    'price_desc': 'السعر (الأعلى)',
                    'price_asc': 'السعر (الأقل)',
                  },
                  onChanged: (val) {
                    setState(() {
                      _sortBy = val ?? 'date_desc';
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String label,
    required String value,
    required List<String> items,
    Map<String, String>? labels,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items.map((val) {
          final displayText = labels != null ? (labels[val] ?? val) : val;
          return DropdownMenuItem<String>(
            value: val,
            child: Text(displayText, style: const TextStyle(fontSize: 10)),
          );
        }).toList(),
        onChanged: onChanged,
        hint: Text(label, style: const TextStyle(fontSize: 10)),
        underline: const SizedBox(),
        isDense: true,
        style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold),
      ),
    );
  }
}
