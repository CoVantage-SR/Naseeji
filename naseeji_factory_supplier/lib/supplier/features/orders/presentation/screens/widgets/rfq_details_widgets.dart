import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../../domain/entities/rfq_details.dart';

class RfqDetailCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const RfqDetailCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
            ],
          ),
          SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class RfqDetailInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const RfqDetailInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.outline,
          ),
        ),
      ],
    );
  }
}

class FactoryInfoCard extends StatelessWidget {
  final RfqDetails details;

  const FactoryInfoCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return RfqDetailCard(
      icon: Icons.storefront_outlined,
      iconColor: const Color(0xFF0040E0),
      title: 'معلومات المصنع',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            details.companyName,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 12),
          RfqDetailInfoRow(label: 'مسؤول التواصل', value: details.contactPerson),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  details.status,
                  style: TextStyle(
                    color: Color(0xFF16A34A),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                ':الحالة',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RequestedProductCard extends StatelessWidget {
  final RfqDetails details;

  const RequestedProductCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return RfqDetailCard(
      icon: Icons.shopping_bag_outlined,
      iconColor: const Color(0xFF0040E0),
      title: 'المنتج المطلوب',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الكمية المطلوبة',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.outline,
                ),
              ),
              SizedBox(height: 4),
              Text(
                details.quantity,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0040E0),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'نوع القماش',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.outline,
                ),
              ),
              SizedBox(height: 4),
              Text(
                details.fabricType,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TechnicalSpecsCard extends StatelessWidget {
  final RfqDetails details;

  const TechnicalSpecsCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return RfqDetailCard(
      icon: Icons.tune,
      iconColor: const Color(0xFF006B5F),
      title: 'المواصفات الفنية',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    details.color,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 6),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(0xFF0D1B2A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'اللون:',
                style: TextStyle(fontSize: 11, color: AppColors.outline),
              ),
            ],
          ),
          SizedBox(height: 10),
          RfqDetailInfoRow(label: 'الوزن', value: details.weight),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F9F5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  details.quality,
                  style: TextStyle(
                    color: Color(0xFF006B5F),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'الجودة:',
                style: TextStyle(fontSize: 11, color: AppColors.outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PackagingShippingCard extends StatelessWidget {
  final RfqDetails details;

  const PackagingShippingCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return RfqDetailCard(
      icon: Icons.local_shipping_outlined,
      iconColor: const Color(0xFF993100),
      title: 'التعبئة والتغليف والشحن',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RfqDetailInfoRow(label: 'طريقة التغليف', value: details.packagingMethod),
          SizedBox(height: 10),
          RfqDetailInfoRow(label: 'وجهة التسليم', value: details.deliveryDestination),
        ],
      ),
    );
  }
}

class FactoryNotesCard extends StatelessWidget {
  final RfqDetails details;

  const FactoryNotesCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return RfqDetailCard(
      icon: Icons.description_outlined,
      iconColor: const Color(0xFF0040E0),
      title: 'ملاحظات المصنع',
      child: Text(
        details.notes,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
        textAlign: TextAlign.end,
      ),
    );
  }
}

class AttachmentsSection extends StatelessWidget {
  const AttachmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return RfqDetailCard(
      icon: Icons.attachment_outlined,
      iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
      title: 'المرفقات (3)',
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: [
          _buildAttachmentImage('https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=150&q=80'),
          _buildAttachmentImage('https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=150&q=80'),
          _buildAttachmentPdf('المواصفات.pdf'),
          _buildAttachmentUploadButton(),
        ],
      ),
    );
  }

  Widget _buildAttachmentImage(String url) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAttachmentPdf(String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.picture_as_pdf, color: AppColors.error, size: 32),
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentUploadButton() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E1EF), width: 1, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(Icons.add, color: AppColors.outline, size: 24),
      ),
    );
  }
}

class RfqDetailsBottomBar extends StatelessWidget {
  final String rfqId;

  const RfqDetailsBottomBar({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE2E1EF), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: AppColors.error),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/orders/order-center?rfqId=$rfqId');
                  }
                },
              ),
            ),
            SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE2E1EF), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(Icons.handshake_outlined, color: AppColors.onSurfaceVariant),
                onPressed: () {},
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => context.push('/orders/create-quotation?rfqId=$rfqId'),
                icon: const Icon(Icons.send, size: 16, color: Colors.white),
                label: Text(
                  'إرسال عرض سعر',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0040E0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(0, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

