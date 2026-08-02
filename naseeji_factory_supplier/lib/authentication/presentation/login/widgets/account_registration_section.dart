import 'package:flutter/material.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/theme/role_theme_extension.dart';
import '../../../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final roleTheme = theme.extension<RoleThemeExtension>() ?? RoleThemeExtension.light;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.rLG,
      ),
      child: Column(
        children: [
          Text(
            l10n.noAccountTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.noAccountSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Supplier Option Card
              Expanded(
                child: _RoleCardItem(
                  title: l10n.supplierRoleTitle,
                  subtitle: l10n.supplierRoleSubtitle,
                  buttonText: l10n.supplierRegisterButton,
                  accentColor: roleTheme.supplierPrimary,
                  icon: Icons.inventory_2_outlined,
                  onPressed: onRegisterSupplier,
                ),
              ),
              const SizedBox(width: 12),
              // Factory Option Card
              Expanded(
                child: _RoleCardItem(
                  title: l10n.factoryRoleTitle,
                  subtitle: l10n.factoryRoleSubtitle,
                  buttonText: l10n.factoryRegisterButton,
                  accentColor: roleTheme.factoryPrimary,
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
