import 'package:flutter/material.dart';
import 'package:naseeji_factory/authentication/presentation/login/widgets/naseeji_logo_painters.dart';
import 'account_type_card.dart';

class FactoryCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const FactoryCard({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AccountTypeCard(
      title: 'مصنع',
      description:
          'إذا كنت تمتلك مصنع أو شركة وتبحث عن موردين للمنتجات والخامات والخدمات الصناعية',
      buttonText: 'اختر مصنع',
      icon: Icons.factory_outlined,
      illustration: CustomPaint(
        painter: FactoryIllustrationPainter(isDark: isDark),
        child: Container(),
      ),
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
