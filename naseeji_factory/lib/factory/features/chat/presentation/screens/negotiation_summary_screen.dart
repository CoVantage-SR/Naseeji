import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/chat_provider.dart';
import '../widgets/negotiation_summary_widgets.dart';

class NegotiationSummaryScreen extends ConsumerWidget {
  final String conversationId;

  const NegotiationSummaryScreen({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversation = ref.watch(chatNotifierProvider.notifier).getConversationById(conversationId);
    final messages = ref.watch(messagesNotifierProvider)[conversationId] ?? [];

    if (conversation == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('المحادثة غير موجودة.')),
      );
    }

    // Calculate details
    final quoteMessages = messages.where((m) => m.type == 'quotation').toList();
    final rounds = quoteMessages.length;

    final double initialPrice = quoteMessages.isNotEmpty ? (quoteMessages.first.quotationPrice ?? 0) : 150.0;
    final double currentPrice = conversation.lastNegotiatedPrice > 0 ? conversation.lastNegotiatedPrice : initialPrice;
    final discountVal = initialPrice - currentPrice;
    final discountPercent = initialPrice > 0 ? (discountVal / initialPrice) * 100 : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ملخص جولة التفاوض'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SummaryHeaderWidget(title: 'ملخص المفاوضات: ${conversation.supplierName}'),
              AppSpacing.hMD,
              // Statistics cards grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _buildStatCard('السعر الأولي المقترح', '${initialPrice.toInt()} ج.م', Icons.arrow_upward_rounded, AppColors.error),
                  _buildStatCard('السعر التفاوضي الحالي', '${currentPrice.toInt()} ج.م', Icons.arrow_downward_rounded, AppColors.success),
                  _buildStatCard('إجمالي قيمة الخصم', '${discountVal.toInt()} ج.م', Icons.money_off_rounded, AppColors.primary),
                  _buildStatCard('نسبة الخصم المحققة', '${discountPercent.toStringAsFixed(1)}%', Icons.percent_rounded, AppColors.secondary),
                ],
              ),
              AppSpacing.hLG,
              // Round count detail card
              PrimaryCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مؤشرات المفاوضة والنشاط',
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildRow('عدد جولات المراجعة', '$rounds جولات تعديل'),
                    _buildRow('مطلق المفاوضة الأولي', 'المورد (غزل المحلة)'),
                    _buildRow('حالة الصفقة النهائية', conversation.negotiationStatus == 'agreed' ? 'تم توقيع العقد المالي' : 'قيد المراجعة والمناقشة'),
                  ],
                ),
              ),
              AppSpacing.hLG,
              // Price Revisions Timeline card
              PrimaryCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تسلسل الأسعار عبر جولات التعديل',
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AppSpacing.hMD,
                    if (quoteMessages.isEmpty)
                      const Center(child: Text('لم يتم تبادل عروض أسعار تفصيلية بعد.'))
                    else
                      for (int i = 0; i < quoteMessages.length; i++) ...[
                        TimelineTile(
                          title: 'إصدار عرض سعر رقم #${quoteMessages[i].quotationVersion}',
                          description: 'بقيمة ${quoteMessages[i].quotationPrice?.toInt()} ج.م - حد أدنى ${quoteMessages[i].quotationMoq} وحدة',
                          time: quoteMessages[i].time,
                          icon: Icons.check_circle_outline_rounded,
                          color: i == quoteMessages.length - 1 ? AppColors.success : Colors.grey,
                          isLast: i == quoteMessages.length - 1,
                        ),
                      ],
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return PrimaryCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 9),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
        ],
      ),
    );
  }
}
