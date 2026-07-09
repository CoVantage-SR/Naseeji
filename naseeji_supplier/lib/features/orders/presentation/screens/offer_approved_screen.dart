import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/offer_approved_controller.dart';
import 'widgets/offer_approved_widgets.dart';

class OfferApprovedScreen extends ConsumerWidget {
  final String rfqId;

  const OfferApprovedScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(offerApprovedControllerProvider(rfqId));

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'Naseeji',
          style: TextStyle(
            color: Color(0xFF0040E0),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Theme.of(context).colorScheme.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      body: detailsAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (details) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ApprovalHeader(details: details),
                SizedBox(height: 24),
                OfferSummaryCard(details: details),
                SizedBox(height: 16),
                PaymentMethodCard(details: details),
                SizedBox(height: 16),
                const NextStepsCard(),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(details.fabricTextureImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      details.fabricTextureLabel,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: Text(
                    'نظام نسيجي لإدارة الموردين © 2024',
                    style: TextStyle(color: AppColors.outline, fontSize: 10),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
