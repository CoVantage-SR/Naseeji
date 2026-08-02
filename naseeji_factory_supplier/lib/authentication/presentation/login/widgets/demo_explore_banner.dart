import 'package:flutter/material.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/theme/role_theme_extension.dart';
import '../../../../l10n/app_localizations.dart';

class DemoExploreBanner extends StatelessWidget {
  final VoidCallback onDemoFactory;
  final VoidCallback onDemoSupplier;

  const DemoExploreBanner({
    super.key,
    required this.onDemoFactory,
    required this.onDemoSupplier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final roleTheme = theme.extension<RoleThemeExtension>() ?? RoleThemeExtension.light;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Semantics(
      button: true,
      label: l10n.exploreDemoText,
      hint: l10n.noAccountSubtitle,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: AppRadius.rMD,
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.rMD,
          child: PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'factory') onDemoFactory();
              if (val == 'supplier') onDemoSupplier();
            },
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.rMD),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'factory',
                child: Row(
                  children: [
                    Icon(Icons.factory_outlined, color: roleTheme.factoryPrimary, size: 20),
                    const SizedBox(width: 8),
                    Text(l10n.demoAsFactory),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'supplier',
                child: Row(
                  children: [
                    Icon(Icons.inventory_2_outlined, color: roleTheme.supplierPrimary, size: 20),
                    const SizedBox(width: 8),
                    Text(l10n.demoAsSupplier),
                  ],
                ),
              ),
            ],
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.explore_outlined,
                      size: 22,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.exploreDemoText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.exploreDemoButton,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
