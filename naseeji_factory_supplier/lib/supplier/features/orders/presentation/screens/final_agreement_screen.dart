import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../controllers/final_agreement_controller.dart';
import 'widgets/negotiation_summary_sheet.dart';

class FinalAgreementScreen extends ConsumerWidget {
  final String rfqId;

  const FinalAgreementScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agreementAsync = ref.watch(finalAgreementControllerProvider(rfqId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'تأكيد الاتفاقية النهائية',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/orders/order-center?rfqId=$rfqId');
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: AppColors.onSurfaceVariant),
            onPressed: () {
              if (agreementAsync.valueOrNull != null) {
                final data = agreementAsync.value!;
                showModalBottomSheet(
                  context: context,
                  builder: (context) => NegotiationSummarySheet(
                    originalPrice: data.originalPrice,
                    finalPrice: data.finalPrice,
                    status: 'مؤكدة نهائياً',
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: agreementAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (agreement) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Alert Header
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FE),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF0040E0).withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                'تنبيه: تأكيد هذه الاتفاقية يعتبر التزاماً قانونياً للطرفين لبدء التوريد والإنتاج.',
                                style: TextStyle(fontSize: 11, color: Color(0xFF0040E0), height: 1.4),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.gavel, color: Color(0xFF0040E0), size: 18),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Parties details
                      _buildHeaderSection(agreement),
                      SizedBox(height: 16),

                      // Pricing Comparison card
                      _buildComparisonCard(agreement),
                      SizedBox(height: 16),

                      // Totals & Specs Card
                      _buildDetailsCard(agreement),
                    ],
                  ),
                ),
              ),

              // Bottom Actions
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/orders/order-center?rfqId=$rfqId');
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.outline),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text('رجوع للتفاوض', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showConfirmationDialog(context, agreement.rfqId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0040E0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: const Size(0, 48),
                          ),
                          child: Text(
                            'تأكيد الاتفاقية',
                            style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(dynamic agreement) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('طلب السعر رقم #${agreement.rfqId}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0040E0))),
          SizedBox(height: 12),
          _buildRowItem('اسم المصنع المشتري', agreement.factoryLabel),
          SizedBox(height: 8),
          _buildRowItem('اسم المورد', agreement.supplierLabel),
          SizedBox(height: 8),
          _buildRowItem('اسم المنتج المتفق عليه', agreement.productName),
          SizedBox(height: 8),
          _buildRowItem('تاريخ الاتفاقية', agreement.date),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(dynamic agreement) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('مقارنة الأسعار التاريخية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPriceNode('السعر المبدئي', agreement.originalPrice, Colors.grey),
              const Icon(Icons.arrow_back, color: Colors.grey, size: 16),
              _buildPriceNode('سعر التفاوض', agreement.counterPrice, Colors.orange),
              const Icon(Icons.arrow_back, color: Colors.grey, size: 16),
              _buildPriceNode('الاتفاق النهائي', agreement.finalPrice, const Color(0xFF0040E0), isBold: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceNode(String label, double val, Color color, {bool isBold = false}) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.outline)),
        SizedBox(height: 4),
        Text(
          '${val.toStringAsFixed(2)} جنيه',
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard(dynamic agreement) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('تفاصيل التوريد والرسوم المعتمدة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          SizedBox(height: 12),
          _buildRowItem('الكمية الإجمالية', agreement.quantity),
          SizedBox(height: 10),
          _buildRowItem('تكلفة الشحن', '${agreement.shippingCost.toStringAsFixed(2)} جنيه'),
          SizedBox(height: 10),
          _buildRowItem('ضريبة القيمة المضافة (15%)', '${agreement.taxes.toStringAsFixed(2)} جنيه'),
          SizedBox(height: 10),
          _buildRowItem('شروط وطرق الدفع', agreement.paymentTerms),
          SizedBox(height: 10),
          _buildRowItem('مدة التوصيل والتسليم', agreement.deliveryTime),
          SizedBox(height: 10),
          _buildRowItem('طريقة الشحن', agreement.shippingMethod),
          SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${agreement.totalAmount.toStringAsFixed(2)} جنيه',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0040E0)),
              ),
              Text('إجمالي مبلغ الاتفاقية', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.left)),
        SizedBox(width: 10),
        Text('$label:', style: TextStyle(fontSize: 11, color: AppColors.outline)),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, String rfqId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('تأكيد الاتفاقية نهائياً', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text(
          'هل أنت موافق على كل التفاصيل والأسعار المدرجة بالاتفاقية وتعتبر عقداً نهائياً؟',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('تراجع'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Pop dialog
              context.go('/orders/production-preparation?rfqId=$rfqId'); // Go to production prep next step!
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0040E0), foregroundColor: Colors.white),
            child: Text('تأكيد وتوقيع'),
          ),
        ],
      ),
    );
  }
}
