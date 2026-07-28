import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    final faqs = [
      ('كيف يمكنني إرسال طلب عرض سعر (RFQ)؟', 'يمكنك الانتقال إلى قسم الطلبات والضغط على "طلب جديد" وتعبئة المواصفات المحددة.'),
      ('ما هي آلية تحويل عروض الأسعار إلى صفقات؟', 'عند قبول عرض سعر مقدم من مورد، يتم إنشاء صفقة تلقائياً ومتابعة الإنتاج والشحن.'),
      ('كيف يمكنني إضافة موظفين وتحديد صلاحياتهم؟', 'من قسم "إدارة المصنع" ثم "فريق العمل"، اضغط على إضافة موظف وحدد الأدوار والصلاحيات.'),
      ('ما هي طرق الدفع المتاحة في تطبيق نسيجي؟', 'يدعم التطبيق التحويلات البنكية المباشرة، خطابات الضمان، والبطاقات البنكية.'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز المساعدة والدعم'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('الأسئلة الشائعة (FAQ)', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...faqs.map(
            (faq) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: AppRadius.rLG,
                border: Border.all(color: border),
              ),
              child: ExpansionTile(
                title: Text(faq.$1, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(faq.$2, style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
