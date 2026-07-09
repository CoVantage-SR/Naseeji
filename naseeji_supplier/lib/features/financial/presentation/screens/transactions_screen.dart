import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/financial_controllers.dart';
import '../widgets/transaction_card.dart';
import '../../domain/entities/financial_models.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String _searchQuery = '';
  TransactionType? _selectedType;
  TransactionStatus? _selectedStatus;
  bool _sortByAmount = false;

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(financialTransactionsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'سجل المعاملات والعمليات',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري تصدير العمليات بصيغة CSV...')),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: transactionsAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (err, stack) => Center(child: Text('خطأ: $err')),
          data: (list) {
            // Apply filtering logic
            var filtered = list.where((txn) {
              final matchesSearch = txn.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  txn.factoryName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  txn.orderNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  txn.referenceNumber.toLowerCase().contains(_searchQuery.toLowerCase());
              
              final matchesType = _selectedType == null || txn.type == _selectedType;
              final matchesStatus = _selectedStatus == null || txn.status == _selectedStatus;

              return matchesSearch && matchesType && matchesStatus;
            }).toList();

            // Apply sorting logic
            if (_sortByAmount) {
              filtered.sort((a, b) => b.amount.abs().compareTo(a.amount.abs()));
            } else {
              filtered.sort((a, b) => b.createdDate.compareTo(a.createdDate));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Filters and Search Bar Container
                Container(
                  color: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // Search field
                      TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: 'البحث برقم المعاملة، المصنع، المرجع...',
                          prefixIcon: const Icon(Icons.search),
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.outlineVariant),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Filter chips row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: Text('ترتيب حسب القيمة'),
                              selected: _sortByAmount,
                              onSelected: (val) => setState(() => _sortByAmount = val),
                            ),
                            SizedBox(width: 8),
                            DropdownButton<TransactionType>(
                              hint: Text('نوع العملية'),
                              value: _selectedType,
                              underline: SizedBox(),
                              items: TransactionType.values.map((t) {
                                return DropdownMenuItem(
                                  value: t,
                                  child: Text(_typeLabel(t)),
                                );
                              }).toList(),
                              onChanged: (val) => setState(() => _selectedType = val),
                            ),
                            SizedBox(width: 8),
                            DropdownButton<TransactionStatus>(
                              hint: Text('الحالة'),
                              value: _selectedStatus,
                              underline: SizedBox(),
                              items: TransactionStatus.values.map((s) {
                                return DropdownMenuItem(
                                  value: s,
                                  child: Text(_statusLabel(s)),
                                );
                              }).toList(),
                              onChanged: (val) => setState(() => _selectedStatus = val),
                            ),
                            if (_selectedType != null || _selectedStatus != null || _sortByAmount) ...[
                              SizedBox(width: 8),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedType = null;
                                    _selectedStatus = null;
                                    _sortByAmount = false;
                                    _searchQuery = '';
                                  });
                                },
                                child: Text('إعادة تعيين'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Transactions List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => ref.read(financialTransactionsControllerProvider.notifier).refresh(),
                    color: AppColors.primary,
                    child: filtered.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 120),
                              Center(
                                child: Text(
                                  'لا توجد عمليات تطابق معايير البحث والفلترة',
                                  style: TextStyle(color: AppColors.outline),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              return TransactionCard(transaction: filtered[index]);
                            },
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

  String _typeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.paymentReceived:
        return 'دفعة مستلمة';
      case TransactionType.paymentPending:
        return 'دفعة معلقة بالضمان';
      case TransactionType.withdrawal:
        return 'عملية سحب';
      case TransactionType.refund:
        return 'مبلغ مسترد لعميل';
      case TransactionType.platformCommission:
        return 'عمولة منصة نسيجي';
      case TransactionType.advertisingFee:
        return 'رسوم إعلانية';
      case TransactionType.subscriptionFee:
        return 'اشتراك باقة';
      case TransactionType.manualAdjustment:
        return 'تعديل يدوي';
      case TransactionType.tax:
        return 'ضريبة';
      case TransactionType.shippingFee:
        return 'رسوم شحن';
    }
  }

  String _statusLabel(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return 'مكتمل';
      case TransactionStatus.pending:
        return 'معلق';
      case TransactionStatus.failed:
        return 'فاشل';
    }
  }
}