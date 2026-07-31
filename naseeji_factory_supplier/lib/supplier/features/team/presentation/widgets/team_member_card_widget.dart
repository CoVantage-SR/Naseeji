import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/team_member_model.dart';
import '../providers/team_providers.dart';

class TeamMemberCardWidget extends ConsumerWidget {
  final TeamMemberModel member;

  const TeamMemberCardWidget({super.key, required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => context.push('/team/details/${member.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Right: Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    member.avatarUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFEFF6FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person_rounded, color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB), size: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Middle: Name, Role Badge, Email, Phone
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & Role Badge
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              member.name,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF111827),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: member.roleBgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(member.roleIcon, size: 11, color: member.roleIconColor),
                                const SizedBox(width: 3),
                                Text(
                                  member.roleTitle,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: member.roleIconColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),

                      // Email
                      Text(
                        member.email,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      // Phone
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          member.phone,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Left: Status Badge, Last Login, 3-Dots Menu & Arrow
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: member.status.bgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: member.status.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                member.status.titleAr,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: member.status.color,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Options Popup Menu
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF9CA3AF), size: 20),
                          onSelected: (action) => _handleMenuAction(context, ref, action),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'details',
                              child: Text('عرض التفاصيل والصلاحيات', style: TextStyle(fontSize: 12)),
                            ),
                            if (member.status == MemberStatus.pending)
                              const PopupMenuItem(
                                value: 'resend',
                                child: Text('إعادة إرسال الدعوة', style: TextStyle(fontSize: 12)),
                              ),
                            if (!member.isOwner)
                              PopupMenuItem(
                                value: member.status == MemberStatus.active ? 'deactivate' : 'activate',
                                child: Text(
                                  member.status == MemberStatus.active ? 'تعطيل الحساب' : 'تفعيل الحساب',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            if (!member.isOwner)
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('حذف العضو', style: TextStyle(fontSize: 12, color: Colors.red)),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Last Login Text
                    Row(
                      children: [
                        Text(
                          'آخر دخول:\n${member.lastLoginText}',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF9CA3AF),
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_left_rounded, size: 16, color: Color(0xFF9CA3AF)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    final notifier = ref.read(teamMembersNotifierProvider.notifier);

    switch (action) {
      case 'details':
        context.push('/team/details/${member.id}');
        break;
      case 'resend':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تمت إعادة إرسال دعوة الانضمام إلى ${member.email}'),
            backgroundColor: const Color(0xFF2563EB),
          ),
        );
        break;
      case 'deactivate':
        notifier.toggleMemberStatus(member.id, MemberStatus.inactive);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تعطيل حساب ${member.name}')),
        );
        break;
      case 'activate':
        notifier.toggleMemberStatus(member.id, MemberStatus.active);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تفعيل حساب ${member.name}')),
        );
        break;
      case 'delete':
        if (member.isOwner) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('لا يمكن حذف مالك المنشأة الرئيسية'), backgroundColor: Colors.red),
          );
          return;
        }
        notifier.deleteMember(member.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حذف العضو ${member.name}')),
        );
        break;
    }
  }
}


