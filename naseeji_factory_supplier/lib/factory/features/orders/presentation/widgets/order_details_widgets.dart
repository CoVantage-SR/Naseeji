import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/core/widgets/reusable_widgets.dart';

import '../providers/orders_provider.dart';
import 'orders_reusable_widgets.dart';

class OrderHeaderWidget extends StatelessWidget {
  final OrderModel order;

  const OrderHeaderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (order.status) {
      case 'new':
        statusColor = AppColors.info;
        statusText = 'طلب جديد مؤكد';
        break;
      case 'preparing':
        statusColor = AppColors.secondary;
        statusText = 'قيد التجهيز والإنتاج';
        break;
      case 'readyToShip':
        statusColor = AppColors.warning;
        statusText = 'جاهز للشحن';
        break;
      case 'shipping':
        statusColor = Colors.purple;
        statusText = 'جاري الشحن الآن';
        break;
      case 'delivered':
        statusColor = AppColors.success;
        statusText = 'تم التسليم والاعتماد';
        break;
      case 'cancelled':
      default:
        statusColor = AppColors.error;
        statusText = 'ملغي / نزاع مفتوح';
        break;
    }

    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'أمر الشراء: ${order.id}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              StatusChip(label: statusText, color: statusColor),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'تاريخ الإنشاء: ${order.orderDate} • طلب سعر مرجعي: ${order.rfqId}',
            style: const TextStyle(color: Colors.grey, fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class AgreementSummaryWidget extends StatelessWidget {
  final OrderModel order;

  const AgreementSummaryWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InformationCard(
      title: 'ملخص الاتفاق والمنتج المعتمد',
      items: [
        {'label': 'المنتج المطلوب', 'value': order.productName},
        {'label': 'الكمية الإجمالية', 'value': '${order.quantity} وحدة'},
        {'label': 'سعر الوحدة المتفق عليه', 'value': '${(order.finalPrice / order.quantity).toStringAsFixed(2)} ج.م'},
        {'label': 'إجمالي قيمة المعاملة', 'value': '${order.finalPrice.toInt()} ج.م'},
      ],
    );
  }
}

class OrderProgressWidget extends StatelessWidget {
  final OrderModel order;

  const OrderProgressWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'حالة ومستوى إنجاز الطلب الفعلي',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'نسبة الإنجاز الإجمالية: ${order.progressPercentage.toInt()}%',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary),
              ),
              Text(
                'التسليم المتوقع: ${order.expectedDeliveryDate}',
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: order.progressPercentage / 100.0,
            color: AppColors.primary,
            backgroundColor: Colors.grey.shade200,
            borderRadius: AppRadius.rRound,
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}

class QuickActionsWidget extends StatelessWidget {
  final OrderModel order;

  const QuickActionsWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إجراءات سريعة وتفاصيل التتبع',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.8,
            children: [
              _buildActionCard(context, Icons.history_edu_rounded, 'سجل الأحداث', () => context.push('/orders/${order.id}/timeline')),
              _buildActionCard(context, Icons.factory_outlined, 'مراحل الإنتاج', () => context.push('/orders/${order.id}/production')),
              _buildActionCard(context, Icons.local_shipping_outlined, 'تتبع الشحنة', () => context.push('/orders/${order.id}/shipment')),
              _buildActionCard(context, Icons.chat_bubble_outline_rounded, 'محادثة المورد', () => context.push('/chat/1')),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'تحميل الفاتورة الرسمية PDF',
                  icon: Icons.download_rounded,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم البدء في تحميل الفاتورة.')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryButton(
                  label: 'تأكيد الاستلام والاعتماد',
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: () => context.push('/orders/${order.id}/delivery-receipt'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.rMD,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: AppRadius.rMD,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class DeliveryInformationWidget extends StatelessWidget {
  final OrderModel order;

  const DeliveryInformationWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InformationCard(
      title: 'بيانات التسليم والشحن',
      items: [
        {'label': 'شركة الشحن والناقل', 'value': order.shippingCompany},
        {'label': 'رقم بوليصة الشحن', 'value': order.trackingNumber},
        {'label': 'عنوان التوصيل المعتمد', 'value': order.address},
        {'label': 'تاريخ الوصول المتوقع', 'value': order.expectedDeliveryDate},
      ],
    );
  }
}

class PaymentInformationWidget extends StatelessWidget {
  final OrderModel order;

  const PaymentInformationWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InformationCard(
      title: 'بيانات الدفع والتمويل',
      items: [
        {'label': 'طريقة الدفع المعتمدة', 'value': order.paymentMethod},
        {'label': 'الحالة المالية للطلب', 'value': 'مستحقة / تم سداد الدفعة الأولى 30%'},
        {'label': 'المستحقات المتبقية', 'value': '${(order.finalPrice * 0.7).toInt()} ج.م'},
      ],
    );
  }
}

class SupplierInformationWidget extends StatelessWidget {
  final OrderModel order;

  const SupplierInformationWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return SupplierCard(
      supplierName: order.supplierName,
      rfqId: order.rfqId,
      onChatTap: () => context.push('/chat/1'),
    );
  }
}


