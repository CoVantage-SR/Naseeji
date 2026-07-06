import 'package:flutter/material.dart';

class EditProfileCategoriesSection extends StatefulWidget {
  final List<String> selectedCategories;
  final ValueChanged<List<String>> onCategoriesChanged;

  const EditProfileCategoriesSection({
    super.key,
    required this.selectedCategories,
    required this.onCategoriesChanged,
  });

  @override
  State<EditProfileCategoriesSection> createState() => _EditProfileCategoriesSectionState();
}

class _EditProfileCategoriesSectionState extends State<EditProfileCategoriesSection> {
  final TextEditingController _categorySearchController = TextEditingController();

  final List<String> _availableCategories = const [
    'Cotton Supplier',
    'Fabric Supplier',
    'Accessories Supplier',
    'Filling Materials Supplier',
    'Packaging Supplier',
    'Printing Supplier',
    'Machinery Supplier',
    'Bags & Cartons Supplier',
    'Yarn Supplier',
    'Dyeing Supplier',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _categorySearchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _categorySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _availableCategories.where((cat) {
      final query = _categorySearchController.text.toLowerCase();
      return cat.toLowerCase().contains(query);
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('تصنيفات التوريد ومجموعات المنتجات *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Text('يرجى اختيار مجموعة تصنيفات تصف مجالات التوريد الخاصة بك.', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          const SizedBox(height: 12),
          // Category Search Field
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              controller: _categorySearchController,
              decoration: InputDecoration(
                hintText: 'البحث عن تصنيف تخصصي...',
                hintStyle: const TextStyle(fontSize: 11),
                prefixIcon: const Icon(Icons.search, size: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Grid/List of categories filtered
          Container(
            maxHeight: 120,
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final cat = filteredCategories[index];
                final isSelected = widget.selectedCategories.contains(cat);
                return CheckboxListTile(
                  title: Text(cat, style: const TextStyle(fontSize: 11)),
                  value: isSelected,
                  controlAffinity: ListTileControlAffinity.trailing,
                  dense: true,
                  onChanged: (val) {
                    final updatedList = List<String>.from(widget.selectedCategories);
                    if (val == true) {
                      if (!updatedList.contains(cat)) {
                        updatedList.add(cat);
                      }
                    } else {
                      updatedList.remove(cat);
                    }
                    widget.onCategoriesChanged(updatedList);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Renders selected categories as Chips
          if (widget.selectedCategories.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: WrapAlignment.end,
              children: widget.selectedCategories.map((cat) => Chip(
                label: Text(cat, style: const TextStyle(fontSize: 9, color: Color(0xFF0040E0))),
                backgroundColor: const Color(0xFFF1F4FE),
                deleteIcon: const Icon(Icons.close, size: 10, color: Color(0xFF0040E0)),
                onDeleted: () {
                  final updatedList = List<String>.from(widget.selectedCategories);
                  updatedList.remove(cat);
                  widget.onCategoriesChanged(updatedList);
                },
              )).toList(),
            ),
        ],
      ),
    );
  }
}
