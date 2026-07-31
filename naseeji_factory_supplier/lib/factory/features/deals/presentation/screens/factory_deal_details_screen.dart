import 'package:flutter/material.dart';
import '../../../orders/presentation/screens/factory_deal_details_screen.dart';

/// Target Screen Export for Deals feature path
class FactoryDealDetailsScreenExport extends StatelessWidget {
  final String dealId;

  const FactoryDealDetailsScreenExport({super.key, required this.dealId});

  @override
  Widget build(BuildContext context) {
    return FactoryDealDetailsScreen(dealId: dealId);
  }
}

