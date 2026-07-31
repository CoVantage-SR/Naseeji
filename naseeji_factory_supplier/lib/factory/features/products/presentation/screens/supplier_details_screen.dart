import 'package:flutter/material.dart';
import '../../../suppliers/presentation/screens/factory_supplier_details_screen.dart';

class SupplierDetailsScreen extends StatelessWidget {
  final String supplierId;

  const SupplierDetailsScreen({super.key, required this.supplierId});

  @override
  Widget build(BuildContext context) {
    return FactorySupplierDetailsScreen(supplierId: supplierId);
  }
}
