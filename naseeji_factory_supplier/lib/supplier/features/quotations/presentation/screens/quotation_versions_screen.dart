import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../controllers/quotations_controller.dart';
import '../../domain/entities/quotation_model.dart';
import '../widgets/quotation_version_card.dart';

class QuotationVersionsScreen extends ConsumerStatefulWidget {
  final String quotationId;

  const QuotationVersionsScreen({super.key, required this.quotationId});

  @override
  ConsumerState<QuotationVersionsScreen> createState() => _QuotationVersionsScreenState();
}

class _QuotationVersionsScreenState extends ConsumerState<QuotationVersionsScreen> {
  final List<String> _selectedVersionsForCompare = [];

  void _handleCompare(QuotationModel q) {
    if (_selectedVersionsForCompare.length != 2) return;
    
    final v1Code = _selectedVersionsForCompare[0];
    final v2Code = _selectedVersionsForCompare[1];

    final rev1 = q.revisions.firstWhere((r) => r.version == v1Code, orElse: () => QuotationRevisionModel(
      version: 'v1.0',
      supplierPrice: q.supplierUnitPrice,
      factoryCounterOffer: q.originalRequestedPrice,
      priceDifference: (q.supplierUnitPrice - q.originalRequestedPrice).abs(),
      reason: 'النسخة الحالية الأساسية',
      createdDate: q.createdDate,
      negotiatedBy: 'مورد نسيجي',
      status: 'أساسي',
    ));

    final rev2 = q.revisions.firstWhere((r) => r.version == v2Code, orElse: () => QuotationRevisionModel(
      version: 'v1.0',
      supplierPrice: q.supplierUnitPrice,
      factoryCounterOffer: q.originalRequestedPrice,
      priceDifference: (q.supplierUnitPrice - q.originalRequestedPrice).abs(),
      reason: 'النسخة الحالية الأساسية',
      createdDate: q.createdDate,
      negotiatedBy: 'مورد نسيجي',
      status: 'أساسي',
    ));

    _showComparisonDialog(rev1, rev2);
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(quotationsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            'سجل إصدارات العرض ${widget.quotationId}',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: stateAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (quotations) {
            final index = quotations.indexWhere((q) => q.id == widget.quotationId);
            if (index == -1) {
              return Center(child: Text('عرض السعر غير موجود'));
            }
            final q = quotations[index];

            // Formulate versions list (including current as v[q.version])
            final allRevisions = List<QuotationRevisionModel>.from(q.revisions);
            if (allRevisions.isEmpty) {
              // Add a default first version representing the base quotation
              allRevisions.add(QuotationRevisionModel(
                version: 'v${q.version}',
                supplierPrice: q.supplierUnitPrice,
                factoryCounterOffer: q.originalRequestedPrice,
                priceDifference: (q.supplierUnitPrice - q.originalRequestedPrice).abs(),
                reason: 'العرض الأساسي لطلب الأسعار.',
                createdDate: q.createdDate,
                negotiatedBy: 'مورد نسيجي',
                status: q.status == QuotationStatus.accepted ? 'مقبول ومعتمد' : 'مفتوح ونشط',
              ));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: allRevisions.length,
                    itemBuilder: (context, index) {
                      final rev = allRevisions[index];
                      final isSelected = _selectedVersionsForCompare.contains(rev.version);

                      return QuotationVersionCard(
                        revision: rev,
                        isSelectedForComparison: isSelected,
                        onSelectForCompare: (checked) {
                          setState(() {
                            if (checked == true) {
                              if (_selectedVersionsForCompare.length >= 2) {
                                _selectedVersionsForCompare.removeAt(0);
                              }
                              _selectedVersionsForCompare.add(rev.version);
                            } else {
                              _selectedVersionsForCompare.remove(rev.version);
                            }
                          });
                        },
                        onView: () => _showVersionDetailsDialog(rev),
                        onDuplicate: () {
                          ref.read(quotationsControllerProvider.notifier).duplicate(q.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم نسخ وتكرار العرض كمسودة بنجاح.')),
                          );
                        },
                        onRestoreDraft: q.status == QuotationStatus.draft ? () {
                          ref.read(quotationsControllerProvider.notifier).sendCounterOffer(
                            q.id,
                            rev.supplierPrice,
                            'تمت استعادة وتفعيل النسخة السابقة ${rev.version}'
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تمت استعادة النسخة ${rev.version} بنجاح.')),
                          );
                        } : null,
                      );
                    },
                  ),
                ),

                // Comparison Bar at the bottom
                if (_selectedVersionsForCompare.isNotEmpty)
                  Container(
                    color: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'تم تحديد ${_selectedVersionsForCompare.length} من الإصدارات للمقارنة',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.outline),
                          ),
                          ElevatedButton(
                            onPressed: _selectedVersionsForCompare.length == 2
                                ? () => _handleCompare(q)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              disabledBackgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              elevation: 0,
                            ),
                            child: Text(
                              'قارن النسختين الآن',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
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
      ),
    );
  }

  void _showVersionDetailsDialog(QuotationRevisionModel rev) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل إصدار العرض ${rev.version}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogRow('سعر وحدة المورد المقترح', '${rev.supplierPrice.toStringAsFixed(2)} جنيه'),
            _buildDialogRow('السعر المستهدف للمشتري', '${rev.factoryCounterOffer.toStringAsFixed(2)} جنيه'),
            _buildDialogRow('فارق التكلفة المالي الكلي', '${rev.priceDifference.toStringAsFixed(2)} جنيه'),
            _buildDialogRow('تاريخ المراجعة الفعلي', rev.createdDate),
            _buildDialogRow('المفاوض القائم بالقرار', rev.negotiatedBy),
            _buildDialogRow('حالة الإصدار المعتمدة', rev.status),
            SizedBox(height: 12),
            Text('ملاحظات المراجعة وتبرير الهامش:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.outline)),
            SizedBox(height: 4),
            Text(rev.reason, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.3)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إغلاق')),
        ],
      ),
    );
  }

  void _showComparisonDialog(QuotationRevisionModel rev1, QuotationRevisionModel rev2) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('المقارنة المباشرة بين الإصدارين', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        content: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Table(
                border: TableBorder.all(color: const Color(0xFFE2E1EF), width: 0.5),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLow),
                    children: [
                      _buildCell('الخاصية'),
                      _buildCell(rev1.version),
                      _buildCell(rev2.version),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildCell('سعر المورد'),
                      _buildCell('${rev1.supplierPrice} جنيه'),
                      _buildCell('${rev2.supplierPrice} جنيه'),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildCell('سعر المصنع'),
                      _buildCell('${rev1.factoryCounterOffer} جنيه'),
                      _buildCell('${rev2.factoryCounterOffer} جنيه'),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildCell('الفرق المالي'),
                      _buildCell('${rev1.priceDifference} جنيه'),
                      _buildCell('${rev2.priceDifference} ر.s'),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildCell('حالة الاعتماد'),
                      _buildCell(rev1.status),
                      _buildCell(rev2.status),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إغلاق')),
        ],
      ),
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: AppColors.outline)),
          Text(value, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: TextStyle(fontSize: 9), textAlign: TextAlign.center),
      ),
    );
  }
}
