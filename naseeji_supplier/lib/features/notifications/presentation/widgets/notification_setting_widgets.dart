import 'package:flutter/material.dart';

class NotificationSection extends StatelessWidget {
  final String title;
  final Widget child;

  const NotificationSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4B5563),
            ),
          ),
        ),
        Container(
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
          child: child,
        ),
      ],
    );
  }
}

class NotificationSwitchTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTapTile;

  const NotificationSwitchTile({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.value,
    this.enabled = true,
    required this.onChanged,
    this.onTapTile,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? (onTapTile ?? () => onChanged(!value)) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Chevron icon on far left in RTL
              const Icon(
                Icons.chevron_left_rounded,
                size: 20,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 8),

              // Switch
              Switch(
                value: value,
                onChanged: enabled ? onChanged : null,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF16A34A), // Green track in screenshot
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFF6B7280),
              ),
              const SizedBox(width: 12),

              // Title & Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: enabled ? const Color(0xFF111827) : const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 11,
                        color: enabled ? const Color(0xFF6B7280) : const Color(0xFFD1D5DB),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Icon in circle container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: enabled ? iconBgColor : const Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: enabled ? iconColor : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationScheduleCard extends StatelessWidget {
  final String scheduleTitle;
  final String timeRange;
  final bool enabled;
  final VoidCallback onTap;

  const NotificationScheduleCard({
    super.key,
    required this.scheduleTitle,
    required this.timeRange,
    this.enabled = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Chevron icon and time on left
              Row(
                children: [
                  const Icon(
                    Icons.chevron_left_rounded,
                    size: 20,
                    color: Color(0xFF9CA3AF),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    timeRange,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Schedule Title & Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scheduleTitle,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'لن تصلك أي إشعارات في الأوقات المحددة',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Clock Icon
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  size: 20,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResetSettingsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ResetSettingsButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF9333EA), size: 20),
            label: const Text(
              'إعادة تعيين الإعدادات',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9333EA),
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFFBF7FF),
              side: const BorderSide(color: Color(0xFFE9D5FF), width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'سيتم إعادة جميع الإعدادات إلى الوضع الافتراضي',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF9CA3AF),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
