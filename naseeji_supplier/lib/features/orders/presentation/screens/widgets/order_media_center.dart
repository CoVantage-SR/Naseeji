import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class MediaItem {
  final String name;
  final String category; // Images, Videos, PDF, Invoices, Shipping Documents, Quality Reports, Certificates
  final String url;
  final String date;
  final String size;

  const MediaItem({
    required this.name,
    required this.category,
    required this.url,
    required this.date,
    required this.size,
  });
}

class OrderMediaCenter extends StatefulWidget {
  final String rfqId;

  const OrderMediaCenter({super.key, required this.rfqId});

  @override
  State<OrderMediaCenter> createState() => _OrderMediaCenterState();
}

class _OrderMediaCenterState extends State<OrderMediaCenter> {
  String selectedCategory = 'الكل';
  String searchQuery = '';
  bool isGridView = true;
  String selectedSort = 'الأحدث';

  final List<MediaItem> mockFiles = const [
    MediaItem(
      name: 'تصميم_عينة_القطن_الأزرق.jpg',
      category: 'Images',
      url: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=350&q=80',
      date: '2026-07-06',
      size: '1.4 MB',
    ),
    MediaItem(
      name: 'فيديو_فحص_النسيج.mp4',
      category: 'Videos',
      url: 'https://assets.mixkit.co/videos/preview/mixkit-spinning-thread-at-weaving-loom-41804-large.mp4',
      date: '2026-07-05',
      size: '8.2 MB',
    ),
    MediaItem(
      name: 'فاتورة_شحن_أرامكس_المعتمدة.pdf',
      category: 'Invoices',
      url: 'https://pdfobject.com/pdf/sample.pdf',
      date: '2026-07-05',
      size: '2.5 MB',
    ),
    MediaItem(
      name: 'تقرير_ضمان_جودة_خيوط_القطن.pdf',
      category: 'Quality Reports',
      url: 'https://pdfobject.com/pdf/sample.pdf',
      date: '2026-07-04',
      size: '950 KB',
    ),
    MediaItem(
      name: 'شهادة_المنشأ_الأصلي_ISO.pdf',
      category: 'Certificates',
      url: 'https://pdfobject.com/pdf/sample.pdf',
      date: '2026-07-03',
      size: '3.1 MB',
    ),
    MediaItem(
      name: 'بيان_شحنة_أ ب ج 1234.pdf',
      category: 'Shipping Documents',
      url: 'https://pdfobject.com/pdf/sample.pdf',
      date: '2026-07-05',
      size: '720 KB',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var filtered = mockFiles.where((item) {
      final matchesCategory = selectedCategory == 'الكل' || item.category == selectedCategory;
      final matchesSearch = item.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    if (selectedSort == 'الأحدث') {
      filtered.sort((a, b) => b.date.compareTo(a.date));
    } else {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search & Controls Bar
        _buildControlsBar(),
        const SizedBox(height: 12),

        // Categories selector
        _buildCategoriesSelector(),
        const SizedBox(height: 12),

        // Items View
        Expanded(
          child: filtered.isEmpty
              ? _buildEmptyState()
              : isGridView
                  ? _buildGridView(filtered)
                  : _buildListView(filtered),
        ),
      ],
    );
  }

  Widget _buildControlsBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view, color: const Color(0xFF0040E0)),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E1EF)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<String>(
              value: selectedSort,
              underline: const SizedBox(),
              style: const TextStyle(fontSize: 11, color: AppColors.onSurface, fontWeight: FontWeight.bold),
              items: const [
                DropdownMenuItem(value: 'الأحدث', child: Text('الأحدث')),
                DropdownMenuItem(value: 'الاسم', child: Text('الاسم')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedSort = val;
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  style: const TextStyle(fontSize: 12),
                  onChanged: (val) {
                    setState(() {
                      searchQuery = val;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'ابحث عن ملف...',
                    hintStyle: TextStyle(fontSize: 11, color: AppColors.outline),
                    prefixIcon: Icon(Icons.search, size: 16, color: AppColors.outline),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSelector() {
    final categories = {
      'الكل': 'الكل',
      'Images': 'الصور',
      'Videos': 'الفيديو',
      'PDF': 'ملفات PDF',
      'Invoices': 'الفواتير',
      'Shipping Documents': 'أوراق الشحن',
      'Quality Reports': 'تقارير الجودة',
      'Certificates': 'الشهادات',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: categories.entries.map((entry) {
          final isSelected = selectedCategory == entry.key;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(entry.value, style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : AppColors.onSurfaceVariant)),
              selected: isSelected,
              selectedColor: const Color(0xFF0040E0),
              backgroundColor: Colors.white,
              onSelected: (val) {
                if (val) {
                  setState(() {
                    selectedCategory = entry.key;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGridView(List<MediaItem> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => _previewFile(item),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E1EF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: item.category == 'Images'
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                            image: DecorationImage(image: NetworkImage(item.url), fit: BoxFit.cover),
                          ),
                        )
                      : Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Icon(_getCategoryIcon(item.category), color: const Color(0xFF0040E0), size: 36),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(item.name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.size, style: const TextStyle(fontSize: 8, color: AppColors.outline)),
                          Text(item.date, style: const TextStyle(fontSize: 8, color: AppColors.outline)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(List<MediaItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFE2E1EF)),
          ),
          color: Colors.white,
          child: ListTile(
            onTap: () => _previewFile(item),
            title: Text(item.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
            subtitle: Text('${item.category} • ${item.size} • ${item.date}', style: const TextStyle(fontSize: 9, color: AppColors.outline), textAlign: TextAlign.end),
            leading: IconButton(
              icon: const Icon(Icons.download_rounded, color: Color(0xFF0040E0), size: 18),
              onPressed: () {},
            ),
            trailing: Icon(_getCategoryIcon(item.category), color: const Color(0xFF0040E0), size: 22),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 48, color: AppColors.outline),
          SizedBox(height: 12),
          Text('لا توجد ملفات متوفرة تطابق التصفية الحالية', style: TextStyle(fontSize: 12, color: AppColors.outline)),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    if (category == 'Images') return Icons.image_outlined;
    if (category == 'Videos') return Icons.videocam_outlined;
    if (category == 'Invoices') return Icons.receipt_long_outlined;
    if (category == 'Shipping Documents') return Icons.local_shipping_outlined;
    if (category == 'Quality Reports') return Icons.verified_outlined;
    if (category == 'Certificates') return Icons.card_membership_outlined;
    return Icons.description_outlined;
  }

  void _previewFile(MediaItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(item.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        content: item.category == 'Images'
            ? Image.network(item.url)
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getCategoryIcon(item.category), color: const Color(0xFF0040E0), size: 56),
                  const SizedBox(height: 16),
                  Text('حجم الملف: ${item.size}', style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 8),
                  const Text('معاينة مستندات PDF والميديا الأخرى قيد التحميل...', style: TextStyle(fontSize: 10, color: AppColors.outline), textAlign: TextAlign.center),
                ],
              ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.download, size: 16, color: Colors.white),
            label: const Text('تحميل الملف'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0040E0), foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}
