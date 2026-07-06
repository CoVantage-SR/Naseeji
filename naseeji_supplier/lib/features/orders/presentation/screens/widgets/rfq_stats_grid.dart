import 'package:flutter/material.dart';
import 'package:naseeji_supplier/features/orders/domain/entities/rfq_stats.dart';
import 'rfq_stat_card.dart';

class RfqStatsGrid extends StatelessWidget {
  final RfqStats stats;

  const RfqStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.8,
      children: [
        RfqStatCard(
          title: 'طلبات جديدة',
          value: stats.newRequests.toString(),
          icon: Icons.verified_outlined,
          color: const Color(0xFF0040E0),
          iconBgColor: const Color(0xFFE8F0FE),
        ),
        RfqStatCard(
          title: 'في انتظار الرد',
          value: stats.awaitingResponse.toString(),
          icon: Icons.hourglass_empty_outlined,
          color: const Color(0xFFD97706),
          iconBgColor: const Color(0xFFFEF3C7),
        ),
        RfqStatCard(
          title: 'تحت التفاوض',
          value: stats.underNegotiation.toString(),
          icon: Icons.handshake_outlined,
          color: const Color(0xFFEA580C),
          iconBgColor: const Color(0xFFFFEDD5),
        ),
        RfqStatCard(
          title: 'تمت الموافقة اليوم',
          value: stats.approvedToday.toString(),
          icon: Icons.check_circle_outline,
          color: const Color(0xFF16A34A),
          iconBgColor: const Color(0xFFDCFCE7),
        ),
      ],
    );
  }
}
