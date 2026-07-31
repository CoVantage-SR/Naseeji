import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deals_provider.g.dart';

// ─────────────────────────────────────────────────────────────
//  Enums & Status Constants
// ─────────────────────────────────────────────────────────────

class DealStatus {
  static const String active = 'active';
  static const String inProduction = 'inProduction';
  static const String inShipping = 'inShipping';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';

  static String label(String status) {
    switch (status) {
      case active:
        return 'نشطة';
      case inProduction:
        return 'قيد الإنتاج';
      case inShipping:
        return 'قيد الشحن';
      case completed:
        return 'مكتملة';
      case cancelled:
        return 'ملغاة';
      default:
        return status;
    }
  }
}

// ─────────────────────────────────────────────────────────────
//  Workflow Step Model
// ─────────────────────────────────────────────────────────────

enum WorkflowStepState { completed, active, pending }

class DealWorkflowStep {
  final String key;
  final String label;
  final WorkflowStepState state;

  const DealWorkflowStep({
    required this.key,
    required this.label,
    required this.state,
  });
}

// ─────────────────────────────────────────────────────────────
//  Deal Domain Model
// ─────────────────────────────────────────────────────────────

class DealModel {
  final String id;
  final String rfqId;
  final String productName;
  final String supplierName;
  final String supplierShortName;
  final String specs; // e.g. "100,000 متر • قطن • 100% • أبيض"
  final double dealValue;
  final String currency;
  final double paidPercentage;
  final String deliveryDate;
  final String status;
  final String lastUpdated;
  final List<DealWorkflowStep> workflowSteps;

  const DealModel({
    required this.id,
    required this.rfqId,
    required this.productName,
    required this.supplierName,
    required this.supplierShortName,
    required this.specs,
    required this.dealValue,
    required this.currency,
    required this.paidPercentage,
    required this.deliveryDate,
    required this.status,
    required this.lastUpdated,
    required this.workflowSteps,
  });

