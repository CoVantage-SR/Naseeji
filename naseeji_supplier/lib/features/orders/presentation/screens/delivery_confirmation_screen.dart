import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class DeliveryConfirmationScreen extends ConsumerWidget {
  final String rfqId;

  const DeliveryConfirmationScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'تأكيد استلام وتسليم الشحنة',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Verification Banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF16A34A).withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            'وصلت الشحنة إلى الوجهة المحددة: مستودعات الرياض - قيد التدقيق النهائي واستلام المشتري.',
                            style: TextStyle(fontSize: 11, color: Color(0xFF16A34A), height: 1.4),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.mark_as_unread, color: Color(0xFF16A34A), size: 18),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Delivery Metadata Details
                  _buildDeliveryDetailsCard(),
                  SizedBox(height: 16),

                  // Verification Checkbox checklist
                  _buildChecklistCard(),
                  SizedBox(height: 16),

                  // Photos
                  Text('صور تسليم الشحنة الموثقة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        final mockPhotos = [
                          'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=150&q=80',
                          'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=150&q=80'
                        ];
                        return Container(
                          width: 100,
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(image: NetworkImage(mockPhotos[index]), fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom actions
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _showDisputeDialog(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.error),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text('إبلاغ عن مشكلة / نزاع', style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _showSuccessConfirmDialog(context, rfqId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0040E0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text('تأكيد الاستلام والقبول', style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
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

  Widget _buildDeliveryDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('تفاصيل وصول الإرسالية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          SizedBox(height: 12),
          _buildRowItem('تاريخ الاستلام الفعلي', '15 يوليو 2026'),
          SizedBox(height: 10),
          _buildRowItem('حالة الشحنة عند الاستلام', 'ممتازة - خالية من التلفيات والتمزق'),
          SizedBox(height: 10),
          _buildRowItem('الكمية المستلمة', '5,000 متر (كامل الشحنة)'),
          SizedBox(height: 10),
          _buildRowItem('مدى تطابق جودة الألوان', 'متطابقة بنسبة 100%'),
        ],
      ),
    );
  }

  Widget _buildChecklistCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('فحص البنود المطابقة المعتمدة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          SizedBox(height: 12),
          _buildCheckboxItem('تم التحقق من مطابقة الكمية الموردة بالكامل للاتفاقية', true),
          SizedBox(height: 8),
          _buildCheckboxItem('تم فحص عينات عشوائية واختبار قوة الشد وثبات اللون', true),
          SizedBox(height: 8),
          _buildCheckboxItem('اللفات مغلفة بشكل صناعي متين وخالية من الرطوبة والعيوب', true),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem(String label, bool val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: Text(label, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant), textAlign: TextAlign.end)),
        SizedBox(width: 10),
        Icon(val ? Icons.check_box : Icons.check_box_outline_blank, color: const Color(0xFF0040E0), size: 18),
      ],
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.left)),
        SizedBox(width: 10),
        Text('$label:', style: TextStyle(fontSize: 11, color: AppColors.outline)),
      ],
    );
  }

  void _showDisputeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('رفع نزاع / إبلاغ عن مشكلة', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.error)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('يرجى كتابة أسباب النزاع بالتفصيل لإرسالها للتحكيم الإداري بالمنصة.', style: TextStyle(fontSize: 11), textAlign: TextAlign.center),
            SizedBox(height: 12),
            TextField(
              maxLines: 3,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                hintText: 'مثال: نقص في الكمية الموردة بمقدار 200 متر أو بهتان في الألوان...',
                hintStyle: TextStyle(fontSize: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل الشكوى وجاري مراجعة إدارة نسيجي للطلب')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: Text('إرسال الشكوى'),
          ),
        ],
      ),
    );
  }

  void _showSuccessConfirmDialog(BuildContext context, String rfqId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, color: Color(0xFF16A34A), size: 48),
            SizedBox(height: 16),
            Text(
              'تم تأكيد الاستلام والتسليم بنجاح! سيتم تحويل الدفعة المالية للمورد.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Pop dialog
              context.go('/orders/payment-release?rfqId=$rfqId'); // Go to Payment Release screen
            },
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }
}
