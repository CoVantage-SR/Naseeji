import 'package:flutter/material.dart';
import '../../presentation/login/widgets/naseeji_logo_painters.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        const NaseejiInfinityLogo(size: 46),
        const SizedBox(height: 6),
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
    );
  }
}