  DealModel copyWith({
    String? status,
    double? paidPercentage,
    String? lastUpdated,
    List<DealWorkflowStep>? workflowSteps,
  }) {
    return DealModel(
      id: id,
      rfqId: rfqId,
      productName: productName,
      supplierName: supplierName,
      supplierShortName: supplierShortName,
      specs: specs,
      dealValue: dealValue,
      currency: currency,
      paidPercentage: paidPercentage ?? this.paidPercentage,
      deliveryDate: deliveryDate,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      workflowSteps: workflowSteps ?? this.workflowSteps,
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Deals Summary Model
// ─────────────────────────────────────────────────────────────

class DealsSummary {
  final int total;
  final int active;
  final int inProduction;
  final int inShipping;
  final int completed;

  const DealsSummary({
    required this.total,
    required this.active,
    required this.inProduction,
    required this.inShipping,
    required this.completed,
  });
}

// ─────────────────────────────────────────────────────────────
//  Tab Keys
// ─────────────────────────────────────────────────────────────

class DealTab {
  static const String all = 'all';
  static const String active = 'active';
  static const String inProduction = 'inProduction';
  static const String inShipping = 'inShipping';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
}

// ─────────────────────────────────────────────────────────────
//  Helper: Build Workflow Steps from Status
// ─────────────────────────────────────────────────────────────

List<DealWorkflowStep> _buildWorkflow(String status) {
  // Steps: اتفاق → إنتاج → شحن → تسليم → دفع
  const steps = [
    ('agreement', 'اتفاق'),
    ('production', 'إنتاج'),
    ('shipping', 'شحن'),
    ('delivery', 'تسليم'),
    ('payment', 'دفع'),
  ];

  int activeIndex;
  switch (status) {
    case DealStatus.active:
      activeIndex = 0;
    case DealStatus.inProduction:
      activeIndex = 1;
    case DealStatus.inShipping:
      activeIndex = 2;
    case DealStatus.completed:
      activeIndex = 4;
    default:
      activeIndex = -1; // cancelled
  }

  return steps.indexed.map((entry) {
    final i = entry.$1;
    final key = entry.$2.$1;
    final label = entry.$2.$2;
    WorkflowStepState state;
    if (activeIndex < 0) {
      state = i == 0 ? WorkflowStepState.completed : WorkflowStepState.pending;
    } else if (i < activeIndex) {
      state = WorkflowStepState.completed;
    } else if (i == activeIndex) {
      state = WorkflowStepState.active;
    } else {
      state = WorkflowStepState.pending;
    }
    return DealWorkflowStep(key: key, label: label, state: state);
  }).toList();
}

// ─────────────────────────────────────────────────────────────
//  Notifiers
// ─────────────────────────────────────────────────────────────

@riverpod
class DealsNotifier extends _$DealsNotifier {
  @override
  List<DealModel> build() => _mockDeals;

  DealModel? getById(String id) {
    try {
      return state.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  void advanceStep(String id) {
    state = [
      for (final d in state)
        if (d.id == id) _advance(d) else d
    ];
  }

  DealModel _advance(DealModel d) {
    String nextStatus;
    switch (d.status) {
      case DealStatus.active:
        nextStatus = DealStatus.inProduction;
      case DealStatus.inProduction:
        nextStatus = DealStatus.inShipping;
      case DealStatus.inShipping:
        nextStatus = DealStatus.completed;
      default:
        return d;
    }
    return d.copyWith(
      status: nextStatus,
      workflowSteps: _buildWorkflow(nextStatus),
      lastUpdated: 'الآن',
    );
  }

  void cancelDeal(String id) {
    state = [
      for (final d in state)
        if (d.id == id)
          d.copyWith(
            status: DealStatus.cancelled,
            workflowSteps: _buildWorkflow(DealStatus.cancelled),
            lastUpdated: 'الآن',
          )
        else
          d
    ];
  }
}

@riverpod
class DealsFilterNotifier extends _$DealsFilterNotifier {
  @override
  String build() => DealTab.all;

  void setFilter(String tab) => state = tab;
}

@riverpod
class DealsSearchNotifier extends _$DealsSearchNotifier {
  @override
  String build() => '';

  void setQuery(String q) => state = q;
  void clear() => state = '';
}

// ─────────────────────────────────────────────────────────────
//  Computed Providers
// ─────────────────────────────────────────────────────────────

@riverpod
List<DealModel> filteredDeals(FilteredDealsRef ref) {
  final all = ref.watch(dealsNotifierProvider);
  final filter = ref.watch(dealsFilterNotifierProvider);
  final query = ref.watch(dealsSearchNotifierProvider);

  var result = all;
  if (filter != DealTab.all) {
    result = result.where((d) => d.status == filter).toList();
  }
  if (query.isNotEmpty) {
    final lower = query.toLowerCase();
    result = result.where((d) {
      return d.id.toLowerCase().contains(lower) ||
          d.productName.toLowerCase().contains(lower) ||
          d.supplierName.toLowerCase().contains(lower) ||
          d.rfqId.toLowerCase().contains(lower);
    }).toList();
  }
  return result;
}

@riverpod
DealsSummary dealsSummary(DealsSummaryRef ref) {
  final all = ref.watch(dealsNotifierProvider);
  return DealsSummary(
    total: all.length,
    active: all.where((d) => d.status == DealStatus.active).length,
    inProduction: all.where((d) => d.status == DealStatus.inProduction).length,
    inShipping: all.where((d) => d.status == DealStatus.inShipping).length,
    completed: all.where((d) => d.status == DealStatus.completed).length,
  );
}

// ─────────────────────────────────────────────────────────────
//  Mock Data — Matches the screenshot
// ─────────────────────────────────────────────────────────────

final List<DealModel> _mockDeals = [
  DealModel(
    id: 'DEAL-2024-0018',
    rfqId: 'RFQ-2024-0123',
    productName: 'أقمشة قطبية 100%',
    supplierName: 'مصنع النسيج الحديث',
    supplierShortName: 'مصنع\nالنسيج\nالحديث',
    specs: '100,000 متر • قطن • 100% • أبيض',
    dealValue: 125000,
    currency: 'ج.م',
    paidPercentage: 30,
    deliveryDate: '15 يونيو 2024',
    status: DealStatus.active,
    lastUpdated: 'منذ ساعتين',
    workflowSteps: _buildWorkflow(DealStatus.active),
  ),
  DealModel(
    id: 'DEAL-2024-0017',
    rfqId: 'RFQ-2024-0122',
    productName: 'خيوط بوليستر DTY',
    supplierName: 'شركة مصر للخيوط',
    supplierShortName: 'مصر\nللخيوط',
    specs: '5,000 كجم • بوليستر • 100% • أنسجة',
    dealValue: 82500,
    currency: 'ج.م',
    paidPercentage: 60,
    deliveryDate: '28 مايو 2024',
    status: DealStatus.inProduction,
    lastUpdated: 'أمس 10:30 م',
    workflowSteps: _buildWorkflow(DealStatus.inProduction),
  ),
  DealModel(
    id: 'DEAL-2024-0016',
    rfqId: 'RFQ-2024-0121',
    productName: 'أصباغ تفاعلية',
    supplierName: 'الوطنية للكيماويات',
    supplierShortName: 'الوطنية\nللكيماويات',
    specs: '2,000 كجم • أزرق تركوازي • درجة أولى',
    dealValue: 47200,
    currency: 'ج.م',
    paidPercentage: 100,
    deliveryDate: '10 مايو 2024',
    status: DealStatus.inShipping,
    lastUpdated: '02 مايو 2024',
    workflowSteps: _buildWorkflow(DealStatus.inShipping),
  ),
  DealModel(
    id: 'DEAL-2024-0015',
    rfqId: 'RFQ-2024-0120',
    productName: 'إكسسوارات ملبسية',
    supplierName: 'العبور للإكسسوارات',
    supplierShortName: 'العبور\nللإكسسوارات',
    specs: '500,000 قطعة • أزرار معدنية • مقاس 24',
    dealValue: 63800,
    currency: 'ج.م',
    paidPercentage: 20,
    deliveryDate: '20 مايو 2024',
    status: DealStatus.active,
    lastUpdated: '30 أبريل 2024',
    workflowSteps: _buildWorkflow(DealStatus.active),
  ),
  DealModel(
    id: 'DEAL-2024-0014',
    rfqId: 'RFQ-2024-0119',
    productName: 'سوست بلاستيكية',
    supplierName: 'الخليج للإكسسوارات',
    supplierShortName: 'الخليج\nللإكسسوارات',
    specs: '300,000 قطعة • بلاستيك • متعدد الألوان',
    dealValue: 34500,
    currency: 'ج.م',
    paidPercentage: 100,
    deliveryDate: '05 أبريل 2024',
    status: DealStatus.completed,
    lastUpdated: '01 أبريل 2024',
    workflowSteps: _buildWorkflow(DealStatus.completed),
  ),
  DealModel(
    id: 'DEAL-2024-0013',
    rfqId: 'RFQ-2024-0118',
    productName: 'أقمشة جبردين',
    supplierName: 'النيل للمنسوجات',
    supplierShortName: 'النيل\nللمنسوجات',
    specs: '8,000 متر • بوليستر 65% • 35% قطن',
    dealValue: 58000,
    currency: 'ج.م',
    paidPercentage: 30,
    deliveryDate: '15 مارس 2024',
    status: DealStatus.completed,
    lastUpdated: '10 مارس 2024',
    workflowSteps: _buildWorkflow(DealStatus.completed),
  ),
  DealModel(
    id: 'DEAL-2024-0012',
    rfqId: 'RFQ-2024-0117',
    productName: 'علب تغليف مطبوعة',
    supplierName: 'شركة الإسكندرية للتعبئة',
    supplierShortName: 'الإسكندرية\nللتعبئة',
    specs: '100,000 علبة • كرتون مضلع • 35×25×8 سم',
    dealValue: 28000,
    currency: 'ج.م',
    paidPercentage: 50,
    deliveryDate: '28 فبراير 2024',
    status: DealStatus.inProduction,
    lastUpdated: '20 فبراير 2024',
    workflowSteps: _buildWorkflow(DealStatus.inProduction),
  ),
  DealModel(
    id: 'DEAL-2024-0011',
    rfqId: 'RFQ-2024-0116',
    productName: 'خيوط مطاط لازيك',
    supplierName: 'مصنع الخليج للخيوط',
    supplierShortName: 'الخليج\nللخيوط',
    specs: '500 كجم • مطاط مستورد • 1.5 مم',
    dealValue: 18500,
    currency: 'ج.م',
    paidPercentage: 0,
    deliveryDate: '10 يناير 2024',
    status: DealStatus.cancelled,
    lastUpdated: '05 يناير 2024',
    workflowSteps: _buildWorkflow(DealStatus.cancelled),
  ),
  DealModel(
    id: 'DEAL-2024-0010',
    rfqId: 'RFQ-2024-0115',
    productName: 'غزل قطني ممشط',
    supplierName: 'غزل المحلة الكبرى',
    supplierShortName: 'غزل\nالمحلة',
    specs: '12,000 كجم • قطن مصري • نمرة 30/1 سوبر',
    dealValue: 192000,
    currency: 'ج.م',
    paidPercentage: 30,
    deliveryDate: '01 يونيو 2024',
    status: DealStatus.inShipping,
    lastUpdated: '28 مايو 2024',
    workflowSteps: _buildWorkflow(DealStatus.inShipping),
  ),
];

