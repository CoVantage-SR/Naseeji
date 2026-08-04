import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';

class VerificationStatusCard extends StatelessWidget {
  final String status; // 'unverified', 'pending', 'verified', 'rejected'
  final String level; // 'guest', 'basic', 'phone_verified', 'identity_verified', 'business_verified', 'premium_verified'
  final VoidCallback? onCompleteVerification;

  const VerificationStatusCard({
    super.key,
    required this.status,
    this.level = 'basic',
    this.onCompleteVerification,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final statusConfig = _getStatusConfig(status, level);

    final benefits = [
      '⭐️ شارة التوثيق الرسمي (Verified Badge)',
      '🔝 أولوية الترتيب والظهور في نتائج البحث (Higher Ranking)',
      '📑 طلبات تسعير غير محدودة (Unlimited RFQs)',
      '📦 طلبات ورسائل صفقات غير محدودة (Unlimited Orders)',
      '🛡️ مؤشر موثوقية مرتفع (High Trust Score)',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? statusConfig['darkBgColor'] as Color : statusConfig['bgColor'] as Color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? statusConfig['darkBorderColor'] as Color : statusConfig['borderColor'] as Color,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    statusConfig['icon'] as IconData,
                    color: statusConfig['badgeColor'] as Color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'حالة التوثيق والاعتماد',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                      color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (statusConfig['badgeColor'] as Color).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusConfig['badgeText'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusConfig['badgeColor'] as Color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            statusConfig['description'] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF475569),
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          if (status != 'verified' && status != 'pending') ...[
            const SizedBox(height: 12),
            const Text(
              'مميزات توثيق حسابك على نسيجي:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: benefits
                  .map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Text(
                          b,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton.icon(
                onPressed: onCompleteVerification ?? () => context.push('/auth/complete-profile'),
                icon: const Icon(Icons.verified_user_outlined, size: 16),
                label: const Text('استكمال التوثيق واحصل على المميزات'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(String status, String level) {
    if (status == 'pending') {
      return {
        'badgeText': '🟡 قيد المراجعة',
        'badgeColor': const Color(0xFFD97706),
        'bgColor': const Color(0xFFFFFBEB),
        'borderColor': const Color(0xFFFCD34D),
        'darkBgColor': const Color(0xFF78350F).withValues(alpha: 0.3),
        'darkBorderColor': const Color(0xFFD97706),
        'icon': Icons.hourglass_top_rounded,
        'description': 'تم إرسال مستنداتك إلى فريق المراجعة. سيتم الرد خلال 24 ساعة.',
      };
    } else if (status == 'verified') {
      final isIdentity = level == 'identity_verified';
      return {
        'badgeText': isIdentity ? '🟢 موثق بالهوية' : '🟢 شركة موثقة',
        'badgeColor': const Color(0xFF16A34A),
        'bgColor': const Color(0xFFF0FDF4),
        'borderColor': const Color(0xFF86EFAC),
        'darkBgColor': const Color(0xFF14532D).withValues(alpha: 0.3),
        'darkBorderColor': const Color(0xFF16A34A),
        'icon': Icons.verified_rounded,
        'description': isIdentity
            ? 'تم التحقق من هويتك الشخصية ونشاطك التجاري بنجاح. تكتسب الآن موثوقية عالية وتصنيف مرتفع.'
            : 'تم التوثيق الرسمي لشركتك/مصنعك بالسجل التجاري والبطاقة الضريبية.',
      };
    } else if (status == 'rejected') {
      return {
        'badgeText': '🔴 مرفوض',
        'badgeColor': const Color(0xFFDC2626),
        'bgColor': const Color(0xFFFEF2F2),
        'borderColor': const Color(0xFFFCA5A5),
        'darkBgColor': const Color(0xFF7F1D1D).withValues(alpha: 0.3),
        'darkBorderColor': const Color(0xFFDC2626),
        'icon': Icons.cancel_outlined,
        'description': 'تم رفض التوثيق. يرجى إعادة رفع مستندات واضحة أو تحديث بيانات النشاط.',
      };
    } else {
      return {
        'badgeText': '⚪ غير موثق (80% اكتمال)',
        'badgeColor': const Color(0xFF64748B),
        'bgColor': const Color(0xFFF8FAFC),
        'borderColor': const Color(0xFFCBD5E1),
        'darkBgColor': const Color(0xFF1E293B),
        'darkBorderColor': const Color(0xFF475569),
        'icon': Icons.shield_outlined,
        'description': 'ملفك الأساسي مكتمل 80%. ارفع مستندات السجل والتكليف أو الهوية الشخصية للحصول على 100% وتوثيق الحساب.',
      };
    }
  }
}
