import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/account_provider.dart';

// ─── Setting Tile ──────────────────────────────────────────────────────────
class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final bool isDestructive;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? AppColors.error
        : (iconColor ?? AppColors.primary);
    final textColor = isDestructive ? AppColors.error : null;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: AppRadius.rSM,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: textColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: const TextStyle(fontSize: 11, color: Colors.grey))
          : null,
      trailing: trailing ??
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: isDestructive ? AppColors.error.withValues(alpha: 0.5) : Colors.grey,
          ),
    );
  }
}

// ─── Notification Tile ─────────────────────────────────────────────────────
class NotificationTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const NotificationTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: enabled ? null : Colors.grey)),
          Switch(
            value: value && enabled,
            onChanged: enabled ? onChanged : null,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

// ─── Theme Card ────────────────────────────────────────────────────────────
class ThemeCard extends StatelessWidget {
  final AppThemeMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemeCard({super.key, required this.mode, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (mode) {
      case AppThemeMode.light:
        icon = Icons.light_mode_rounded;
      case AppThemeMode.dark:
        icon = Icons.dark_mode_rounded;
      case AppThemeMode.system:
        icon = Icons.brightness_auto_rounded;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : context.theme.cardColor,
          borderRadius: AppRadius.rMD,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : Colors.grey, size: 32),
            const SizedBox(height: 8),
            Text(
              mode.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.grey,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 6),
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Section Card ──────────────────────────────────────────────────────────
class SectionCard extends StatelessWidget {
  final String title;
  final String content;
  final bool isExpanded;
  final VoidCallback onToggle;

  const SectionCard({
    super.key,
    required this.title,
    required this.content,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: InkWell(
        onTap: onToggle,
        borderRadius: AppRadius.rMD,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 12),
                Text(content, style: const TextStyle(fontSize: 12, height: 1.6)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Information Card ──────────────────────────────────────────────────────
class InformationCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  const InformationCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor ?? AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Statistic Card ────────────────────────────────────────────────────────
class StatisticCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatisticCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ─── Permission Chip ───────────────────────────────────────────────────────
class PermissionChip extends StatelessWidget {
  final String label;
  final bool granted;
  final VoidCallback? onToggle;

  const PermissionChip({super.key, required this.label, required this.granted, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: granted ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.08),
          borderRadius: AppRadius.rRound,
          border: Border.all(
            color: granted ? AppColors.primary : Colors.grey.withValues(alpha: 0.3),
            width: granted ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              granted ? Icons.check_circle_rounded : Icons.cancel_rounded,
              size: 14,
              color: granted ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: granted ? FontWeight.bold : FontWeight.normal,
                color: granted ? AppColors.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Profile Card ──────────────────────────────────────────────────────────
class ProfileCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String logoUrl;
  final bool isVerified;

  const ProfileCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.logoUrl,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipOval(
              child: Image.network(
                logoUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 56,
                  height: 56,
                  color: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.factory_rounded, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                      if (isVerified) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.verified_rounded, color: AppColors.info, size: 18),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Primary Button ────────────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
                  Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
      ),
    );
  }
}

// ─── Secondary Button ──────────────────────────────────────────────────────
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const SecondaryButton({super.key, required this.label, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
          side: const BorderSide(color: AppColors.primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}

// ─── Employee Card ─────────────────────────────────────────────────────────
class EmployeeCard extends StatelessWidget {
  final EmployeeModel employee;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onToggleStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final isActive = employee.status == EmployeeStatus.active;
    final statusColor = isActive ? AppColors.success : Colors.grey;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.network(
                    employee.photoUrl,
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 46,
                      height: 46,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.person_rounded, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(employee.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(employee.jobTitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _roleBadge(employee.role.label),
                          const SizedBox(width: 8),
                          _statusDot(statusColor, employee.status.label),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded, size: 20),
                  onSelected: (val) {
                    if (val == 'edit') onEdit();
                    if (val == 'toggle') onToggleStatus();
                    if (val == 'delete') onDelete();
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                    PopupMenuItem(
                      value: 'toggle',
                      child: Text(isActive ? 'إيقاف' : 'تفعيل'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('حذف', style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 16),
            Row(
              children: [
                const Icon(Icons.phone_rounded, size: 13, color: Colors.grey),
                const SizedBox(width: 5),
                Text(employee.phone, style: const TextStyle(fontSize: 11)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time_rounded, size: 13, color: Colors.grey),
                const SizedBox(width: 5),
                Text('آخر دخول: ${employee.lastLogin}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: employee.permissions.entries.map((e) => PermissionChip(
                label: e.key,
                granted: e.value,
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: AppRadius.rRound,
      ),
      child: Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary)),
    );
  }

  Widget _statusDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ─── Loading Widget ────────────────────────────────────────────────────────
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
  }
}

// ─── Empty State Widget ────────────────────────────────────────────────────
class AccountEmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const AccountEmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ─── Section Header ────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 0.5),
      ),
    );
  }
}

// ─── Subscription Badge ────────────────────────────────────────────────────
class SubscriptionBadge extends StatelessWidget {
  final String plan;
  const SubscriptionBadge({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (plan) {
      case 'pro':
        color = const Color(0xFF7C3AED);
        label = 'PRO';
      case 'enterprise':
        color = const Color(0xFFB45309);
        label = 'Enterprise';
      case 'basic':
        color = AppColors.info;
        label = 'Basic';
      default:
        color = Colors.grey;
        label = 'Free';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.rRound,
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}
