import 'package:flutter/material.dart';
import 'rfq_stat_card.dart';

class RfqStatsGrid extends StatelessWidget {
  const RfqStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.8,
      children: const [
        RfqStatCard(
          title: 'طلبات جديدة',
          value: '12',
          icon: Icons.verified_outlined,
          color: Color(0xFF0040E0),
          iconBgColor: Color(0xFFE8F0FE),
        ),
        RfqStatCard(
          title: 'في انتظار الرد',
          value: '5',
          icon: Icons.hourglass_empty_outlined,
          color: Color(0xFFD97706),
          iconBgColor: Color(0xFFFEF3C7),
        ),
        RfqStatCard(
          title: 'تحت التفاوض',
          value: '8',
          icon: Icons.handshake_outlined,
          color: Color(0xFFEA580C),
          iconBgColor: Color(0xFFFFEDD5),
        ),
        RfqStatCard(
          title: 'تمت الموافقة اليوم',
          value: '4',
          icon: Icons.check_circle_outline,
          color: Color(0xFF16A34A),
          iconBgColor: Color(0xFFDCFCE7),
        ),
      ],
    );
  }
}
