// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class OfferDetailsScreen extends StatelessWidget {
  final String rfqId;

  const OfferDetailsScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.onSurfaceVariant),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: Column(
                children: [
                  // Circular factory icon illustration
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
                              decoration: const BoxDecoration(
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
                        // Hourglass badge overlay
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
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
                  const SizedBox(height: 20),

                  // Subtitles
                  const Text(
                    'في انتظار الموافقة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'طلبك قيد المراجعة حالياً من قبل قسم الإنتاج في\nمصنع نسيجك.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Side by side quick stats cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE2E1EF)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('آخر ظهور', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                                  SizedBox(height: 4),
                                  Text('منذ 5 دقائق', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.visibility_outlined, color: Color(0xFF006B5F), size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE2E1EF)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('أرسل منذ', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                                  SizedBox(height: 4),
                                  Text('ساعة واحدة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.file_upload_outlined, color: Color(0xFF0040E0), size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Timeline section
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'مراحل الطلب',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Vertical timeline items
                  _buildTimelineItem(
                    title: 'إرسال العرض',
                    description: 'تم إرسال عرض السعر والتفاصيل الفنية بنجاح.',
                    time: '10:45 AM',
                    isCompleted: true,
                    isFirst: true,
                  ),
                  _buildTimelineItem(
                    title: 'تمت المشاهدة',
                    description: 'قام مدير المصنع بفتح ومراجعة وثيقة العرض.',
                    time: '11:30 AM',
                    isCompleted: true,
                  ),
                  _buildTimelineItem(
                    title: 'قيد المراجعة',
                    description: 'يتم الآن دراسة الجدول الزمني للإنتاج وتوفر المواد.',
                    time: 'الآن',
                    isActive: true,
                    showSpinner: true,
                    showPill: true,
                  ),
                  _buildTimelineItem(
                    title: 'الموافقة النهائية',
                    description: 'المرحلة الأخيرة لإصدار أمر الشراء الرسمي.',
                    time: 'قريباً',
                    isLast: true,
                    isFuture: true,
                  ),
                  const SizedBox(height: 24),

                  // Bottom Image Card
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=350&q=80'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.bottomRight,
                      child: const Text(
                        'مصنع نسيجك - وحدة الإنتاج رقم 4',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: SafeArea(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_active_outlined, size: 16, color: Colors.white),
                    label: const Text(
                      'إرسال تذكير',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.cancel_outlined, size: 16, color: AppColors.error),
                    label: const Text(
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
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String description,
    required String time,
    bool isCompleted = false,
    bool isActive = false,
    bool isFuture = false,
    bool isFirst = false,
    bool isLast = false,
    bool showSpinner = false,
    bool showPill = false,
  }) {
    Color iconBgColor = const Color(0xFFF1F1F5);
    Color iconColor = AppColors.outline;
    Widget centerIcon = const Icon(Icons.check, size: 14, color: Colors.white);

    if (isCompleted) {
      iconBgColor = const Color(0xFF0040E0);
      iconColor = Colors.white;
      centerIcon = const Icon(Icons.check, size: 14, color: Colors.white);
    } else if (isActive) {
      iconBgColor = const Color(0xFFE8F0FE);
      iconColor = const Color(0xFF0040E0);
      centerIcon = const SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFF0040E0),
        ),
      );
    } else if (isFuture) {
      iconBgColor = const Color(0xFFF1F1F5);
      iconColor = AppColors.outline;
      centerIcon = const Icon(Icons.person_outline, size: 14, color: AppColors.outline);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Time label on left
          Container(
            width: 80,
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 10,
                color: isCompleted || isActive ? AppColors.onSurface : AppColors.outline,
                fontWeight: isCompleted || isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Central line and bullet
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
                    color: isCompleted ? const Color(0xFF0040E0) : const Color(0xFFE2E1EF),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Description details on right
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (showPill) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEA),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'مرحلة حرجة',
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isFuture ? AppColors.outline : AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 11,
                      color: isFuture ? AppColors.outline : AppColors.onSurfaceVariant,
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
