import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_file_model.dart';

class FilesTabWidget extends StatefulWidget {
  final List<DealFileModel> files;

  const FilesTabWidget({super.key, required this.files});

  @override
  State<FilesTabWidget> createState() => _FilesTabWidgetState();
}

class _FilesTabWidgetState extends State<FilesTabWidget> {
  String _searchQuery = '';
  DealFileType? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final filteredFiles = widget.files.where((file) {
      final matchesSearch = file.fileName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedFilter == null || file.fileType == _selectedFilter;
      return matchesSearch && matchesType;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
          child: Column(
            children: [
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'البحث في ملفات ومستندات الصفقة...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
              const SizedBox(height: 8),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('الكل', null),
                    const SizedBox(width: 6),
                    _buildFilterChip('كتالوجات', DealFileType.catalog),
                    const SizedBox(width: 6),
                    _buildFilterChip('PDF', DealFileType.pdf),
                    const SizedBox(width: 6),
                    _buildFilterChip('شهادات ISO', DealFileType.qualityCert),
                    const SizedBox(width: 6),
                    _buildFilterChip('صور وفيديوهات', DealFileType.image),
                  ],
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: filteredFiles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_off_outlined, size: 48, color: colorScheme.outline),
                      const SizedBox(height: 8),
                      Text('لا توجد ملفات مطابقة في الصفقة', style: TextStyle(color: colorScheme.outline)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  itemCount: filteredFiles.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final file = filteredFiles[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        children: [
                          _buildFileIcon(file.fileType),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  file.fileName,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${file.typeArabicLabel} • ${file.fileSize}',
                                  style: TextStyle(fontSize: 11, color: colorScheme.outline),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.download_rounded, color: colorScheme.primary),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('جاري تحميل: ${file.fileName}')),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, DealFileType? type) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedFilter == type;

    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedFilter = type),
      selectedColor: colorScheme.primary,
      labelStyle: TextStyle(color: isSelected ? Colors.white : colorScheme.onSurface),
    );
  }

  Widget _buildFileIcon(DealFileType type) {
    IconData icon;
    Color color;

    switch (type) {
      case DealFileType.catalog:
        icon = Icons.menu_book_rounded;
        color = Colors.blue;
        break;
      case DealFileType.pdf:
        icon = Icons.picture_as_pdf_rounded;
        color = Colors.red;
        break;
      case DealFileType.qualityCert:
        icon = Icons.verified_rounded;
        color = Colors.green;
        break;
      case DealFileType.image:
        icon = Icons.image_rounded;
        color = Colors.orange;
        break;
      case DealFileType.video:
        icon = Icons.play_circle_fill_rounded;
        color = Colors.purple;
        break;
      case DealFileType.document:
        icon = Icons.description_rounded;
        color = Colors.teal;
        break;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withValues(alpha: 0.1),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

