import 'package:flutter/material.dart';
import '../login/widgets/naseeji_logo_painters.dart';

class RegisterLogo extends StatelessWidget {
  const RegisterLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 110,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side (RTL right): Logo & Titles
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const NaseejiInfinityLogo(size: 40),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NASEEJI',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'نســيــجــي',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'منصة النسيج الرقمي للمصانع والموردين',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? theme.colorScheme.onSurfaceVariant : const Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          // Right side (RTL left): Industrial Factory Backdrop Painting
          Expanded(
            flex: 5,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          theme.colorScheme.surface,
                          theme.colorScheme.primary.withValues(alpha: 0.15),
                        ]
                      : [
                          const Color(0xFFFAFCFF),
                          theme.colorScheme.primary.withValues(alpha: 0.08),
                        ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomPaint(
                  painter: FactoryIllustrationPainter(isDark: isDark),
                  child: Container(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
