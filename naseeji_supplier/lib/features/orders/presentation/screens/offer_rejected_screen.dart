import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class OfferRejectedScreen extends StatelessWidget {
  final String rfqId;

  const OfferRejectedScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'تفاصيل العرض',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        leading: Row(
          children: [
            const SizedBox(width: 16),
            const Text(
              'Naseeji',
              style: TextStyle(
                color: Color(0xFF0040E0),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        leadingWidth: 100,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.onSurfaceVariant),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Circular red error icon with overlay
                  Center(
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.cancel,
                              color: Color(0xFFDC2626),
                              size: 56,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color: Color(0xFFDC2626),
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title & Subtitle
                  const Text(
                    'تم رفض عرض السعر',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'تمت مراجعة عرضك من قبل المصنع الذكي، ولكن لم يتم قبوله في الوقت الحالي.',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Factory Notes Card (ملاحظات المصنع)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: const Border(
                        top: BorderSide(color: Color(0xFFDC2626), width: 3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'ملاحظات المصنع',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDC2626),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFEE2E2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.comment_outlined, color: Color(0xFFDC2626), size: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'The unit price is higher than our budget for this project. We are looking for a supplier who can offer a more competitive rate for the high-volume production phase starting next quarter.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Suggested changes list (التغييرات المقترحة)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E1EF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'التغييرات المقترحة',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0040E0),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 3,
                              height: 14,
                              color: const Color(0xFF0040E0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildSuggestedItem(
                          text: 'خفض سعر الوحدة بنسبة 15%\nللمنافسة مع العروض الحالية في السوق',
                          icon: Icons.trending_down_outlined,
                        ),
                        const SizedBox(height: 12),
                        _buildSuggestedItem(
                          text: 'تقليص مدة التوريد\nالمصنع يفضل التسليم خلال 10 أيام عمل',
                          icon: Icons.access_time_outlined,
                        ),
                        const SizedBox(height: 12),
                        _buildSuggestedItem(
                          text: 'إرفاق شهادات الجودة (ISO)\nلتعزيز موثوقية الخامات المستخدمة',
                          icon: Icons.verified_outlined,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quality Testing Lab Image Card
                  Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1576086213369-97a306d36557?auto=format&fit=crop&w=350&q=80'),
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
                        'معايير نسيجي للجودة والابتكار',
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

          // Action Buttons Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.push('/create-offer?rfqId=$rfqId'),
                    icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.white),
                    label: const Text(
                      'تعديل العرض',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0040E0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/create-offer?rfqId=$rfqId'),
                    icon: const Icon(Icons.send, size: 16, color: Color(0xFF006B5F)),
                    label: const Text(
                      'إرسال عرض جديد',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF006B5F)),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF006B5F)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.archive_outlined, color: AppColors.onSurfaceVariant, size: 18),
                        label: const Text(
                          'أرشفة',
                          style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'هل تحتاج للمساعدة في تحسين عرضك؟',
                        style: TextStyle(color: AppColors.outline, fontSize: 11),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.help_outline, color: AppColors.outline, size: 14),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedItem({required String text, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F1F5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.4),
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: const Color(0xFF0040E0), size: 20),
        ],
      ),
    );
  }
}
