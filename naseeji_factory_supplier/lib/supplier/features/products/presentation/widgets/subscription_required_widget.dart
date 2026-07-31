import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/widgets/general_widgets.dart';

class SubscriptionRequiredWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onChoosePlan;

  const SubscriptionRequiredWidget({
    super.key,
    this.title = 'ابدأ البيع والتوريد في نسيجي',
    this.subtitle = 'اشترك في إحدى باقاتنا المميزة للتمكن من إضافة وإدارة منتجات خامات المنسوجات والأقمشة الخاصة بك.',
    this.onChoosePlan,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon / Illustration
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF0040E0).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '📦',
                  style: TextStyle(fontSize: 48),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),

            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),

            // Buttons
            PrimaryButton(
              text: 'اختيار الباقة المناسبة',
              onPressed: onChoosePlan ?? () => context.push('/subscription/plans'),
            ),
            SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.push('/subscription/comparison'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0040E0),
                side: const BorderSide(color: Color(0xFF0040E0)),
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'معرفة المزيد عن المزايا',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


