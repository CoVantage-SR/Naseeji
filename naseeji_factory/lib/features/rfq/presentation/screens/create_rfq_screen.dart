import 'package:flutter/material.dart';
import '../widgets/create_rfq/create_rfq_form.dart';

class CreateRFQScreen extends StatelessWidget {
  const CreateRFQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلب عرض سعر جديد (RFQ)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const SafeArea(
        child: CreateRFQForm(),
      ),
    );
  }
}
