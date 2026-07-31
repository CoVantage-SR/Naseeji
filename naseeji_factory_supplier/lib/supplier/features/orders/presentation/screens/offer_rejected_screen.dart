import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../controllers/offer_rejected_controller.dart';
import 'widgets/offer_rejected_widgets.dart';

class OfferRejectedScreen extends ConsumerWidget {
  final String rfqId;

  const OfferRejectedScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(offerRejectedControllerProvider(rfqId));

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تفاصيل العرض',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        leading: Row(
          children:  [
            SizedBox(width: 16),
            Text(
              'Naseeji',
              style: TextStyle(
                color: Color(0xFF0040E0),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        leadingWidth: 100,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: AppColors.onSurfaceVariant),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/orders/order-center?rfqId=$rfqId');
              }
            },
          ),
        ],
      ),
      body: detailsAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (details) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      RejectionHeader(details: details),
                      SizedBox(height: 24),
                      RejectionNotesCard(details: details),
                      SizedBox(height: 16),
                      SuggestedChangesCard(details: details),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(details.standardsImage),
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
                                Colors.black.withValues(alpha: 0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          alignment: Alignment.bottomRight,
                          child: Text(
                            details.standardsLabel,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RejectionActionButtonBar(rfqId: details.rfqId),
            ],
          );
        },
      ),
    );
  }
}

