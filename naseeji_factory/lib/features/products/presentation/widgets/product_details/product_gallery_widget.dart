import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_radius.dart';
import '../../providers/products_provider.dart';

/// Product image gallery matching reference design exactly:
/// - Main square rounded image with 1/6 indicator badge (bottom left) and zoom icon button (bottom right)
/// - Thumbnail selector row below main image (5 visible, 1st selected with primary border, 5th with '+2' overlay)
/// - Fullscreen interactive zoom & gallery viewer modal
class ProductGalleryWidget extends StatefulWidget {
  final Product product;

  const ProductGalleryWidget({super.key, required this.product});

  @override
  State<ProductGalleryWidget> createState() => _ProductGalleryWidgetState();
}

class _ProductGalleryWidgetState extends State<ProductGalleryWidget> {
  int _selectedIndex = 0;

  List<String> get _images {
    if (widget.product.galleryImages.isNotEmpty) {
      return widget.product.galleryImages;
    }
    return [
      widget.product.imageUrl,
      widget.product.imageUrl,
      widget.product.imageUrl,
      widget.product.imageUrl,
      widget.product.imageUrl,
      widget.product.imageUrl,
    ];
  }

  void _openFullscreenGallery(BuildContext context, int initialIndex) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) => FullscreenGalleryDialog(
        images: _images,
        initialIndex: initialIndex,
        productName: widget.product.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = _images;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Image Container
        GestureDetector(
          onTap: () => _openFullscreenGallery(context, _selectedIndex),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: ClipRRect(
                  borderRadius: AppRadius.rMD,
                  child: Container(
                    color: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                    child: Image.network(
                      images[_selectedIndex % images.length],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: isDark ? AppColors.borderDark : Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Page Count Badge (Bottom Left)
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_selectedIndex + 1}/${images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Zoom Icon Button (Bottom Right)
              Positioned(
                bottom: 12,
                right: 12,
                child: Material(
                  color: Colors.black.withValues(alpha: 0.65),
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _openFullscreenGallery(context, _selectedIndex),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Thumbnails Row
        SizedBox(
          height: 60,
          child: Row(
            children: List.generate(
              5,
              (index) {
                final isSelected = _selectedIndex == index;
                final isLastItem = index == 4 && images.length > 5;
                final remainingCount = images.length - 4;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: GestureDetector(
                      onTap: () {
                        if (isLastItem) {
                          _openFullscreenGallery(context, index);
                        } else {
                          setState(() => _selectedIndex = index);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: AppRadius.rSM,
                          border: Border.all(
                            color: isSelected ? primaryColor : Colors.transparent,
                            width: isSelected ? 2.5 : 0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(isSelected ? 6 : 8),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                images[index % images.length],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              if (isLastItem)
                                Container(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '+$remainingCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Fullscreen Interactive Image Gallery Dialog with Pinch Zoom, PageView and Thumbnails
class FullscreenGalleryDialog extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String productName;

  const FullscreenGalleryDialog({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.productName,
  });

  @override
  State<FullscreenGalleryDialog> createState() => _FullscreenGalleryDialogState();
}

class _FullscreenGalleryDialogState extends State<FullscreenGalleryDialog> {
  late PageController _pageController;
  late int _currentIndex;
  final TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_currentIndex + 1} / ${widget.images.length}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (idx) {
                  setState(() => _currentIndex = idx);
                  _transformationController.value = Matrix4.identity();
                },
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: Center(
                      child: Image.network(
                        widget.images[index],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.image_not_supported_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom Thumbnails Bar
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.black.withValues(alpha: 0.8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  final isSelected = _currentIndex == index;
                  return GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 54,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          widget.images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
