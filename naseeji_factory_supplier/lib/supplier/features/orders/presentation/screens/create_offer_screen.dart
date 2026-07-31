import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import 'widgets/create_offer_widgets.dart';

class CreateOfferScreen extends StatefulWidget {
  final String rfqId;

  const CreateOfferScreen({super.key, required this.rfqId});

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  final _unitPriceController = TextEditingController(text: '0.00');
  final _moqController = TextEditingController(text: '100');
  final _qtyController = TextEditingController(text: '5000');
  final _prodPeriodController = TextEditingController(text: '5-7');
  final _deliveryPeriodController = TextEditingController(text: '2');
  final _shippingCostController = TextEditingController(text: 'مجاني');
  final _cashDiscountController = TextEditingController(text: '0');
  final _vatController = TextEditingController(text: '15');
  final _paymentTermsController = TextEditingController(text: 'Net 30');
  final _validityController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _unitPriceController.dispose();
    _moqController.dispose();
    _qtyController.dispose();
    _prodPeriodController.dispose();
    _deliveryPeriodController.dispose();
    _shippingCostController.dispose();
    _cashDiscountController.dispose();
    _vatController.dispose();
    _paymentTermsController.dispose();
    _validityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'إنشاء عرض سعر',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.onSurfaceVariant,
            size: 20,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/orders/order-center?rfqId=${widget.rfqId}');
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
            onPressed: () {},
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CreateOfferHeader(rfqId: widget.rfqId),
                  SizedBox(height: 20),
                  PricingQuantitiesCard(
                    unitPriceController: _unitPriceController,
                    qtyController: _qtyController,
                    moqController: _moqController,
                  ),
                  SizedBox(height: 16),
                  LogisticsServicesCard(
                    prodPeriodController: _prodPeriodController,
                    shippingCostController: _shippingCostController,
                    deliveryPeriodController: _deliveryPeriodController,
                  ),
                  SizedBox(height: 16),
                  TermsConditionsCard(
                    vatController: _vatController,
                    cashDiscountController: _cashDiscountController,
                    paymentTermsController: _paymentTermsController,
                    validityController: _validityController,
                  ),
                  SizedBox(height: 16),
                  AdditionalNotesCard(notesController: _notesController),
                  SizedBox(height: 16),
                  const CreateOfferAttachmentsCard(),
                ],
              ),
            ),
          ),
          CreateOfferBottomBar(
            rfqId: widget.rfqId,
            onSaveDraft: () => _showSuccessDialog('تم حفظ العرض كمسودة بنجاح'),
            onSend: () => _showSuccessDialog('تم إرسال عرض السعر بنجاح'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Color(0xFF16A34A), size: 48),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Pop dialog
              context.go('/orders'); // Navigate back to orders list
            },
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }
}
