import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/orders_provider.dart';
import 'orders_reusable_widgets.dart';

class ShipmentInformationWidget extends StatelessWidget {
  final OrderModel order;

  const ShipmentInformationWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InformationCard(
      title: 'بيانات وإحصاءات الطرود المشحونة',
      items: [
        {'label': 'نوع الشحنة والطرود', 'value': 'بكر غزل قطني ممشط مغلف'},
        {'label': 'إجمالي عدد الطرود', 'value': '٧٥ كرتونة حماية خشبية'},
        {'label': 'الوزن القائم الفعلي', 'value': '٣.٥ طن متري'},
        {'label': 'طريقة التعبئة والفرز', 'value': 'حماية حرارية مقاومة للرطوبة'},
      ],
    );
  }
}

class CarrierInformationWidget extends StatelessWidget {
  final OrderModel order;

  const CarrierInformationWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InformationCard(
      title: 'بيانات الناقل وسائق سيارة النقل',
      items: [
        {'label': 'شركة النقل المعتمدة', 'value': order.shippingCompany},
        {'label': 'نوع وسيلة التوصيل', 'value': 'مقطورة شحن متوسطة مغلقة'},
        {'label': 'اسم سائق مقطورة النقل', 'value': 'الأستاذ عماد الدين محمود'},
        {'label': 'رقم الهاتف المحمول', 'value': '+٢٠ ١٠١ ٢٣٤ ٥٦٧٨'},
        {'label': 'لوحات ترخيص المقطورة', 'value': '٩٩٣١ س ر ج م'},
      ],
    );
  }
}

class ShipmentDocumentsWidget extends StatelessWidget {
  final VoidCallback onDownload;

  const ShipmentDocumentsWidget({super.key, required this.onDownload});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'مستندات وأوراق الشحن الرسمية',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          AttachmentCard(
            fileName: 'بوليصة_الشحن_الرسمية_الموقعة.pdf',
            onTap: onDownload,
          ),
          const SizedBox(height: 8),
          AttachmentCard(
            fileName: 'شهادة_المنشأ_ومطابقة_الجودة.pdf',
            onTap: onDownload,
          ),
          const SizedBox(height: 8),
          AttachmentCard(
            fileName: 'قائمة_التعبئة_والأوزان_التفصيلية.xlsx',
            onTap: onDownload,
          ),
        ],
      ),
    );
  }
}

class ShipmentImagesWidget extends StatelessWidget {
  const ShipmentImagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final images = [
      'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d',
      'https://images.unsplash.com/photo-1578575437130-527eed3abbec',
    ];

    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'صور توثيق التحميل ومطابقة الأوزان',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: AppRadius.rMD,
                  child: Image.network(
                    images[index],
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TrackingInformationWidget extends StatelessWidget {
  final OrderModel order;

  const TrackingInformationWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InformationCard(
      title: 'بوابة تتبع الشحنة الرقمية',
      items: [
        {'label': 'حالة تتبع البوليصة', 'value': order.carrierStatus},
        {'label': 'رقم التتبع الموحد', 'value': order.trackingNumber},
        {'label': 'آخر نقطة عبور مسجلة', 'value': order.currentLocation},
      ],
    );
  }
}


