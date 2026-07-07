import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/shipping_controller.dart';

class ShipmentIssueScreen extends ConsumerStatefulWidget {
  final String shipmentId;

  const ShipmentIssueScreen({super.key, required this.shipmentId});

  @override
  ConsumerState<ShipmentIssueScreen> createState() => _ShipmentIssueScreenState();
}

class _ShipmentIssueScreenState extends ConsumerState<ShipmentIssueScreen> {
  final _descController = TextEditingController();
  String _selectedCategory = 'تأخر في استلام الشحنة (Late Pickup)';
  String _selectedPriority = 'عالي جداً';
  final List<String> _categories = [
    'تأخر في استلام الشحنة (Late Pickup)',
    'تأخر وصول خط السير (Shipment Delay)',
    'بضائع تالفة بسبب سوء النقل (Damaged Goods)',
    'نقص في عدد الطرود/الكرتونات (Missing Items)',
    'خطأ في المستندات الجمركية (Wrong Documents)',
    'أخرى (Other)',
  ];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            'الإبلاغ عن مشكلة شحن ${widget.shipmentId}',
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Warning banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange.shade200)),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'عند تسجيل بلاغ لوجستي، سيتم تعليق الإفراج المالي للطلب مؤقتاً لحين المراجعة ومطابقة الجودة.',
                        style: TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.bold, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Inputs form
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('نوع مشكلة الشحن اللوجستية *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 11)))).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedCategory = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    const Text('أولوية البلاغ اللوجستي *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildPriorityRadio('منخفض'),
                        const SizedBox(width: 8),
                        _buildPriorityRadio('عادي'),
                        const SizedBox(width: 8),
                        _buildPriorityRadio('عالي جداً'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Text('وصف تفصيلي للإشكالية *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'اكتب تفاصيل الإشكالية، الأضرار، التوقيت المتأخر وأثرها على التسليم...',
                        hintStyle: const TextStyle(fontSize: 11),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text('إثبات ومرفقات البلاغ (صور، مستندات PDF)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت محاكاة إرفاق ملف الإثبات بنجاح.')));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.outlineVariant, style: BorderStyle.solid),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 28),
                            SizedBox(height: 8),
                            Text('اضغط هنا لإرفاق مستند أو صورة إثبات', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (_descController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء كتابة وصف تفصيلي للمشكلة')));
                    return;
                  }
                  ref.read(shippingControllerProvider.notifier).reportLogisticsIssue(
                    widget.shipmentId,
                    category: _selectedCategory,
                    description: _descController.text,
                    priority: _selectedPriority,
                  );
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم رفع بلاغ إشكالية الشحن. جاري مراجعة الدعم اللوجستي بنسيجي.')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0040E0),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('إرسال البلاغ والمتابعة', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityRadio(String priority) {
    final isSelected = _selectedPriority == priority;
    Color color = Colors.grey;
    if (priority == 'عالي جداً') color = Colors.red;
    if (priority == 'عادي') color = Colors.orange;
    if (priority == 'منخفض') color = Colors.blue;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPriority = priority;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
            border: Border.all(color: isSelected ? color : AppColors.outlineVariant, width: isSelected ? 2 : 1),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            priority,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? color : AppColors.outline,
            ),
          ),
        ),
      ),
    );
  }
}
