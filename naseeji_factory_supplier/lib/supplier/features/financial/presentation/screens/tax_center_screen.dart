import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../controllers/financial_controllers.dart';

class TaxCenterScreen extends ConsumerWidget {
  const TaxCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taxAsync = ref.watch(financialTaxCenterControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المركز والربط الضريبي',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: taxAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (err, stack) => Center(child: Text('خطأ: $err')),
          data: (data) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => ref.read(financialTaxCenterControllerProvider.notifier).refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tax registration number card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE3FCEF),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'نشط ومربوط (زاتكا)',
                                  style: TextStyle(color: Color(0xFF00875A), fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                'الرقم الضريبي للمنشأة',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            data.taxRegistrationNumber,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.5),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'نسبة ضريبة القيمة المضافة المطبقة: ${data.vatPercentage.toStringAsFixed(0)}٪',
                            style: TextStyle(fontSize: 11, color: AppColors.outline),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // VAT summary card
                    Text(
                      'ملخص ضريبة القيمة المضافة (VAT)',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          _buildTaxRow('الضريبة المحصلة من المبيعات', data.collectedVat, const Color(0xFF00875A)),
                          const Divider(height: 20),
                          _buildTaxRow('الضريبة المدفوعة على المشتريات', data.paidVat, const Color(0xFFBA1A1A)),
                          const Divider(height: 20),
                          _buildTaxRow('صافي المستحقات الضريبية (للهيئة)', data.outstandingVat, AppColors.primary, isBold: true),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Tax documents / certificates
                    Text(
                      'المستندات وشهادات المكلف',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: data.documents.map((doc) {
                          return ListTile(
                            leading: const Icon(Icons.picture_as_pdf, color: Color(0xFFBA1A1A)),
                            title: Text(doc['name'] as String, style: TextStyle(fontSize: 12), textAlign: TextAlign.right),
                            subtitle: Text('تاريخ الإصدار: ${doc['date']}', style: TextStyle(fontSize: 10), textAlign: TextAlign.right),
                            trailing: const Icon(Icons.download, size: 18),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('تحميل مستند ${doc['name']}...')),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20),

                    // VAT submission reports
                    Text(
                      'الإقرارات الضريبية السابقة',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: data.reports.map((rep) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  rep['status'] as String,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF00875A)),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${(rep['vat'] as double).toStringAsFixed(2)} جنيه',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      rep['period'] as String,
                                      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaxRow(String label, double value, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${value.toStringAsFixed(2)} جنيه',
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isBold ? AppColors.onSurface : AppColors.outline,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
