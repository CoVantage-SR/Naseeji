import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class DisputeCenterScreen extends StatefulWidget {
  final String rfqId;

  const DisputeCenterScreen({super.key, required this.rfqId});

  @override
  State<DisputeCenterScreen> createState() => _DisputeCenterScreenState();
}

class _DisputeCenterScreenState extends State<DisputeCenterScreen> {
  String selectedReason = 'اختلاف جودة الخامات الموردة';
  final _descController = TextEditingController();
  bool hasActiveDispute = true;
  String currentStatus = 'Under Investigation'; // Open, Waiting, Under Investigation, Resolved, Rejected, Closed

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'مركز إدارة النزاعات والشكاوى',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (hasActiveDispute) ...[
              // Active dispute details card
              _buildActiveDisputeCard(),
              SizedBox(height: 16),

              // Dispute Timeline
              _buildDisputeTimeline(),
              SizedBox(height: 16),

              // Resolution panel
              _buildAdminResolutionPanel(),
            ] else ...[
              // Open new dispute form
              _buildOpenDisputeForm(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActiveDisputeCard() {
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusBgColor(currentStatus),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _getStatusLabel(currentStatus),
                  style: TextStyle(
                    color: _getStatusTextColor(currentStatus),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text('نزاع نشط للطلب #8820', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          SizedBox(height: 12),
          _buildRowItem('سبب النزاع المفتوح', selectedReason),
          SizedBox(height: 8),
          _buildRowItem('تاريخ فتح القضية', '06 يوليو 2026'),
          SizedBox(height: 8),
          _buildRowItem('المتضرر الرافع', 'مصنع الأقمشة المتطور (المشتري)'),
          SizedBox(height: 12),
          Text('شرح المشكلة المرفق', style: TextStyle(fontSize: 11, color: AppColors.outline)),
          SizedBox(height: 4),
          Text(
            'هناك اختلاف في جودة الملمس ووزن القماش المورد (الوزن المستلم 160 GSM بينما المتفق عليه بالاتفاقية 180 GSM). نطلب التعويض أو إعادة التعديل.',
            style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }

  Widget _buildDisputeTimeline() {
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
          Text('خطوات معالجة النزاع والتحقيق', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 16),
          _buildTimelineStep('تم فتح النزاع من قبل المصنع المشتري', '06 يوليو 2026 - 09:00 ص', isDone: true),
          _buildTimelineStep('جاري مراجعة الصور والإثباتات المرفقة من الإدارة', '06 يوليو 2026 - 10:15 ص', isDone: true),
          _buildTimelineStep('جاري التحقق من عينات المصنع مع تقرير جودة المورد', '06 يوليو 2026 - الآن', isActive: true),
          _buildTimelineStep('إصدار القرار النهائي للتحكيم المالي والتعويض', 'مجدول لاحقاً', isFuture: true),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String desc, String time, {bool isDone = false, bool isActive = false, bool isFuture = false}) {
    Color dotColor = const Color(0xFFE2E1EF);
    if (isDone) dotColor = const Color(0xFFDC2626);
    if (isActive) dotColor = const Color(0xFF0040E0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                desc,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isDone || isActive ? FontWeight.bold : FontWeight.normal,
                  color: isFuture ? AppColors.outline : Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.end,
              ),
              Text(time, style: TextStyle(fontSize: 8, color: AppColors.outline)),
              SizedBox(height: 12),
            ],
          ),
        ),
        SizedBox(width: 12),
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 3),
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
      ],
    );
  }

  Widget _buildAdminResolutionPanel() {
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('رأي الإدارة والحلول المقترحة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF006B5F))),
              SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Color(0xFFE2F9F5), shape: BoxShape.circle),
                child: const Icon(Icons.shield_outlined, color: Color(0xFF006B5F), size: 14),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'نوصي المورد بتقديم خصم إضافي بنسبة 10% على إجمالي قيمة الطلب لتعويض فرق الجودة المستلمة، أو إعادة شحن الكمية المرفوضة في غضون 5 أيام عمل لتفادي الإجراءات القانونية.',
            style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5),
            textAlign: TextAlign.end,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      currentStatus = 'Closed';
                      hasActiveDispute = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم رفض الحل المقترح وتصعيد النزاع للتحكيم الخارجي')));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('رفض الحل المقترح', style: TextStyle(color: AppColors.error, fontSize: 11)),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentStatus = 'Resolved';
                    });
                    _showSuccessDialog('تم قبول التسوية الودية وحل النزاع بنجاح. سيتم الإفراج عن المبلغ المتبقي.');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006B5F),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('قبول التسوية المقترحة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOpenDisputeForm() {
    final reasons = [
      'اختلاف جودة الخامات الموردة',
      'تأخر في الشحن والتسليم اللوجستي',
      'احتساب أسعار مخالفة للاتفاق المبدئي',
      'عدم استلام إشعار الإفراج المالي المعتمد',
    ];

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
          Text('فتح قضية نزاع جديدة للطلب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 16),
          Text('سبب تقديم الشكوى', style: TextStyle(fontSize: 11, color: AppColors.outline)),
          SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E1EF)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: DropdownButton<String>(
                value: selectedReason,
                underline: SizedBox(),
                isExpanded: true,
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
                items: reasons.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      selectedReason = val;
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          Text('شرح وتفاصيل المشكلة', style: TextStyle(fontSize: 11, color: AppColors.outline)),
          SizedBox(height: 6),
          TextField(
            controller: _descController,
            maxLines: 4,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
              hintText: 'اكتب وصفاً تفصيلياً للمشكلة الحاصلة والأضرار المترتبة...',
              hintStyle: TextStyle(fontSize: 11, color: AppColors.outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E1EF))),
            ),
          ),
          SizedBox(height: 16),
          Text('إرفاق المستندات والصور الداعمة للشكوى', style: TextStyle(fontSize: 11, color: AppColors.outline)),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E1EF)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload_outlined, color: Color(0xFF0040E0), size: 24),
                SizedBox(height: 6),
                Text('ارفع الصور أو مقاطع الفيديو أو المستندات الموثقة للخلل', style: TextStyle(fontSize: 10, color: AppColors.outline)),
              ],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                hasActiveDispute = true;
                currentStatus = 'Open';
              });
              _showSuccessDialog('تم تسجيل النزاع بنجاح وجاري إخطار الطرف الآخر ومراجعة الإدارة للطلب.');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0040E0),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text('تقديم الشكوى بشكل رسمي', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
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

  Color _getStatusBgColor(String status) {
    if (status == 'Resolved') return const Color(0xFFDCFCE7);
    if (status == 'Rejected') return const Color(0xFFFEE2E2);
    return const Color(0xFFFFF7ED);
  }

  Color _getStatusTextColor(String status) {
    if (status == 'Resolved') return const Color(0xFF16A34A);
    if (status == 'Rejected') return const Color(0xFFDC2626);
    return Colors.orange;
  }

  String _getStatusLabel(String status) {
    if (status == 'Open') return 'مفتوح';
    if (status == 'Waiting') return 'في الانتظار';
    if (status == 'Under Investigation') return 'قيد التحقيق من الإدارة';
    if (status == 'Resolved') return 'تمت التسوية';
    if (status == 'Rejected') return 'شكوى مرفوضة';
    return 'مغلق';
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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