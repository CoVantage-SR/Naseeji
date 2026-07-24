import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsBottomBannerWidget extends StatelessWidget {
  const NotificationsBottomBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: InkWell(
        onTap: () => context.push('/notifications'),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF), // Light blue background matching reference design
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            children: const [
              Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Color(0xFF2563EB)),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'لديك إشعارات جديدة 🔔',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'اضغط هنا لعرض كافة الإشعارات والعمليات الحديثة.',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10),
              Icon(
                Icons.notifications_active_outlined,
                color: Color(0xFF2563EB),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
