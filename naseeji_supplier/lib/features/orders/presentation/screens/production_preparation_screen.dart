import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/production_preparation_controller.dart';

class ProductionPreparationScreen extends ConsumerStatefulWidget {
  final String rfqId;

  const ProductionPreparationScreen({super.key, required this.rfqId});

  @override
  ConsumerState<ProductionPreparationScreen> createState() => _ProductionPreparationScreenState();
}

class _ProductionPreparationScreenState extends ConsumerState<ProductionPreparationScreen> {
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prepAsync = ref.watch(productionPreparationControllerProvider(widget.rfqId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'تحديث جاهزية الإنتاج والتغليف',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
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
                      // Progress Percent Card
                      _buildProgressPercentCard(prep),
                      SizedBox(height: 16),

                      // Phase selection
                      _buildPhasesMilestones(prep),
                      SizedBox(height: 16),

                      // Upload Proof
                      _buildUploadProofCard(prep),
                      SizedBox(height: 16),

                      // Preparation Notes Card
                      _buildNotesCard(),
                    ],
                  ),
                ),
              ),

              // Bottom Actions
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _showSuccessDialog('تم حفظ التقدم كمسودة بنجاح');
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.outline),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text('حفظ التقدم', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Go to review screen next step
                            context.push('/orders/factory-preparation-review?rfqId=${widget.rfqId}');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0040E0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: const Size(0, 48),
                          ),
                          child: Text(
                            'إرسال لمراجعة المصنع',
                            style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
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

  Widget _buildProgressPercentCard(dynamic prep) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${prep.progressPercent.round()}%',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0040E0)),
              ),
              Text('نسبة الإنجاز الحالية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: prep.progressPercent / 100,
            backgroundColor: const Color(0xFFF1F1F5),
            color: const Color(0xFF0040E0),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          SizedBox(height: 14),
          Slider(
            value: prep.progressPercent,
            min: 0,
            max: 100,
            divisions: 10,
            activeColor: const Color(0xFF0040E0),
            inactiveColor: const Color(0xFFF1F1F5),
            onChanged: (val) {
              ref.read(productionPreparationControllerProvider(widget.rfqId).notifier).updateProgress(val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhasesMilestones(dynamic prep) {
    final phasesList = ['Preparing Materials', 'Manufacturing', 'Quality Inspection', 'Packaging', 'Ready To Ship'];
    final arPhases = {
      'Preparing Materials': 'تجهيز خامات الأقمشة',
      'Manufacturing': 'بدء التصنيع والنسيج',
      'Quality Inspection': 'فحص وضمان الجودة',
      'Packaging': 'التغليف الصناعي النهائي',
      'Ready To Ship': 'الطلب جاهز للشحن الآن',
    };

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
          Text('مراحل تقدم تجهيز الطلبية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 16),
          ...phasesList.map((phase) {
            final isCurrent = prep.currentPhase == phase;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCurrent ? const Color(0xFFE8F0FE) : Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(color: isCurrent ? const Color(0xFF0040E0) : const Color(0xFFE2E1EF)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    arPhases[phase] ?? phase,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent ? const Color(0xFF0040E0) : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(
                    isCurrent ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: isCurrent ? const Color(0xFF0040E0) : AppColors.outline,
                    size: 16,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildUploadProofCard(dynamic prep) {
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
          Text('إثبات جاهزية الإنتاج (مطلوب)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 4),
          Text('يرجى تصوير صور للمنتج وفيديو مدته 5 ثوانٍ لتمكين المصنع من التدقيق والقبول.', style: TextStyle(fontSize: 10, color: AppColors.outline), textAlign: TextAlign.end),
          SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildUploadItem('صور تجهيز الخامات', Icons.camera_alt_outlined),
              _buildUploadItem('فيديو المنتج (5 ثوان)', Icons.videocam_outlined),
              _buildUploadItem('صور اختبار الجودة', Icons.verified_outlined),
              _buildUploadItem('صور التغليف النهائي', Icons.inventory_2_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadItem(String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: const Color(0xFFE2E1EF)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF0040E0), size: 24),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
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
          Text('ملاحظات التجهيز الإضافية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 3,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
              hintText: 'اكتب أي ملاحظات فنية حول التجهيز والتغليف هنا...',
              hintStyle: TextStyle(color: AppColors.outline, fontSize: 11),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E1EF))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E1EF))),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }
}