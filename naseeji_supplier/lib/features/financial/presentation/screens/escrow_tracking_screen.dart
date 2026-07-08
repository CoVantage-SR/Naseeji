import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/financial_controllers.dart';
import '../widgets/escrow_progress_widget.dart';

class EscrowTrackingScreen extends ConsumerStatefulWidget {
  const EscrowTrackingScreen({super.key});

  @override
  ConsumerState<EscrowTrackingScreen> createState() => _EscrowTrackingScreenState();
}

class _EscrowTrackingScreenState extends ConsumerState<EscrowTrackingScreen> {
  String _selectedOrderNumber = 'ORD-5541';

  final List<String> _orders = ['ORD-5541', 'ORD-5539', 'ORD-5530', 'ORD-5488'];

  @override
  Widget build(BuildContext context) {
    final escrowAsync = ref.watch(escrowTrackingControllerProvider(_selectedOrderNumber));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تتبع الضمان وحماية الدفعات',
          style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        color: const Color(0xFFF8F9FF),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Order Selector Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'اختر رقم طلب الشراء للتتبع',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12, color: AppColors.outline, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedOrderNumber,
                      decoration: InputDecoration(
                        fillColor: const Color(0xFFF8F9FF),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.outlineVariant),
                        ),
                      ),
                      items: _orders.map((ord) {
                        return DropdownMenuItem(
                          value: ord,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(ord),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedOrderNumber = val);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              escrowAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('خطأ: $err')),
                data: (data) {
                  final releaseDateStr = data.releaseDate != null
                      ? '${data.releaseDate!.year}-${data.releaseDate!.month.toString().padLeft(2, '0')}-${data.releaseDate!.day.toString().padLeft(2, '0')}'
                      : 'قيد المراجعة الفنية للمطابقة';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Balance Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF006B5F),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF006B5F).withValues(alpha: 0.25),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'قيمة الأموال المؤمنة بحساب الضمان الموحد',
                              style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${data.escrowAmount.toStringAsFixed(2)} ر.س',
                              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'تاريخ الإفراج المقدر: $releaseDateStr',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Hold Reason Banner
                      if (data.reasonForHold != null && data.reasonForHold!.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFAE6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFB17000).withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline, color: Color(0xFFB17000), size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  data.reasonForHold!,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 11, color: Color(0xFFB17000), fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Escrow Timeline Card
                      const Text(
                        'خطوات تسلسل تحرير وإخلاء الضمان',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        child: EscrowProgressWidget(currentStage: data.currentStage),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
