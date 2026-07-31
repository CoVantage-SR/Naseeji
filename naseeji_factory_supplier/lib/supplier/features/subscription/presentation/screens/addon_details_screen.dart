import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/subscription_models.dart';

class AddonDetailsScreen extends StatelessWidget {
  final String addonId;
  final AddonItem? addon;

  const AddonDetailsScreen({
    super.key,
    required this.addonId,
    this.addon,
  });

  @override
  Widget build(BuildContext context) {
    // If addon is null, provide a simulated fallback
    final item = addon ?? AddonItem(
      id: addonId,
      name: 'باقة الملحق المختار',
      price: 49.0,
      description: 'أضف موارد إضافية لكتالوج الخامات والمواد الخاص بك دون ترقية خطتك الأساسية.',
      validity: 'ساري طوال فترة الاشتراك الحالي',
      usage: '+50 منتج خام',
      type: AddonType.products,
      quantity: 50,
    );

    final startStr = '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}';
    final expiryStr = '${DateTime.now().year}/${(DateTime.now().month + 1).toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          title: Text(
            'تفاصيل الباقة الإضافية B2B',
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
                // Header card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'تكلفة الملحق: ${item.price.toStringAsFixed(0)} جنيه / تدفع مرة واحدة',
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      const Divider(height: 24, color: AppColors.outlineVariant),
                      _buildInfoRow('حجم الزيادة المضافة للموارد', item.usage),
                      _buildInfoRow('فترة صلاحية الملحق المتاح', item.validity),
                      _buildInfoRow('تاريخ الشراء المقترح', startStr),
                      _buildInfoRow('تاريخ الانتهاء التلقائي للخدمة', expiryStr),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Description card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'نبذة عن الباقة الإضافية للموارد',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                      ),
                      const Divider(height: 20, color: AppColors.outlineVariant),
                      Text(
                        item.description,
                        style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'الشروط والأحكام الخاصة بالملحقات B2B:',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 6),
                      Text(
                        '- يتم شحن الرسوم مباشرة بعد تأكيد الشراء.\n- الملحقات غير قابلة للاسترجاع بعد التفعيل.\n- ترتبط صلاحية بعض الملحقات بصلاحية الباقة الأساسية.',
                        style: TextStyle(fontSize: 9, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.onSurface,
                          side: BorderSide(color: AppColors.outlineVariant),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('العودة للمتجر', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/subscription/checkout', extra: {
                            'addon': item,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0040E0),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('المتابعة للشراء', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}


