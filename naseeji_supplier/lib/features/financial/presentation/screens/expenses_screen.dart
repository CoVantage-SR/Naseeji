import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../widgets/financial_chart_widget.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseData = [
      {'label': 'عمولات منصة نسيجي', 'value': 11400.0, 'percent': 42.0, 'color': 0xFF0040E0},
      {'label': 'تكاليف الشحن والتوريد', 'value': 5400.0, 'percent': 20.0, 'color': 0xFF009688},
      {'label': 'الضرائب (ضريبة القيمة المضافة)', 'value': 4890.0, 'percent': 18.0, 'color': 0xFFFF9800},
      {'label': 'تكاليف الإعلانات والترويج', 'value': 2500.0, 'percent': 9.2, 'color': 0xFFE91E63},
      {'label': 'اشتراكات الباقة والمزايا', 'value': 1500.0, 'percent': 5.5, 'color': 0xFF9C27B0},
      {'label': 'رسوم الخدمات والتحويلات البنكية', 'value': 430.0, 'percent': 1.6, 'color': 0xFF607D8B},
      {'label': 'مصاريف تسويات أخرى', 'value': 1000.0, 'percent': 3.7, 'color': 0xFF795548},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تحليل المصروفات والرسوم',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Total expenses card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFBA1A1A), Color(0xFFFF5E5E)],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFBA1A1A).withValues(alpha: 0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'إجمالي المصروفات والرسوم المقتطعة',
                      style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '27,120.00 ر.س',
                      style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'تمثل ١٧.٥٪ من إجمالي الإيرادات الكلية للمؤسسة',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 10),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Donut Breakdown chart
              FinancialChartWidget(
                title: 'توزيع هيكل التكاليف والمصروفات',
                data: expenseData,
                type: 'donut',
              ),
              SizedBox(height: 20),

              // Detailed List
              Text(
                'تفاصيل بنود المصروفات والرسوم',
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
                  children: List.generate(expenseData.length, (index) {
                    final item = expenseData[index];
                    final colorVal = item['color'] as int;
                    final valStr = '${(item['value'] as double).toStringAsFixed(2)} ر.س';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    valStr,
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                  Text(
                                    '${(item['percent'] as double).toStringAsFixed(1)}٪ من المصروفات',
                                    style: TextStyle(fontSize: 9, color: AppColors.outline),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    item['label'] as String,
                                    style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Color(colorVal),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (index < expenseData.length - 1)
                            const Divider(height: 16, color: AppColors.outlineVariant),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
