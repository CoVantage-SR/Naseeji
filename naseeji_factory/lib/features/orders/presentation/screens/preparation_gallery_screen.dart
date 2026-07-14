import 'package:flutter/material.dart';
import '../widgets/preparation_gallery_widgets.dart';

class PreparationGalleryScreen extends StatefulWidget {
  final String orderId;

  const PreparationGalleryScreen({super.key, required this.orderId});

  @override
  State<PreparationGalleryScreen> createState() => _PreparationGalleryScreenState();
}

class _PreparationGalleryScreenState extends State<PreparationGalleryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _stages = const [
    'قبل الإنتاج',
    'أثناء الإنتاج',
    'بعد الإنتاج',
    'التغليف والشحن',
  ];

  final List<Map<String, String>> _mockImages = [
    {
      'url': 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17',
      'desc': 'فحص بالات القطن الموردة',
      'date': '2026/07/02',
      'stage': 'قبل الإنتاج',
    },
    {
      'url': 'https://images.unsplash.com/photo-1544816155-12df9643f363',
      'desc': 'غزل الألياف وتعديل السرعة',
      'date': '2026/07/06',
      'stage': 'أثناء الإنتاج',
    },
    {
      'url': 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a',
      'desc': 'مراجعة خيوط البكر المكتملة',
      'date': '2026/07/11',
      'stage': 'بعد الإنتاج',
    },
    {
      'url': 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d',
      'desc': 'تغليف الكراتين بالبلاستيك الحراري',
      'date': '2026/07/12',
      'stage': 'التغليف والشحن',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _stages.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showPreview(Map<String, String> img) {
    showDialog(
      context: context,
      builder: (context) => ImagePreviewWidget(image: img),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeStage = _stages[_tabController.index];
    final filtered = _mockImages.where((i) => i['stage'] == activeStage).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('معرض صور التحضير والإنتاج'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GalleryHeaderWidget(orderId: widget.orderId),
            ),
            GalleryTabsWidget(
              tabController: _tabController,
              tabs: _stages,
            ),
            const Divider(height: 1),
            Expanded(
              child: ImageGridWidget(
                images: filtered,
                onImageTap: _showPreview,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
