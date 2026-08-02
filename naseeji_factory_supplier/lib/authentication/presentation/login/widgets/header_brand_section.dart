import 'package:flutter/material.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../l10n/app_localizations.dart';
import 'naseeji_logo_painters.dart';

class HeaderBrandSection extends StatelessWidget {
  const HeaderBrandSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Directional Lead: Logo & Brand Names
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const RepaintBoundary(
                      child: NaseejiInfinityLogo(size: 42),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NASEEJI',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'نســيــجــي',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.brandTagline,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          // Directional Trail: Industrial Factory Backdrop Illustration
          Expanded(
            flex: 5,
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                borderRadius: AppRadius.rLG,
                gradient: LinearGradient(
                  colors: [
                    colorScheme.surface,
                    colorScheme.primary.withValues(alpha: 0.15),
                  ],
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                ),
              ),
              child: ClipRRect(
                borderRadius: AppRadius.rLG,
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: FactoryIllustrationPainter(
                      isDark: theme.brightness == Brightness.dark,
                      colorScheme: colorScheme,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
