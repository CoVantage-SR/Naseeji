import 'package:flutter/material.dart';
import 'package:naseeji_factory/factory/core/extensions/context_extensions.dart';

class RecentSearchesWidget extends StatelessWidget {
  final List<String> recentQueries;
  final Function(String) onRemove;
  final Function(String) onTap;

  const RecentSearchesWidget({
    super.key,
    required this.recentQueries,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (recentQueries.isEmpty) return const SizedBox.shrink();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'البحث الأخير في الكتالوج',
              style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentQueries.length,
            itemBuilder: (context, index) {
              final query = recentQueries[index];
              return ListTile(
                leading: const Icon(Icons.history_rounded, color: Colors.grey),
                title: Text(query),
                trailing: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () => onRemove(query),
                ),
                onTap: () => onTap(query),
              );
            },
          ),
        ],
      ),
    );
  }
}

