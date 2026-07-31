import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../controllers/shipping_manifest_controller.dart';

class ShippingManifestScreen extends ConsumerStatefulWidget {
  final String rfqId;

  const ShippingManifestScreen({super.key, required this.rfqId});

  @override
  ConsumerState<ShippingManifestScreen> createState() => _ShippingManifestScreenState();
}

class _ShippingManifestScreenState extends ConsumerState<ShippingManifestScreen> {
  final _carrierController = TextEditingController(text: 'أرامكس Aramex');
  final _trackingController = TextEditingController(text: 'ARMX-99882211');
  final _shipmentNumController = TextEditingController(text: 'SH-882200');
  final _truckController = TextEditingController(text: 'أ ب ج 1234');
  final _driverController = TextEditingController(text: 'محمد العتيبي');
  final _arrivalController = TextEditingController(text: '15 يوليو 2026');

  @override
  void dispose() {
    _carrierController.dispose();
    _trackingController.dispose();
    _shipmentNumController.dispose();
    _truckController.dispose();
    _driverController.dispose();
    _arrivalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manifestAsync = ref.watch(shippingManifestControllerProvider(widget.rfqId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'تجهيز بيان الشحن (Manifest)',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/orders/order-center?rfqId=${widget.rfqId}');
            }
          },
        ),
      ),
      body: manifestAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (manifest) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Alert
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FE),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF0040E0).withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                'شروط الشحن: إرفاق رقم التتبع وصورة تحميل الشحنة إلزامي قبل تمكين العلامة كمشحونة.',
                                style: TextStyle(fontSize: 11, color: Color(0xFF0040E0), height: 1.4),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.local_shipping, color: Color(0xFF0040E0), size: 18),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F2FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'مركز لوجستيات الشحن الموحد',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'تتبع الشحنات بالخريطة، أرفع إثباتات التحميل وأدر الفواتير والفسح المالي بالكامل.',
                                    style: TextStyle(fontSize: 10, color: AppColors.outline, height: 1.3),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => context.push('/shipping'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 32),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text('انتقال', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Carrier Inputs
                      _buildCarrierFormCard(),
                      SizedBox(height: 16),

                      // Document Uploads
                      _buildLoadingPhotosCard(),
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
                            _showSuccessDialog('تم حفظ بيان الشحن كمسودة بنجاح');
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.outline),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text('حفظ كمسودة', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _showDeliveryRouteDialog(context, widget.rfqId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0040E0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: const Size(0, 48),
                          ),
                          child: Text(
                            'تأكيد الشحن الفعلي',
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

  Widget _buildCarrierFormCard() {
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
          Text('تفاصيل الشحن والناقل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 16),
          _buildTextField('شركة الشحن', _carrierController),
          SizedBox(height: 12),
          _buildTextField('رقم التتبع (Tracking ID)', _trackingController),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTextField('رقم الشاحنة', _truckController)),
              SizedBox(width: 12),
              Expanded(child: _buildTextField('رقم الشحنة الداخلي', _shipmentNumController)),
            ],
          ),
          SizedBox(height: 12),
          _buildTextField('اسم سائق الشاحنة', _driverController),
          SizedBox(height: 12),
          _buildTextField('تاريخ الوصول المتوقع', _arrivalController, icon: Icons.calendar_today_outlined),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {IconData? icon}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          SizedBox(height: 6),
          TextField(
            controller: ctrl,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              suffixIcon: icon != null ? Icon(icon, size: 16) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E1EF))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E1EF))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPhotosCard() {
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
          Text('مرفقات وإثباتات التحميل الشحن', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildUploadItem('صور الشحنة قبل التحميل', Icons.photo_outlined),
              _buildUploadItem('صور الشحنة بعد التحميل', Icons.local_shipping_outlined),
              _buildUploadItem('فاتورة الشحن والجمارك', Icons.receipt_long_outlined),
              _buildUploadItem('أوراق التسليم والبولصية', Icons.description_outlined),
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
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
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

  void _showDeliveryRouteDialog(BuildContext context, String rfqId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('تأكيد شحن الشحنة', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        content: Text('هل تم التحميل الفعلي والتحقق من صحة أوراق التوصيل؟ سيتم إشعار المصنع فوراً.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('تراجع')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/orders/delivery-confirmation?rfqId=$rfqId'); // Go to delivery check screen
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0040E0), foregroundColor: Colors.white),
            child: Text('تأكيد وإشعار'),
          ),
        ],
      ),
    );
  }
}


