import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../products/presentation/providers/suppliers_provider.dart';

/// Modal dialog for internal Contact Center communication within the NASEEJI platform.
/// Strictly enforces business rules: No external phone numbers, no WhatsApp, no email exposed.
class InternalContactCenterModal extends StatelessWidget {
  final Supplier supplier;

  const InternalContactCenterModal({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.headset_mic_rounded, color: primaryColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'مركز الاتصال الداخلي المعتمد',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'تواصل مباشر مؤمن داخل منصة ناصيجي مع ${supplier.name}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(height: 24),

          // Security & Business Rule Notice Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.08),
              borderRadius: AppRadius.rSM,
              border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: AppColors.info, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'جميع المحادثات والاتصالات مسجلة ومحفوظة لحماية حقوق المصنع والمورد وتوثيق اتفاقيات توريد ناصيجي.',
                    style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade300 : Colors.grey.shade800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Internal Contact Actions
          _buildContactOption(
            context,
            icon: Icons.record_voice_over_rounded,
            title: 'طلب اتصال صوتي داخلي مباشر',
            subtitle: 'تنسيق مكالمة صوتية مشفرة عبر منصة ناصيجي',
            color: primaryColor,
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إرسال طلب اتصال داخلي إلى ممثل مبيعات ${supplier.name}'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          _buildContactOption(
            context,
            icon: Icons.forum_rounded,
            title: 'فتح محادثة مفاوضات رسمية',
            subtitle: 'بدء شات تفاوض على الأسعار والكميات والمواصفات',
            color: Colors.purple,
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري فتح غرفة المفاوضات المؤقته...')),
              );
            },
          ),
          const SizedBox(height: 12),

          _buildContactOption(
            context,
            icon: Icons.support_agent_rounded,
            title: 'طلب تدخل مستشار ناصيجي كطرف ثالث',
            subtitle: 'فريق ناصيجي يتولى تنسيق عروض الأسعار والتحقق الفني',
            color: Colors.orange.shade800,
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم توجيه مستشار ناصيجي لخدمتكم ومتابعة المورد.')),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.rSM,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : Colors.grey.shade50,
          borderRadius: AppRadius.rSM,
          border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
