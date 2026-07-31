import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'orders_reusable_widgets.dart';

class GalleryHeaderWidget extends StatelessWidget {
  final String orderId;

  const GalleryHeaderWidget({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'معرض صور خط الإنتاج للطلب: $orderId',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        const Text(
          'تابع صور خط الإنتاج والتعبئة والفرز المرسلة من قبل المورد للتحقق من الجودة والمواصفات.',
          style: TextStyle(color: Colors.grey, fontSize: 10),
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}

class GalleryTabsWidget extends StatelessWidget {
  final TabController tabController;
  final List<String> tabs;

  const GalleryTabsWidget({
    super.key,
    required this.tabController,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: AppColors.primary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.primary,
      tabs: tabs.map((t) => Tab(text: t)).toList(),
    );
  }
}

class ImageGridWidget extends StatelessWidget {
  final List<Map<String, String>> images;
  final ValueChanged<Map<String, String>> onImageTap;

  const ImageGridWidget({
    super.key,
    required this.images,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Text('لا توجد صور مرفوعة في هذه المرحلة بعد.'),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final img = images[index];
        return ImageCard(
          imageUrl: img['url'] ?? '',
          description: img['desc'] ?? '',
          uploadDate: img['date'] ?? '',
          onTap: () => onImageTap(img),
        );
      },
    );
  }
}

class ImagePreviewWidget extends StatelessWidget {
  final Map<String, String> image;

  const ImagePreviewWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              image['desc'] ?? 'معاينة الصورة',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          Expanded(
            child: InteractiveViewer(
              child: Image.network(
                image['url'] ?? '',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'تاريخ الرفع: ${image['date'] ?? ''}',
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

