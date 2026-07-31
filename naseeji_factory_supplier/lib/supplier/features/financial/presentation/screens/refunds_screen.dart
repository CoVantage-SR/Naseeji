import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../controllers/financial_controllers.dart';
import '../../domain/entities/financial_models.dart';
import '../widgets/payment_status_badge.dart';

class RefundsScreen extends ConsumerWidget {
  const RefundsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refundsAsync = ref.watch(financialRefundsControllerProvider);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'مركز إدارة المرتجعات والتعويضات',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
            onPressed: () => context.pop(),
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.outline,
            tabs: [
              Tab(text: 'الكل'),
              Tab(text: 'معلقة بالانتظار'),
              Tab(text: 'تمت الموافقة'),
              Tab(text: 'مرفوضة / منتهية'),
            ],
          ),
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: refundsAsync.when(
            loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
            error: (err, stack) => Center(child: Text('خطأ: $err')),
            data: (refunds) {
              return TabBarView(
                children: [
                  _buildRefundList(context, refunds),
                  _buildRefundList(context, refunds.where((r) => r.status.toLowerCase() == 'pending').toList()),
                  _buildRefundList(context, refunds.where((r) => r.status.toLowerCase() == 'approved').toList()),
                  _buildRefundList(context, refunds.where((r) => r.status.toLowerCase() == 'completed' || r.status.toLowerCase() == 'rejected').toList()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRefundList(BuildContext context, List<RefundRequest> list) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          'لا توجد طلبات إرجاع مالي في هذا القسم',
          style: TextStyle(color: AppColors.outline),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final refund = list[index];
        final createdDateStr = '${refund.createdDate.year}-${refund.createdDate.month.toString().padLeft(2, '0')}-${refund.createdDate.day.toString().padLeft(2, '0')}';
        final completedDateStr = refund.completedDate != null
            ? '${refund.completedDate!.year}-${refund.completedDate!.month.toString().padLeft(2, '0')}-${refund.completedDate!.day.toString().padLeft(2, '0')}'
            : 'قيد المراجعة';

        return Card(
          color: Theme.of(context).colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PaymentStatusBadge(status: refund.status),
                    Text(
                      refund.refundNumber,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.outline),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${refund.amount.toStringAsFixed(2)} جنيه',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFBA1A1A)),
                    ),
                    Text(
                      'طلب شراء رقم: ${refund.orderNumber}',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'سبب طلب الإرجاع المالي:',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 10, color: AppColors.outline, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        refund.reason,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تاريخ الاكتمال: $completedDateStr',
                      style: TextStyle(fontSize: 11, color: AppColors.outline),
                    ),
                    Text(
                      'تاريخ الطلب: $createdDateStr',
                      style: TextStyle(fontSize: 11, color: AppColors.outline),
                    ),
                  ],
                ),
                if (refund.attachments.isNotEmpty) ...[
                  SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.outlineVariant),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ...refund.attachments.map((file) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('تحميل المرفق $file...')),
                              );
                            },
                            child: Chip(
                              label: Text(file, style: TextStyle(fontSize: 9)),
                              avatar: const Icon(Icons.attach_file, size: 10),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        );
                      }),
                      Text('المرفقات: ', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

