import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/agreements_controller.dart';
import '../widgets/agreement_header_widget.dart';
import '../widgets/agreement_status_widget.dart';
import '../widgets/deal_summary_widget.dart';
import '../widgets/production_info_widget.dart';
import '../widgets/payment_info_widget.dart';
import '../widgets/delivery_info_widget.dart';
import '../widgets/terms_widget.dart';
import '../widgets/attachments_widget.dart';
import '../widgets/agreement_signature_widget.dart';
import '../widgets/agreement_timeline_widget.dart';
import '../widgets/agreement_action_buttons_widget.dart';
import '../widgets/agreement_loading_widget.dart';
import '../widgets/agreement_error_state_widget.dart';
import '../widgets/agreement_empty_state_widget.dart';

class AgreementDetailsScreen extends ConsumerWidget {
  final String agreementId;

  const AgreementDetailsScreen({super.key, required this.agreementId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agreementAsync = ref.watch(agreementDetailsProvider(agreementId));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                'تفاصيل الاتفاقية الرسمية',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                agreementId.isNotEmpty ? agreementId : 'اتفاق جديد',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined, size: 20),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم نسخ رابط الاتفاقية $agreementId')),
                );
              },
            ),
          ],
        ),
        body: agreementAsync.when(
          loading: () => const LoadingWidget(message: 'جاري جلب بنود وسجلات الاتفاقية...'),
          error: (err, stack) => ErrorStateWidget(
            errorMessage: 'حدث خطأ أثناء تحميل الاتفاقية: $err',
            onRetry: () => ref.invalidate(agreementDetailsProvider(agreementId)),
          ),
          data: (agreement) {
            if (agreement == null) {
              return const EmptyStateWidget(
                title: 'الاتفاقية غير موجودة',
                description: 'لم نتمكن من العثور على الاتفاقية المطلوبة بحسابك.',
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Header Card (Agreement #, RFQ #, Quote #, Parties)
                  AgreementHeaderWidget(agreement: agreement),
                  const SizedBox(height: 16),

                  // 2. Status & Progression Card
                  AgreementStatusWidget(status: agreement.status),
                  const SizedBox(height: 16),

                  // 3. Section 1: Deal Summary (القسم الأول: ملخص الصفقة والمنتج)
                  DealSummaryWidget(product: agreement.product),
                  const SizedBox(height: 16),

                  // 4. Section 2: Production (القسم الثاني: الإنتاج والتصنيع)
                  ProductionInfoWidget(production: agreement.production),
                  const SizedBox(height: 16),

                  // 5. Section 3: Payment (القسم الثالث: شروط وبنود الدفع)
                  PaymentInfoWidget(payment: agreement.payment),
                  const SizedBox(height: 16),

                  // 6. Section 4: Delivery (القسم الرابع: التسليم واللوجستيات)
                  DeliveryInfoWidget(delivery: agreement.delivery),
                  const SizedBox(height: 16),

                  // 7. Section 5: Terms (القسم الخامس: الشروط القياسية للمنصة)
                  TermsWidget(terms: agreement.terms),
                  const SizedBox(height: 16),

                  // 8. Section 6: Attachments (القسم السادس: المستندات والمرفقات)
                  AttachmentsWidget(documents: agreement.documents),
                  const SizedBox(height: 16),

                  // 9. Section 7: Signature (القسم السابع: التوقيع والاعتماد)
                  AgreementSignatureWidget(agreement: agreement),
                  const SizedBox(height: 16),

                  // 10. Audit Timeline (الخط الزمني وسجل الإجراءات)
                  AgreementTimelineWidget(timeline: agreement.timeline),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: agreementAsync.maybeWhen(
          data: (agreement) => agreement != null
              ? AgreementActionButtonsWidget(agreement: agreement)
              : null,
          orElse: () => null,
        ),
      ),
    );
  }
}

