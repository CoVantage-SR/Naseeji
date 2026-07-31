import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../../domain/entities/offer_details.dart';

class OfferDetailsHeader extends StatelessWidget {
  final OfferDetails details;

  const OfferDetailsHeader({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF0040E0).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Color(0xFF0040E0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.storefront,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFF72F8E4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_empty_rounded,
                  color: Color(0xFF0040E0),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          details.statusLabel,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        Text(
          details.statusDescription,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class QuickStatsCardsRow extends StatelessWidget {
  final OfferDetails details;

  const QuickStatsCardsRow({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E1EF)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('آخر ظهور', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                    SizedBox(height: 4),
                    Text(details.lastSeen, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(width: 8),
                const Icon(Icons.visibility_outlined, color: Color(0xFF006B5F), size: 20),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E1EF)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('أرسل منذ', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                    SizedBox(height: 4),
                    Text(details.sentTimeAgo, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(width: 8),
                const Icon(Icons.file_upload_outlined, color: Color(0xFF0040E0), size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OrderPhasesTimeline extends StatelessWidget {
  final OfferDetails details;

  const OrderPhasesTimeline({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(details.phases.length, (index) {
        final phase = details.phases[index];
        return _buildTimelineItem(
          phase: phase,
          isFirst: index == 0,
          isLast: index == details.phases.length - 1,
        );
      }),
    );
  }

  Widget _buildTimelineItem({
    required OfferPhase phase,
    bool isFirst = false,
    bool isLast = false,
  }) {
    Color iconBgColor = const Color(0xFFF1F1F5);
    Widget centerIcon = const Icon(Icons.check, size: 14, color: Colors.white);

    if (phase.isCompleted) {
      iconBgColor = const Color(0xFF0040E0);
      centerIcon = const Icon(Icons.check, size: 14, color: Colors.white);
    } else if (phase.isActive) {
      iconBgColor = const Color(0xFFE8F0FE);
      centerIcon = SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFF0040E0),
        ),
      );
    } else if (phase.isFuture) {
      iconBgColor = const Color(0xFFF1F1F5);
      centerIcon = const Icon(Icons.person_outline, size: 14, color: AppColors.outline);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 80,
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              phase.time,
              style: TextStyle(
                fontSize: 10,
                color: phase.isCompleted || phase.isActive ? AppColors.onSurface : AppColors.outline,
                fontWeight: phase.isCompleted || phase.isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          SizedBox(width: 8),
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Center(child: centerIcon),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: phase.isCompleted ? const Color(0xFF0040E0) : const Color(0xFFE2E1EF),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (phase.showPill) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEA),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'مرحلة حرجة',
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                      Text(
                        phase.title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: phase.isFuture ? AppColors.outline : AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    phase.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: phase.isFuture ? AppColors.outline : AppColors.onSurfaceVariant,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineActionButtonBar extends StatelessWidget {
  const TimelineActionButtonBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: SafeArea(
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.notifications_active_outlined, size: 16, color: Colors.white),
              label: Text(
                'إرسال تذكير',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0040E0),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.cancel_outlined, size: 16, color: AppColors.error),
              label: Text(
                'إلغاء العرض',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


