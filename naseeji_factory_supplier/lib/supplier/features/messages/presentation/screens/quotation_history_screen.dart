// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/business_message.dart';
import '../../data/repositories/messages_repository_impl.dart';

part 'quotation_history_screen.g.dart';

@riverpod
Future<List<BusinessMessage>> quotationHistory(
  QuotationHistoryRef ref,
  String conversationId,
) async {
  final repo = ref.watch(messagesRepositoryProvider);
  return repo.getAllQuotationCards(conversationId);
}

class QuotationHistoryScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const QuotationHistoryScreen({super.key, required this.conversationId});

  @override
  ConsumerState<QuotationHistoryScreen> createState() => _QuotationHistoryScreenState();
}

class _QuotationHistoryScreenState extends ConsumerState<QuotationHistoryScreen> {
  final Set<String> _selectedForCompare = {};
  bool _compareMode = false;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(quotationHistoryProvider(widget.conversationId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: Text('سجل العروض', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => setState(() => _compareMode = !_compareMode),
            child: Text(
              _compareMode ? 'إلغاء' : 'مقارنة',
              style: TextStyle(color: _compareMode ? Colors.red : AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: historyAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (quotations) {
          if (quotations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.request_quote_outlined, size: 64, color: AppColors.outlineVariant),
                  SizedBox(height: 12),
                  Text('لا توجد عروض أسعار بعد', style: TextStyle(color: AppColors.outline)),
                ],
              ),
            );
          }

          return Column(
            children: [
              if (_compareMode && _selectedForCompare.length == 2)
                _CompareButton(onCompare: () => _showComparison(context, quotations)),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: quotations.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final q = quotations[i];
                    final data = q.cardData ?? {};
                    final prevData = i > 0 ? quotations[i - 1].cardData ?? {} : null;
                    final isSelected = _selectedForCompare.contains(q.id);
                    return _QuotationVersionCard(
                      message: q,
                      data: data,
                      previousData: prevData,
                      index: i,
                      isCompareMode: _compareMode,
                      isSelected: isSelected,
                      onSelect: () {
                        setState(() {
                          if (isSelected) {
                            _selectedForCompare.remove(q.id);
                          } else if (_selectedForCompare.length < 2) {
                            _selectedForCompare.add(q.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showComparison(BuildContext context, List<BusinessMessage> quotations) {
    final selected = quotations.where((q) => _selectedForCompare.contains(q.id)).toList();
    if (selected.length < 2) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (_, controller) => _ComparisonSheet(quotations: selected, scrollController: controller),
      ),
    );
  }
}

class _QuotationVersionCard extends StatelessWidget {
  final BusinessMessage message;
  final Map<String, dynamic> data;
  final Map<String, dynamic>? previousData;
  final int index;
  final bool isCompareMode;
  final bool isSelected;
  final VoidCallback onSelect;

  const _QuotationVersionCard({
    required this.message,
    required this.data,
    this.previousData,
    required this.index,
    required this.isCompareMode,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final status = data['status'] as String? ?? 'pending';
    final isAccepted = status == 'accepted';
    final version = data['version'] as String? ?? 'V${index + 1}';

    // Price diff calculation
    String? priceDiff;
    if (previousData != null) {
      final prevPrice = double.tryParse(previousData!['unitPrice']?.toString() ?? '');
      final curPrice = double.tryParse(data['unitPrice']?.toString() ?? '');
      if (prevPrice != null && curPrice != null) {
        final diff = curPrice - prevPrice;
        priceDiff = diff >= 0 ? '+${diff.toStringAsFixed(2)}' : diff.toStringAsFixed(2);
      }
    }

    return GestureDetector(
      onTap: isCompareMode ? onSelect : null,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : isAccepted ? AppColors.secondary : AppColors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isAccepted ? AppColors.secondary : AppColors.primary,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Row(
                children: [
                  if (isCompareMode)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: Theme.of(context).colorScheme.surface, size: 20),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                    child: Text(isAccepted ? 'مقبول' : 'في الانتظار', style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 10)),
                  ),
                  const Spacer(),
                  Text('إصدار $version · ${message.time}', style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (priceDiff != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: priceDiff.startsWith('+') ? Colors.red.shade50 : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            priceDiff,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: priceDiff.startsWith('+') ? Colors.red : Colors.green,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      Text(
                        '${data['unitPrice'] ?? '--'} جنيه/م',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _Row(label: 'الكمية', value: '${data['quantity'] ?? '--'}'),
                  _Row(label: 'مدة التسليم', value: '${data['deliveryDays'] ?? '--'}'),
                  _Row(label: 'شروط الدفع', value: '${data['paymentTerms'] ?? '--'}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
          Text(label, style: TextStyle(fontSize: 11, color: AppColors.outline)),
        ],
      ),
    );
  }
}

class _CompareButton extends StatelessWidget {
  final VoidCallback onCompare;
  const _CompareButton({required this.onCompare});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.05),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 36,
            child: ElevatedButton.icon(
              onPressed: onCompare,
              icon: const Icon(Icons.compare_arrows, size: 16),
              label: Text('مقارنة الإصدارين', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Text('تم اختيار إصدارين', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ComparisonSheet extends StatelessWidget {
  final List<BusinessMessage> quotations;
  final ScrollController scrollController;

  const _ComparisonSheet({required this.quotations, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final q1 = quotations[0].cardData ?? {};
    final q2 = quotations[1].cardData ?? {};
    final fields = ['unitPrice', 'quantity', 'deliveryDays', 'paymentTerms', 'validUntil'];
    final labels = ['سعر الوحدة', 'الكمية', 'مدة التسليم', 'شروط الدفع', 'صالح حتى'];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('مقارنة العروض', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(q2['version']?.toString() ?? 'V2', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary), textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text('البند', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.outline), textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text(q1['version']?.toString() ?? 'V1', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary), textAlign: TextAlign.center)),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: fields.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) => Row(
                children: [
                  Expanded(flex: 2, child: Text(q2[fields[i]]?.toString() ?? '--', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(flex: 2, child: Text(labels[i], textAlign: TextAlign.center, style: TextStyle(color: AppColors.outline, fontSize: 12))),
                  Expanded(flex: 2, child: Text(q1[fields[i]]?.toString() ?? '--', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



