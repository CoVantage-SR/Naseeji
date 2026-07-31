import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/deals_providers.dart';
import '../widgets/deal_status_badge_widget.dart';
import '../widgets/deal_tabs_widget.dart';
import '../widgets/quick_actions_widget.dart';
import '../widgets/loading_widget.dart';

class DealDetailsScreen extends ConsumerWidget {
  final String dealId;

  const DealDetailsScreen({
    super.key,
    required this.dealId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dealAsync = ref.watch(dealDetailsProvider(dealId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0.5,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            onPressed: () => context.pop(),
          ),
          title: dealAsync.maybeWhen(
            data: (deal) => Column(
              children: [
                Text(
                  deal.dealNumber,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.primary),
                ),
                Text(
                  deal.factoryInfo.name,
                  style: TextStyle(fontSize: 9.5, color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            orElse: () => const Text('تفاصيل الصفقة', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          actions: [
            dealAsync.maybeWhen(
              data: (deal) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Center(child: DealStatusBadgeWidget(status: deal.status)),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
        body: dealAsync.when(
          loading: () => const LoadingWidget(),
          error: (err, _) => Center(
            child: Text('حدث خطأ في تحميل تفاصيل الصفقة: $err', style: const TextStyle(color: Colors.red, fontSize: 11)),
          ),
          data: (deal) {
            return Column(
              children: [
                // Modular 10-Tab Content System
                Expanded(
                  child: DealTabsWidget(deal: deal),
                ),

                // Contextual Bottom Quick Actions Bar
                QuickActionsWidget(deal: deal),
              ],
            );
          },
        ),
      ),
    );
  }
}


