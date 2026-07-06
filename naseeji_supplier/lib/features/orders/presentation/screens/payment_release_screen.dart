import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/payment_release_controller.dart';

class PaymentReleaseScreen extends ConsumerWidget {
  final String rfqId;

  const PaymentReleaseScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final releaseAsync = ref.watch(paymentReleaseControllerProvider(rfqId));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'الدفعة المالية والتحويل البنكي',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: releaseAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (release) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Status card
                      _buildStatusCard(release),
                      const SizedBox(height: 16),

                      // Financial Ledger details
                      _buildPayoutLedgerCard(release),
                      const SizedBox(height: 16),

                      // Release steps timeline log
                      _buildReleaseTimelineCard(release),
                    ],
                  ),
                ),
              ),

              // Bottom Actions
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showActionSnackbar(context, 'جاري تحميل الفاتورة الضريبية...'),
                          icon: const Icon(Icons.download_outlined, size: 16, color: Color(0xFF0040E0)),
                          label: const Text('تحميل الفاتورة', style: TextStyle(color: Color(0xFF0040E0), fontSize: 12, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0040E0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.push('/orders/activity-log?rfqId=$rfqId'); // Go to Activity Log next step
                          },
                          icon: const Icon(Icons.history_outlined, size: 16, color: Colors.white),
                          label: const Text('سجل النشاطات الكامل', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0040E0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: const Size(0, 48),
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

  Widget _buildStatusCard(dynamic release) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFE2F9F5), shape: BoxShape.circle),
            child: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF006B5F), size: 36),
          ),
          const SizedBox(height: 12),
          Text(
            release.paymentStatus,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF006B5F)),
          ),
          const SizedBox(height: 4),
          const Text('الدفعة مؤمنة في حساب نسيجي الضامن (Escrow)', style: TextStyle(fontSize: 10, color: AppColors.outline)),
        ],
      ),
    );
  }

  Widget _buildPayoutLedgerCard(dynamic release) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('تفاصيل الحساب المالي للطلب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          const SizedBox(height: 12),
          _buildRowItem('إجمالي قيمة الطلب للعميل', '${release.orderTotal.toStringAsFixed(2)} ر.س'),
          const SizedBox(height: 10),
          _buildRowItem('عمولة منصة نسيجي (2.5%)', '${release.commission.toStringAsFixed(2)} ر.س'),
          const SizedBox(height: 10),
          _buildRowItem('تاريخ التحويل المتوقع للحساب البنكي', release.expectedReleaseDate),
          const SizedBox(height: 10),
          _buildRowItem('رقم المرجعية للتحويل (Reference ID)', release.transferReference),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${release.supplierReceivable.toStringAsFixed(2)} ر.س',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF006B5F)),
              ),
              const Text('صافي مستحقات المورد', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReleaseTimelineCard(dynamic release) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('تتبع مراحل صرف الدفعة المعتمدة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 16),
          ...release.releaseTimeline.map((step) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      step,
                      style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 16),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.left)),
        const SizedBox(width: 10),
        Text('$label:', style: const TextStyle(fontSize: 11, color: AppColors.outline)),
      ],
    );
  }

  void _showActionSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
