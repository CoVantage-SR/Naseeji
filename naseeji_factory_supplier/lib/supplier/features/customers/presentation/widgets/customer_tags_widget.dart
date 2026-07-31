// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/customer_model.dart';

class CustomerTagsWidget extends StatelessWidget {
  final List<CustomerTag> tags;
  final bool allowEdit;
  final VoidCallback? onAddTag;
  final void Function(String tagId)? onRemoveTag;

  const CustomerTagsWidget({
    super.key,
    required this.tags,
    this.allowEdit = false,
    this.onAddTag,
    this.onRemoveTag,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        ...tags.map((tag) => _buildTag(tag)),
        if (allowEdit)
          GestureDetector(
            onTap: onAddTag,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 12, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text('إضافة', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTag(CustomerTag tag) {
    final color = Color(tag.colorValue);
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, allowEdit ? 4 : 10, 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tag.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
          if (allowEdit) ...[
            SizedBox(width: 4),
            GestureDetector(
              onTap: () => onRemoveTag?.call(tag.id),
              child: Icon(Icons.close, size: 12, color: color),
            ),
          ],
        ],
      ),
    );
  }
}



