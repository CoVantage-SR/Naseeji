// ignore_for_file: use_null_aware_elements

import 'package:flutter/material.dart';
import '../../domain/entities/security_models.dart';

class SecurityHeader extends StatelessWidget {
  final VoidCallback onBack;

  const SecurityHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Right: Shield Security Icon + Title & Subtitle
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
                  Icons.shield_outlined,
                  color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الأمان وتسجيل الدخول',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'إدارة أمان حسابك وطرق تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Left: Back Arrow
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_forward_rounded,
              color: isDark ? Colors.white : const Color(0xFF111827),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.bold,
          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF374151),
        ),
      ),
    );
  }
}

class LoginMethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailingWidget;

  const LoginMethodTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Far Left in RTL: Trailing button or status pill
          if (trailingWidget != null) trailingWidget!,

          const Spacer(),

          // Title & Subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Right Icon Container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D1B4E) : const Color(0xFFF3E8FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA)),
          ),
        ],
      ),
    );
  }
}

class DeviceSessionTile extends StatelessWidget {
  final DeviceSessionModel session;
  final VoidCallback onLogout;

  const DeviceSessionTile({
    super.key,
    required this.session,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Far Left in RTL: Logout Button or Status
          if (!session.isCurrent)
            SizedBox(
              height: 32,
              child: OutlinedButton(
                onPressed: onLogout,
                style: OutlinedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF450A0A) : const Color(0xFFFEF2F2),
                  side: BorderSide(color: isDark ? const Color(0xFF991B1B) : const Color(0xFFFCA5A5), width: 1),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'تسجيل خروج',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626)),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'الجهاز الحالي',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
              ),
            ),

          const Spacer(),

          // Device Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    session.deviceName,
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827)),
                  ),
                  if (session.isCurrent) const SizedBox(width: 6),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${session.city}، ${session.country} • ${session.lastActive}',
                style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Device Icon with Online Indicator Dot
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D1B4E) : const Color(0xFFF3E8FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  session.platform.contains('Windows') || session.platform.contains('Mac')
                      ? Icons.desktop_windows_rounded
                      : Icons.smartphone_rounded,
                  size: 20,
                  color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: session.isOnline ? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A)) : const Color(0xFF9CA3AF),
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SecurityActivityItem extends StatelessWidget {
  final SecurityActivityModel activity;

  const SecurityActivityItem({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    IconData iconData;
    Color iconColor;
    Color bgColor;

    switch (activity.type) {
      case 'password_change':
        iconData = Icons.lock_outline_rounded;
        iconColor = isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA);
        bgColor = isDark ? const Color(0xFF2D1B4E) : const Color(0xFFF3E8FF);
        break;
      case '2fa_toggle':
        iconData = Icons.verified_user_outlined;
        iconColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
        bgColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF);
        break;
      case 'login':
        iconData = Icons.devices_rounded;
        iconColor = isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
        bgColor = isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7);
        break;
      default:
        iconData = Icons.security_rounded;
        iconColor = isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C);
        bgColor = isDark ? const Color(0xFF7C2D12) : const Color(0xFFFFF7ED);
    }

    final formattedDate =
        '${activity.createdAt.day} مايو ${activity.createdAt.year} - ${activity.createdAt.hour}:${activity.createdAt.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          const Spacer(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827)),
              ),
              const SizedBox(height: 2),
              Text(
                formattedDate,
                style: TextStyle(fontSize: 10.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(width: 12),

          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(iconData, size: 18, color: iconColor),
          ),
        ],
      ),
    );
  }
}

class SecurityTipsSection extends StatelessWidget {
  const SecurityTipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'نصائح لتعزيز أمان حسابك'),
        Row(
          children: [
            Expanded(
              child: _buildTipCard(
                context: context,
                title: 'لا تشارك كلمة المرور',
                subtitle: 'لا تشارك كلمة المرور مع أي شخص',
                icon: Icons.shield_outlined,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTipCard(
                context: context,
                title: 'تحقق من بريدك',
                subtitle: 'تأكد من تحديث بريدك الإلكتروني',
                icon: Icons.mail_outline_rounded,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTipCard(
                context: context,
                title: 'فعّل الإشعارات',
                subtitle: 'لتصلك تنبيهات الأمان',
                icon: Icons.notifications_active_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTipCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A)),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827)),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 9.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class SecurityBottomButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SecurityBottomButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.security_rounded, color: Colors.white, size: 20),
        label: const Text(
          'مراجعة إعدادات الأمان',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9333EA),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}


