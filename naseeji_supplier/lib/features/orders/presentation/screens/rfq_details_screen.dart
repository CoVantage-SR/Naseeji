import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/rfq_details_controller.dart';

class RfqDetailsScreen extends ConsumerWidget {
  final String rfqId;

  const RfqDetailsScreen({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(rfqDetailsControllerProvider(rfqId));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              'تفاصيل طلب السعر',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'RFQ #$rfqId',
              style: const TextStyle(
                color: AppColors.outline,
                fontSize: 10,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.onSurfaceVariant,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.onSurfaceVariant),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: detailsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (details) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Factory Info Card
                      _buildCard(
                        icon: Icons.storefront_outlined,
                        iconColor: const Color(0xFF0040E0),
                        title: 'معلومات المصنع',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              details.companyName,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow('مسؤول التواصل', details.contactPerson),
                            const SizedBox(height: 8),
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
                                    style: const TextStyle(
                                      color: Color(0xFF16A34A),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
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
                      ),
                      const SizedBox(height: 16),

                      // Requested Product Card
                      _buildCard(
                        icon: Icons.shopping_bag_outlined,
                        iconColor: const Color(0xFF0040E0),
                        title: 'المنتج المطلوب',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Quantity
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'الكمية المطلوبة',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.outline,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  details.quantity,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0040E0),
                                  ),
                                ),
                              ],
                            ),
                            // Fabric type
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'نوع القماش',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.outline,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  details.fabricType,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Technical Specs Card
                      _buildCard(
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
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF0D1B2A),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Text(
                                  'اللون:',
                                  style: TextStyle(fontSize: 11, color: AppColors.outline),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _buildInfoRow('الوزن', details.weight),
                            const SizedBox(height: 10),
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
                                    style: const TextStyle(
                                      color: Color(0xFF006B5F),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                const Text(
                                  'الجودة:',
                                  style: TextStyle(fontSize: 11, color: AppColors.outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Packaging & Shipping Card
                      _buildCard(
                        icon: Icons.local_shipping_outlined,
                        iconColor: const Color(0xFF993100),
                        title: 'التعبئة والتغليف والشحن',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildInfoRow('طريقة التغليف', details.packagingMethod),
                            const SizedBox(height: 10),
                            _buildInfoRow('وجهة التسليم', details.deliveryDestination),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Factory Notes Card
                      _buildCard(
                        icon: Icons.description_outlined,
                        iconColor: const Color(0xFF0040E0),
                        title: 'ملاحظات المصنع',
                        child: Text(
                          details.notes,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Attachments Card
                      _buildCard(
                        icon: Icons.attachment_outlined,
                        iconColor: AppColors.onSurfaceVariant,
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
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: SafeArea(
                  child: Row(
                    children: [
                      // X Close Button
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE2E1EF), width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: AppColors.error),
                          onPressed: () => context.pop(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Negotiate Button
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE2E1EF), width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.handshake_outlined, color: AppColors.onSurfaceVariant),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Submit Offer Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('/create-offer?rfqId=${details.rfqId}'),
                          icon: const Icon(Icons.send, size: 16, color: Colors.white),
                          label: const Text(
                            'إرسال عرض سعر',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0040E0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(width: 8),
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
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
            textAlign: TextAlign.end,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.outline,
          ),
        ),
      ],
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
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
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
      child: const Center(
        child: Icon(Icons.add, color: AppColors.outline, size: 24),
      ),
    );
  }
}
