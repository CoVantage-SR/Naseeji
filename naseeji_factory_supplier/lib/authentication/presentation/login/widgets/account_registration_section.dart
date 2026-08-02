import 'package:flutter/material.dart';
import '../../../../core/constants/app_radius.dart';

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

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.rLG,
      ),
      child: Column(
        children: [
          Text(
            'ليس لديك حساب؟',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'اختر نوع الحساب الذي يناسبك للانضمام إلى نسيجي',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
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
                  accentColor: colorScheme.primary,
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
                  accentColor: colorScheme.tertiary,
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
    final colorScheme = theme.colorScheme;

    return Semantics(
      button: true,
      label: '$title - $buttonText',
      hint: subtitle,
      child: Card(
        elevation: 0,
        color: colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.rMD,
        ),
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.rMD,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: OutlinedButton(
                    onPressed: onPressed,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: accentColor, width: 1.2),
                      foregroundColor: accentColor,
                      padding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.rSM,
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          buttonText,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
