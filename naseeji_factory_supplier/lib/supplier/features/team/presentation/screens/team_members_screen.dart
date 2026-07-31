import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/team_member_model.dart';
import '../providers/team_providers.dart';
import '../widgets/team_stat_cards_widget.dart';
import '../widgets/team_member_card_widget.dart';
import '../widgets/add_team_member_bottom_sheet.dart';

class TeamMembersScreen extends ConsumerStatefulWidget {
  const TeamMembersScreen({super.key});

  @override
  ConsumerState<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends ConsumerState<TeamMembersScreen> {
  bool _showBanner = true;

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(teamMembersNotifierProvider);
    final statusFilter = ref.watch(teamStatusFilterProvider);
    final searchQuery = ref.watch(teamSearchQueryProvider);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // 1. Top Custom App Bar Header (RTL)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Right: Group Icon + Title & Subtitle
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3E8FF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.group_outlined,
                            color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'فريق العمل',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'إدارة أعضاء فريق المصنع والصلاحيات',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Left: Back Arrow Button
                    IconButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/profile');
                        }
                      },
                      icon: Icon(
                        Icons.arrow_forward_rounded,
                        color: theme.colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Main Area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // 2. Summary Box: ملخص الفريق & 4 Stat Cards
                      TeamStatCardsWidget(members: members),

                      const SizedBox(height: 16),

                      // 3. Filter Pills Horizontal Row (الكل / نشط / بانتظار الدعوة / غير نشط)
                      _buildFilterPillsRow(ref, statusFilter),

                      const SizedBox(height: 12),

                      // 4. Search & Filter Bar
                      Row(
                        children: [
                          // Filter Button on Left
                          Container(
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                ref
                                        .read(teamStatusFilterProvider.notifier)
                                        .state =
                                    null;
                                ref
                                        .read(teamSearchQueryProvider.notifier)
                                        .state =
                                    '';
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.filter_list_rounded,
                                    size: 18,
                                    color: Color(0xFF6B7280),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'تصفية',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF374151),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Search TextField on Right
                          Expanded(
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: TextField(
                                controller:
                                    TextEditingController(text: searchQuery)
                                      ..selection = TextSelection.collapsed(
                                        offset: searchQuery.length,
                                      ),
                                onChanged: (val) {
                                  ref
                                          .read(
                                            teamSearchQueryProvider.notifier,
                                          )
                                          .state =
                                      val;
                                },
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF111827),
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'ابحث عن عضو...',
                                  hintStyle: TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.search_rounded,
                                    size: 18,
                                    color: Color(0xFF6B7280),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // 5. Team Members List Cards
                      if (members.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(30),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              const Icon(
                                Icons.group_off_rounded,
                                size: 48,
                                color: Color(0xFF9CA3AF),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'لا يوجد أعضاء يطابقون نتائج البحث',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref
                                          .read(
                                            teamStatusFilterProvider.notifier,
                                          )
                                          .state =
                                      null;
                                  ref
                                          .read(
                                            teamSearchQueryProvider.notifier,
                                          )
                                          .state =
                                      '';
                                },
                                child: const Text('إعادة ضبط البحث'),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            return TeamMemberCardWidget(member: members[index]);
                          },
                        ),

                      const SizedBox(height: 12),

                      // 6. Bottom Summary Card (إجمالي الصلاحيات الممنوحة)
                      _buildPermissionsSummaryCard(context),

                      const SizedBox(height: 12),

                      // 7. Bottom Info Banner (إدارة الفريق بسهولة)
                      if (_showBanner) _buildInfoBanner(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Filter Pills Horizontal Row
  // ---------------------------------------------------------------------------
  Widget _buildFilterPillsRow(WidgetRef ref, MemberStatus? selectedStatus) {
    final filters = [
      {'status': null, 'label': 'الكل'},
      {'status': MemberStatus.active, 'label': 'نشط'},
      {'status': MemberStatus.pending, 'label': 'بانتظار الدعوة'},
      {'status': MemberStatus.inactive, 'label': 'غير نشط'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true, // RTL
      child: Row(
        children: filters.map((f) {
          final status = f['status'] as MemberStatus?;
          final label = f['label'] as String;
          final isSelected = selectedStatus == status;

          return Padding(
            padding: const EdgeInsets.only(left: 6),
            child: InkWell(
              onTap: () {
                ref.read(teamStatusFilterProvider.notifier).state = isSelected
                    ? null
                    : status;
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFF3E8FF)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected
                      ? Border.all(color: const Color(0xFFD8B4FE), width: 1)
                      : null,
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF9333EA)
                        : const Color(0xFF4B5563),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Card 6: إجمالي الصلاحيات الممنوحة
  // ---------------------------------------------------------------------------
  Widget _buildPermissionsSummaryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Link "عرض التفاصيل >"
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const AddTeamMemberBottomSheet(),
                  );
                },
                borderRadius: BorderRadius.circular(6),
                child: const Row(
                  children: [
                    Icon(
                      Icons.chevron_left_rounded,
                      size: 18,
                      color: Color(0xFF2563EB),
                    ),
                    SizedBox(width: 2),
                    Text(
                      'عرض التفاصيل',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),

              // Center & Right: Title & Metric Pills
              Row(
                children: [
                  const Text(
                    'إجمالي الصلاحيات الممنوحة',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // 3 Manager/Supervisor/Employee Pills
                  Row(
                    children: [
                      _buildRoleMetricPill(
                        '3',
                        'مدير',
                        Icons.shield_outlined,
                        const Color(0xFF2563EB),
                        const Color(0xFFEFF6FF),
                      ),
                      const SizedBox(width: 4),
                      _buildRoleMetricPill(
                        '6',
                        'مشرف',
                        Icons.bar_chart_rounded,
                        const Color(0xFF9333EA),
                        const Color(0xFFF3E8FF),
                      ),
                      const SizedBox(width: 4),
                      _buildRoleMetricPill(
                        '15',
                        'موظف',
                        Icons.person_outline_rounded,
                        const Color(0xFFEA580C),
                        const Color(0xFFFFF7ED),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleMetricPill(
    String count,
    String label,
    IconData icon,
    Color color,
    Color bg,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            '$count $label',
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Card 7: Bottom Info Banner (إدارة الفريق بسهولة)
  // ---------------------------------------------------------------------------
  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: Row(
        children: [
          // Close Icon
          IconButton(
            onPressed: () => setState(() => _showBanner = false),
            icon: const Icon(
              Icons.close_rounded,
              size: 18,
              color: Color(0xFF9CA3AF),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 10),

          // Text
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'إدارة الفريق بسهولة',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 2),
                Text(
                  'قم بدعوة أعضاء جدد وإدارة صلاحياتهم للوصول إلى أقسام النظام المختلفة',
                  style: TextStyle(fontSize: 10.5, color: Color(0xFF6B7280)),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Icon
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFF3E8FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.group_outlined,
              color: Color(0xFF9333EA),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}


