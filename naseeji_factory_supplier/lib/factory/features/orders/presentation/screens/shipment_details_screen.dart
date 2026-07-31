import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/orders_provider.dart';
import '../widgets/shipment_details_widgets.dart';

class ShipmentDetailsScreen extends ConsumerWidget {
  final String orderId;

  const ShipmentDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(ordersNotifierProvider.notifier).getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('الطلب المطلوب غير موجود.')),
      );
    }

    void downloadDoc(String docName) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('جاري بدء تحميل مستند: $docName')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل ومستندات الشحن'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrackingInformationWidget(order: order),
              AppSpacing.hMD,
              ShipmentInformationWidget(order: order),
              AppSpacing.hMD,
              CarrierInformationWidget(order: order),
              AppSpacing.hMD,
              ShipmentImagesWidget(),
              AppSpacing.hMD,
              ShipmentDocumentsWidget(
                onDownload: () => downloadDoc('مستندات_الشحن.pdf'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}


