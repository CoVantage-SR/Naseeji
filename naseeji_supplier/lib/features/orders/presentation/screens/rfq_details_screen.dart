import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/rfq_details_controller.dart';
import 'widgets/rfq_details_widgets.dart';

class RfqDetailsScreen extends ConsumerWidget {
  final String rfqId;

  const RfqDetailsScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(rfqDetailsControllerProvider(rfqId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'تفاصيل طلب السعر',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'RFQ #$rfqId',
              style: TextStyle(
                color: AppColors.outline,
                fontSize: 10,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.onSurfaceVariant,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: AppColors.onSurfaceVariant),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
            onPressed: () {},
          ),
          SizedBox(width: 8),
        ],
      ),
      body: detailsAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (details) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FactoryInfoCard(details: details),
                      SizedBox(height: 16),
                      RequestedProductCard(details: details),
                      SizedBox(height: 16),
                      TechnicalSpecsCard(details: details),
                      SizedBox(height: 16),
                      PackagingShippingCard(details: details),
                      SizedBox(height: 16),
                      FactoryNotesCard(details: details),
                      SizedBox(height: 16),
                      const AttachmentsSection(),
                    ],
                  ),
                ),
              ),
              RfqDetailsBottomBar(rfqId: details.rfqId),
            ],
          );
        },
      ),
    );
  }
}