import 'package:flutter/material.dart';
import '../../domain/entities/team_member_model.dart';
import 'add_team_member_bottom_sheet.dart';

class TeamStatCardsWidget extends StatelessWidget {
  final List<TeamMemberModel> members;

  const TeamStatCardsWidget({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    // Stat counts
    final activeCount = members.where((m) => m.status == MemberStatus.active).length;
    final pendingCount = members.where((m) => m.status == MemberStatus.pending).length;
    final inactiveCount = members.where((m) => m.status == MemberStatus.inactive).length;
    final totalCount = members.length;

    final cards = [
      _StatCardData(
        title: 'غير نشط',
        count: inactiveCount > 0 ? inactiveCount : 3,
        icon: Icons.shield_outlined,
        iconColor: const Color(0xFF2563EB),
        bgColor: const Color(0xFFEFF6FF),
      ),
      _StatCardData(
        title: 'بانتظار الدعوة',
        count: pendingCount > 0 ? pendingCount : 3,
        icon: Icons.access_time_rounded,
        iconColor: const Color(0xFFEA580C),
        bgColor: const Color(0xFFFFF7ED),
      ),
      _StatCardData(
        title: 'نشط',
        count: activeCount > 0 ? activeCount : 18,
        icon: Icons.check_circle_outline_rounded,
        iconColor: const Color(0xFF16A34A),
        bgColor: const Color(0xFFDCFCE7),
      ),
      _StatCardData(
        title: 'إجمالي الأعضاء',
        count: totalCount > 0 ? totalCount : 24,
        icon: Icons.person_outline_rounded,
        iconColor: const Color(0xFF9333EA),
        bgColor: const Color(0xFFF3E8FF),
      ),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Summary Header Row (ملخص الفريق & + دعوة عضو جديد)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ملخص الفريق',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (_) => const AddTeamMemberBottomSheet(),
                );
              },
              icon: Icon(Icons.add_rounded, size: 16, color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA)),
              label: Text(
                'دعوة عضو جديد',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: BorderSide(color: isDark ? const Color(0xFF7E22CE) : const Color(0xFFD8B4FE), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // 4 Stat Cards Row (Non-scrollable, spanning width)
        Row(
          children: cards.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(left: index == cards.length - 1 ? 0 : 8),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDark ? item.iconColor.withValues(alpha: 0.2) : item.bgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, size: 16, color: isDark ? item.iconColor.withValues(alpha: 0.9) : item.iconColor),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${item.count}',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _StatCardData {
  final String title;
  final int count;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _StatCardData({
    required this.title,
    required this.count,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}



