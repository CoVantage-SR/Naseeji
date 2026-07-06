import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/rfq_details.dart';
import '../../domain/entities/rfq_stats.dart';
import '../../domain/entities/rfq_item.dart';
import '../../domain/repositories/orders_repository.dart';

part 'orders_repository_impl.g.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  @override
  Future<RfqStats> getRfqStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const RfqStats(
      newRequests: 12,
      awaitingResponse: 5,
      underNegotiation: 8,
      approvedToday: 4,
    );
  }

  @override
  Future<List<RfqItem>> getRfqItems() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      RfqItem(
        companyName: 'مصنع الرياض للملابس',
        rfqNumber: 'RFQ-8820',
        material: 'Cotton 100%',
        status: 'جديد',
        statusColorValue: 0xFF0040E0,
        statusBgColorValue: 0xFFE8F0FE,
        quantity: '5,000 م',
        location: 'الرياض، SA',
        dateLabel: 'تاريخ الطلب',
        dateValue: 'منذ ساعتين',
        logoText: 'RC',
        logoBgColorValue: 0xFF0040E0,
        actionButtonText: 'تقديم عرض',
        actionButtonColorValue: 0xFF0040E0,
        actionButtonTextColorValue: 0xFFFFFFFF,
        hasIconButton: true,
        iconButtonIconType: 'more',
      ),
      RfqItem(
        companyName: 'حلول جدة للنسيج',
        rfqNumber: 'RFQ-8794',
        material: 'Polyester Silk Blend',
        status: 'تفاوض',
        statusColorValue: 0xFFEA580C,
        statusBgColorValue: 0xFFFFEDD5,
        quantity: '12,500 م',
        location: 'جدة، SA',
        dateLabel: 'تاريخ الطلب',
        dateValue: 'منذ 5 ساعات',
        logoText: 'JT',
        logoBgColorValue: 0xFF006B5F,
        actionButtonText: 'متابعة العرض',
        actionButtonColorValue: 0xFF0040E0,
        actionButtonTextColorValue: 0xFF0040E0,
        actionButtonIsOutlined: true,
        hasIconButton: true,
        iconButtonIconType: 'chat',
      ),
      RfqItem(
        companyName: 'مصنع الدمام للملابس',
        rfqNumber: 'RFQ-8710',
        material: 'Organic Linen',
        status: 'في الانتظار',
        statusColorValue: 0xFF8B5CF6,
        statusBgColorValue: 0xFFF3E8FF,
        quantity: '3,200 م',
        location: 'الدمام، SA',
        dateLabel: 'تاريخ الطلب',
        dateValue: 'أمس، 04:30 م',
        logoText: 'DC',
        logoBgColorValue: 0xFF4B5563,
        actionButtonText: 'تم إرسال العرض',
        actionButtonColorValue: 0xFF9CA3AF,
        actionButtonTextColorValue: 0xFF4B5563,
        actionButtonIsOutlined: true,
        hasIconButton: false,
      ),
      RfqItem(
        companyName: 'شركة الأزياء الموحدة',
        rfqNumber: 'RFQ-8655',
        material: 'Wool Blend',
        status: 'تمت الموافقة',
        statusColorValue: 0xFF16A34A,
        statusBgColorValue: 0xFFDCFCE7,
        quantity: '8,000 م',
        location: 'المدينة، SA',
        dateLabel: 'تاريخ الموافقة',
        dateValue: 'اليوم، 10:15 ص',
        logoText: 'UF',
        logoBgColorValue: 0xFFD97706,
        actionButtonText: 'بدء الإنتاج',
        actionButtonColorValue: 0xFF006B5F,
        actionButtonTextColorValue: 0xFFFFFFFF,
        hasIconButton: false,
      ),
    ];
  }

  @override
  Future<RfqDetails> getRfqDetails(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const RfqDetails(
      rfqId: 'NAS-2024-0892',
      companyName: 'الشركة المتحدة للنسيج الذكي',
      contactPerson: 'سارة أحمد',
      status: 'مورد معتمد',
      fabricType: 'قطن 100% (Cotton)',
      quantity: '5,000 متر',
      color: 'Indigo',
      weight: 'GSM 180',
      quality: 'Premium',
      packagingMethod: 'لفات (Rolls) مع غطاء حماية مزدوج',
      deliveryDestination: 'مستودعات الشركة - مدينة الرياض',
      notes: 'نحن بحاجة إلى متانة عالية وقدرة ممتازة على التنفس لضمان جودة استثنائية لمجموعة الصيف القادمة. يرجى التركيز على ثبات اللون تحت أشعة الشمس.',
    );
  }
}

@riverpod
OrdersRepository ordersRepository(OrdersRepositoryRef ref) {
  return OrdersRepositoryImpl();
}
