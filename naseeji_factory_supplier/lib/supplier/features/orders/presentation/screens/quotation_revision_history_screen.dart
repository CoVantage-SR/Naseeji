import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../controllers/quotation_history_controller.dart';
import '../../domain/entities/quotation_revision.dart';

class QuotationRevisionHistoryScreen extends ConsumerStatefulWidget {
  final String rfqId;

  const QuotationRevisionHistoryScreen({super.key, required this.rfqId});

  @override
  ConsumerState<QuotationRevisionHistoryScreen> createState() => _QuotationRevisionHistoryScreenState();
}

class _QuotationRevisionHistoryScreenState extends ConsumerState<QuotationRevisionHistoryScreen> {
  int? selectedVer1;
  int? selectedVer2;

  void _handleCompare() {
    if (selectedVer1 != null && selectedVer2 != null) {
      final history = ref.read(quotationHistoryControllerProvider(widget.rfqId)).valueOrNull ?? [];
      final rev1 = history.firstWhere((element) => element.versionNumber == selectedVer1);
      final rev2 = history.firstWhere((element) => element.versionNumber == selectedVer2);
      _showCompareDialog(rev1, rev2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(quotationHistoryControllerProvider(widget.rfqId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'سجل مراجعات العروض',
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
      body: historyAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (history) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final revision = history[index];
                    return _buildRevisionCard(revision);
                  },
                ),
              ),

              // Compare Selector Panel
              if (history.length >= 2)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: const Border(
                      top: BorderSide(color: Color(0xFF0040E0), width: 2.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'قارن بين نسختين من العرض',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFE2E1EF)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButton<int>(
                                  value: selectedVer2,
                                  hint: Text('النسخة الثانية', style: TextStyle(fontSize: 12)),
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  items: history
                                      .where((e) => e.versionNumber != selectedVer1)
                                      .map((e) => DropdownMenuItem(
                                            value: e.versionNumber,
                                            child: Text('نسخة ${e.versionNumber} (${e.price.toStringAsFixed(2)} جنيه)'),
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedVer2 = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFE2E1EF)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButton<int>(
                                  value: selectedVer1,
                                  hint: Text('النسخة الأولى', style: TextStyle(fontSize: 12)),
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  items: history
                                      .where((e) => e.versionNumber != selectedVer2)
                                      .map((e) => DropdownMenuItem(
                                            value: e.versionNumber,
                                            child: Text('نسخة ${e.versionNumber} (${e.price.toStringAsFixed(2)} جنيه)'),
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedVer1 = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14),
                        ElevatedButton(
                          onPressed: (selectedVer1 != null && selectedVer2 != null) ? _handleCompare : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0040E0),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade200,
                            disabledForegroundColor: Colors.grey.shade400,
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: Text('بدء المقارنة الآن', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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

  Widget _buildRevisionCard(QuotationRevision revision) {
    final isSelected = selectedVer1 == revision.versionNumber || selectedVer2 == revision.versionNumber;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? const Color(0xFF0040E0) : const Color(0xFFE2E1EF),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusBgColor(revision.status),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    revision.status,
                    style: TextStyle(
                      color: _getStatusTextColor(revision.status),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'مراجعة نسخة رقم #${revision.versionNumber}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildRowItem('بواسطة', revision.createdBy),
            SizedBox(height: 6),
            _buildRowItem('التوقيت والاصدار', '${revision.date} في ${revision.time}'),
            SizedBox(height: 6),
            _buildRowItem('السعر المقترح', '${revision.price.toStringAsFixed(2)} جنيه / م'),
            SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF1F1F5)),
            SizedBox(height: 8),
            Text(
              revision.notes,
              style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        SizedBox(width: 8),
        Text('$label:', style: TextStyle(fontSize: 11, color: AppColors.outline)),
      ],
    );
  }

  Color _getStatusBgColor(String status) {
    if (status == 'مقبول') return const Color(0xFFDCFCE7);
    if (status == 'مرفوض') return const Color(0xFFFEE2E2);
    return const Color(0xFFF1F1F5);
  }

  Color _getStatusTextColor(String status) {
    if (status == 'مقبول') return const Color(0xFF16A34A);
    if (status == 'مرفوض') return const Color(0xFFDC2626);
    return AppColors.outline;
  }

  void _showCompareDialog(QuotationRevision rev1, QuotationRevision rev2) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'مقارنة تفاصيل نسختي العرض',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('نسخة ${rev2.versionNumber}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    SizedBox(height: 8),
                    Text('${rev2.price.toStringAsFixed(2)} جنيه', style: TextStyle(fontSize: 14, color: AppColors.error, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(rev2.createdBy, style: TextStyle(fontSize: 10, color: AppColors.outline)),
                  ],
                ),
                Container(width: 1, height: 60, color: const Color(0xFFE2E1EF)),
                Column(
                  children: [
                    Text('نسخة ${rev1.versionNumber}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    SizedBox(height: 8),
                    Text('${rev1.price.toStringAsFixed(2)} جنيه', style: TextStyle(fontSize: 14, color: Color(0xFF16A34A), fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(rev1.createdBy, style: TextStyle(fontSize: 10, color: AppColors.outline)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            const Divider(),
            SizedBox(height: 8),
            Text(
              'الفرق في النسبة: ${(((rev2.price - rev1.price).abs() / rev2.price) * 100).toStringAsFixed(1)}%',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0040E0), fontSize: 11),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
