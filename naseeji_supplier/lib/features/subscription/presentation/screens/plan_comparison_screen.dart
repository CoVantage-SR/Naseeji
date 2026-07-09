import 'package:flutter/material.dart';

class PlanComparisonScreen extends StatelessWidget {
  const PlanComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> comparisonData = [
      {
        'feature': 'المنتجات المسموحة',
        'free': '10 منتجات',
        'starter': '50 منتج',
        'professional': '200 منتج',
        'business': '1,000 منتج'
      },
      {
        'feature': 'الإعلانات الممولة النشطة',
        'free': '1 إعلان نشط',
        'starter': '5 إعلانات',
        'professional': '20 إعلان',
        'business': '100 إعلان'
      },
      {
        'feature': 'المنتجات المتميزة بالمنصة',
        'free': 'غير متاح',
        'starter': '3 منتجات',
        'professional': '10 منتجات',
        'business': '50 منتج'
      },
      {
        'feature': 'مساحة التخزين المتاحة',
        'free': '1 جيجابايت',
        'starter': '5 جيجابايت',
        'professional': '20 جيجابايت',
        'business': '100 جيجابايت'
      },
      {
        'feature': 'الموظفون الإضافيون',
        'free': 'غير متاح',
        'starter': '5 موظفين',
        'professional': '20 موظفاً',
        'business': 'غير محدود'
      },
      {
        'feature': 'عدد الفروع النشطة',
        'free': 'فرع واحد',
        'starter': 'فرعين',
        'professional': '5 فروع',
        'business': '15 فرع'
      },
      {
        'feature': 'حملات تسويقية شهرياً',
        'free': '1 حملة',
        'starter': '10 حملات',
        'professional': '30 حملة',
        'business': 'غير محدود'
      },
      {
        'feature': 'كوبونات الخصم الفعالة',
        'free': '2 كوبون',
        'starter': '20 كوبون',
        'professional': '50 كوبون',
        'business': 'غير محدود'
      },
      {
        'feature': 'تقارير أداء وعائدات',
        'free': 'ملخص عام',
        'starter': 'تقارير عادية',
        'professional': 'تقارير ذكاء اصطناعي',
        'business': 'لوحة متكاملة'
      },
      {
        'feature': 'الاستيراد بالجملة (Bulk)',
        'free': 'غير متاح',
        'starter': 'غير متاح',
        'professional': 'متاح كامل',
        'business': 'متاح كامل'
      },
      {
        'feature': 'ربط واجهة الـ API للربط',
        'free': 'غير متاح',
        'starter': 'غير متاح',
        'professional': 'غير متاح',
        'business': 'متاح بالكامل'
      },
      {
        'feature': 'دعم فني خاص ومخصص',
        'free': 'تذاكر عادية',
        'starter': 'دعم سريع',
        'professional': 'دعم ذو أولوية',
        'business': 'مدير حساب خاص'
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          title: Text(
            'جدول مقارنة الباقات B2B',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'تفاصيل مقارنة الموارد والحدود التقنية للباقات',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 16),

                // Interactive Table
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF252538)
                              : const Color(0xFFF1F3FF),
                        ),
                        columns: [
                          DataColumn(
                            label: Text(
                              'الميزة / الحد التقني',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'المجانية',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'المبتدئ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'الاحترافية',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'الأعمال',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                        rows: comparisonData.map((row) {
                          return DataRow(
                            cells: [
                              DataCell(Text(row['feature'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                              DataCell(Text(row['free'] as String, style: TextStyle(fontSize: 10))),
                              DataCell(Text(row['starter'] as String, style: TextStyle(fontSize: 10))),
                              DataCell(Text(row['professional'] as String, style: TextStyle(fontSize: 10))),
                              DataCell(Text(row['business'] as String, style: TextStyle(fontSize: 10))),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
