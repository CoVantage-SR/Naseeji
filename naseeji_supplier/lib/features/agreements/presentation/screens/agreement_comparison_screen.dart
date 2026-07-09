import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/agreements_controller.dart';
import '../widgets/agreement_comparison_table.dart';

class AgreementComparisonScreen extends ConsumerWidget {
  final String agreementId;

  const AgreementComparisonScreen({super.key, required this.agreementId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(agreementsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            'مقارنة عروض الاتفاقية $agreementId',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.onSurfaceVariant,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: stateAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (agreements) {
            final agreementIndex = agreements.indexWhere(
              (a) => a.id == agreementId,
            );
            if (agreementIndex == -1) {
              return const Center(child: Text('الاتفاقية غير موجودة'));
            }
            final a = agreements[agreementIndex];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(color: Color(0x05000000), blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.trending_up,
                              color: AppColors.primary,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'تتبع مسار التفاوض للطلب ${a.orderNumber}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'يوضح الجدول التالي التطور الزمني لبنود التعاقد من بدء طلب الشراء الأول وحتى الاستقرار على شروط الصياغة المعتمدة للاتفاقية النهائية.',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.outline,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Comparison DataTable Widget
                  AgreementComparisonTable(agreement: a),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
