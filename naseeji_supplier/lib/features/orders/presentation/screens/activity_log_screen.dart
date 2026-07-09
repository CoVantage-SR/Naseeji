import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/activity_log_controller.dart';
import '../../domain/entities/activity_log.dart';

class ActivityLogScreen extends ConsumerStatefulWidget {
  final String rfqId;

  const ActivityLogScreen({super.key, required this.rfqId});

  @override
  ConsumerState<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends ConsumerState<ActivityLogScreen> {
  String selectedFilter = 'الكل';

  @override
  Widget build(BuildContext context) {
    final logAsync = ref.watch(activityLogControllerProvider(widget.rfqId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'سجل النشاطات والتدقيق للطلب',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: logAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (logs) {
          final filteredLogs = _filterLogs(logs);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filters row
              _buildFiltersBar(),

              // Logs List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredLogs.length,
                  itemBuilder: (context, index) {
                    final item = filteredLogs[index];
                    return _buildLogItemTile(item);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFiltersBar() {
    final filters = ['الكل', 'الشحن', 'المالية', 'الجودة'];
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: filters.map((f) {
          final isSelected = selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(f, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant)),
              selected: isSelected,
              selectedColor: const Color(0xFF0040E0),
              backgroundColor: const Color(0xFFF1F1F5),
              onSelected: (val) {
                if (val) {
                  setState(() {
                    selectedFilter = f;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  List<ActivityLogItem> _filterLogs(List<ActivityLogItem> items) {
    if (selectedFilter == 'الكل') return items;
    if (selectedFilter == 'الشحن') {
      return items.where((element) => element.iconTag == 'shipping').toList();
    }
    if (selectedFilter == 'المالية') {
      return items.where((element) => element.iconTag == 'payment').toList();
    }
    if (selectedFilter == 'الجودة') {
      return items.where((element) => element.iconTag == 'verified').toList();
    }
    return items;
  }

  Widget _buildLogItemTile(ActivityLogItem item) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E1EF)),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Details (Left)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.date, style: TextStyle(fontSize: 9, color: AppColors.outline)),
                Text(item.time, style: TextStyle(fontSize: 8, color: AppColors.outline)),
              ],
            ),
            const Spacer(),

            // Content details (Right)
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.action,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    textAlign: TextAlign.end,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'المستخدم: ${item.user} • الجهاز: ${item.device}',
                    style: TextStyle(fontSize: 9, color: AppColors.outline),
                    textAlign: TextAlign.end,
                  ),
                  if (item.attachments != null && item.attachments!.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      alignment: WrapAlignment.end,
                      children: item.attachments!.map((file) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F1F5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(file, style: TextStyle(fontSize: 8, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                              SizedBox(width: 4),
                              const Icon(Icons.attach_file, size: 8, color: AppColors.outline),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 12),

            // Icon Tag Indicator
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getIconBgColor(item.iconTag),
                shape: BoxShape.circle,
              ),
              child: Icon(_getIconData(item.iconTag), color: _getIconColor(item.iconTag), size: 16),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String tag) {
    if (tag == 'payment') return Icons.payment_outlined;
    if (tag == 'delivery') return Icons.done_all_outlined;
    if (tag == 'shipping') return Icons.local_shipping_outlined;
    if (tag == 'verified') return Icons.verified_outlined;
    return Icons.info_outline;
  }

  Color _getIconBgColor(String tag) {
    if (tag == 'payment') return const Color(0xFFE2F9F5);
    if (tag == 'delivery') return const Color(0xFFE8F0FE);
    if (tag == 'shipping') return const Color(0xFFFFF7ED);
    if (tag == 'verified') return const Color(0xFFE2F9F5);
    return const Color(0xFFF1F1F5);
  }

  Color _getIconColor(String tag) {
    if (tag == 'payment') return const Color(0xFF006B5F);
    if (tag == 'delivery') return const Color(0xFF0040E0);
    if (tag == 'shipping') return Colors.orange;
    if (tag == 'verified') return const Color(0xFF006B5F);
    return AppColors.outline;
  }
}
