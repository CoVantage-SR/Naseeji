import 'package:flutter/material.dart';

class AccountRegistrationSection extends StatelessWidget {
  final VoidCallback onRegisterFactory;
  final VoidCallback onRegisterSupplier;

  const AccountRegistrationSection({
    super.key,
    required this.onRegisterFactory,
    required this.onRegisterSupplier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHighest : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'ليس لديك حساب؟',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? colorScheme.onSurface : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'اختر نوع الحساب الذي يناسبك للانضمام إلى نسيجي',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Supplier Option Card (مورد)
              Expanded(
                child: _RoleCardItem(
                  title: 'مورد',
                  subtitle: 'أبيع منتجاتي وأستقبل طلبات المصانع وتفاوض على الأسعار',
                  buttonText: 'إنشاء حساب كمورد',
                  accentColor: const Color(0xFF2563EB),
                  icon: Icons.inventory_2_outlined,
                  onPressed: onRegisterSupplier,
                ),
              ),
              const SizedBox(width: 12),
              // Factory Option Card (مصنع)
              Expanded(
                child: _RoleCardItem(
                  title: 'مصنع',
                  subtitle: 'أشتري الخامات والمنتجات وأرسل طلبات الشراء',
                  buttonText: 'إنشاء حساب كمصنع',
                  accentColor: const Color(0xFF10B981),
                  icon: Icons.factory_outlined,
                  onPressed: onRegisterFactory,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleCardItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final Color accentColor;
  final IconData icon;
  final VoidCallback onPressed;

  const _RoleCardItem({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.accentColor,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10.5,
              color: isDark ? theme.colorScheme.onSurfaceVariant : const Color(0xFF64748B),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 34,
            child: OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: accentColor, width: 1),
                foregroundColor: accentColor,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
