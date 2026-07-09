import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/production_preparation_controller.dart';

class FactoryPreparationReviewScreen extends ConsumerWidget {
  final String rfqId;

  const FactoryPreparationReviewScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prepAsync = ref.watch(productionPreparationControllerProvider(rfqId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'تدقيق جاهزية الإنتاج للمصنع',
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
      body: prepAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (prep) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Alert Header
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                'مرحلة التدقيق: يقوم المصنع بمراجعة صور التغليف وفحص الجودة واعتمادها للشحن.',
                                style: TextStyle(fontSize: 11, color: Colors.orange, height: 1.4),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.rate_review_outlined, color: Colors.orange, size: 18),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Image Gallery Section
                      Text('معرض صور الفحص والجودة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          itemCount: prep.preparationImages.length + prep.qualityInspectionImages.length,
                          itemBuilder: (context, index) {
                            final allImages = [...prep.preparationImages, ...prep.qualityInspectionImages];
                            return Container(
                              width: 100,
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(image: NetworkImage(allImages[index]), fit: BoxFit.cover),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),

                      // Video Preview Card
                      Text('معاينة الفيديو المرفوع (5 ثوان)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=350&q=80'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                            child: const Icon(Icons.play_arrow, color: Theme.of(context).colorScheme.surface, size: 36),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Notes Section
                      Container(
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
                            Text('ملاحظات الجودة للمورد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            SizedBox(height: 8),
                            Text(
                              prep.preparationNotes,
                              style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom buttons
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
                                _showFeedbackDialog(context, 'طلب تعديل الجودة', 'تم إرسال طلب التعديل للمورد بنجاح');
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.error),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text('طلب تعديل الخامات', style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _showSuccessDialog(context, 'تم اعتماد الجودة والتغليف بنجاح! يمكن للمورد المتابعة للشحن.');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF006B5F),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text('اعتماد الجودة والشحن', style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () => context.push('/orders/chat?rfqId=${prep.rfqId}'),
                        icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF0040E0), size: 18),
                        label: Text('فتح المحادثة الفورية', style: TextStyle(color: Color(0xFF0040E0), fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Color(0xFF16A34A), size: 48),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Pop dialog
              context.go('/orders/shipping-manifest?rfqId=$rfqId'); // Navigate to next step: Shipping Manifest
            },
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context, String title, String successMsg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        content: TextField(
          maxLines: 3,
          textAlign: TextAlign.end,
          decoration: InputDecoration(
            hintText: 'اكتب تفاصيل التعديلات المطلوبة...',
            hintStyle: TextStyle(fontSize: 11),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(successMsg)));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0040E0), foregroundColor: Colors.white),
            child: Text('إرسال'),
          ),
        ],
      ),
    );
  }
}
