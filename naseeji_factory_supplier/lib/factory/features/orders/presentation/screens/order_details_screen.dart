import 'package:flutter/material.dart';
import 'factory_deal_details_screen.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return FactoryDealDetailsScreen(dealId: orderId);
  }
}


