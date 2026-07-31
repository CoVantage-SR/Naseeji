import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class OperationsLogScreen extends StatelessWidget {
  const OperationsLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> logs = [
      {
        'title': 'تعديل عرض السعر للطلب RFQ-8820',
        'desc': 'تم تقديم سعر وحدة جديد بقيمة 12.50 جنيه للكمية المطلوبة (5000 لفة).',
        'time': 'منذ ساعتين',
        'type': 'quotation',
      },
      {
        'title': 'تحديث حالة الشحن للطلب ORD-2241',
        'desc': 'تعديل مرحلة الطلب إلى "تم الشحن والتوصيل قيد المتابعة".',
        'time': 'منذ 5 ساعات',
        'type': 'shipping',
      },
      {
        'title': 'إضافة منتج جديد للكتالوج',
        'desc': 'تم إضافة منتج "خيوط غزل القطن الفاخر" بنجاح بسعر 80.00 جنيه.',
        'time': 'أمس في 11:30 ص',
        'type': 'product',
      },
      {
        'title': 'شراء باقة الاشتراك المميز',
        'desc': 'تم تجديد الاشتراك السنوي في باقة "النخبة" بقيمة 1,200 جنيه.',
        'time': 'منذ يومين',
        'type': 'subscription',
      },
      {
        'title': 'سحب رصيد للحساب البنكي',
        'desc': 'تم تحويل مبلغ 5,000 جنيه بنجاح إلى الحساب البنكي المسجل.',
        'time': 'منذ 3 أيام',
        'type': 'financial',
      },
      {
        'title': 'تعديل بيانات الشركة الشخصية',
        'desc': 'تحديث السجل التجاري وشهادة الآيزو المعتمدة للمصنع.',
        'time': 'منذ 5 أيام',
        'type': 'profile',
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          title: Text(
            'سجل العمليات والنشاط',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            IconData icon;
            Color color;
            switch (log['type']) {
              case 'quotation':
                icon = Icons.request_quote_outlined;
                color = Colors.blue;
                break;
              case 'shipping':
                icon = Icons.local_shipping_outlined;
                color = Colors.orange;
                break;
              case 'product':
                icon = Icons.inventory_2_outlined;
                color = Colors.green;
                break;
              case 'subscription':
                icon = Icons.card_membership_outlined;
                color = Colors.purple;
                break;
              case 'financial':
                icon = Icons.account_balance_wallet_outlined;
                color = Colors.teal;
                break;
              default:
                icon = Icons.person_outline;
                color = Colors.grey;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              log['title']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              log['time']!,
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.outline,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          log['desc']!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

