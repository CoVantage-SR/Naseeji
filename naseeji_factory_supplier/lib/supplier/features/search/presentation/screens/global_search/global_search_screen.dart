import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import 'widgets/recent_searches_section.dart';
import 'widgets/search_factory_card.dart';
import 'widgets/search_filter_chips.dart';
import 'widgets/search_product_card.dart';
import 'widgets/search_text_field.dart';

class GlobalSearchScreen extends ConsumerWidget {
  const GlobalSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Naseeji',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_forward, color: AppColors.onSurfaceVariant),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
            onPressed: () {},
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Custom Search Input Box
            const SearchTextField(),
            SizedBox(height: 16),

            // Horizontal Filter Chips
            const SearchFilterChips(),
            SizedBox(height: 24),

            // Recent Searches History
            const RecentSearchesSection(),
            SizedBox(height: 28),

            // Products Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0040E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '12 نتيجة',
                    style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'المنتجات',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0040E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Product Cards List
            const SearchProductCard(
              title: 'حرير طبيعي 100%',
              imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&q=80&w=600',
              productCode: 'كود المنتج: SILK-990-TX',
              statusText: 'متوفر',
              statusColor: Color(0xFF009688),
              statusBgColor: Color(0xFFE0F2F1),
            ),
            const SearchProductCard(
              title: 'دنيم صناعي ثقيل',
              imageUrl: 'https://images.unsplash.com/photo-1558591710-4b4a1ae0f04d?auto=format&fit=crop&q=80&w=600',
              productCode: 'كود المنتج: DNM-442-HD',
              statusText: 'مخزون منخفض',
              statusColor: Color(0xFFBA1A1A),
              statusBgColor: Color(0xFFFFECEC),
            ),
            SizedBox(height: 12),

            // Factories Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF009688),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '4 نتائج',
                    style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'المصانع',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFF009688),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Factory Cards
            const SearchFactoryCard(
              title: 'مجموعة الغزل الحديثة',
              subtitle: 'مورد معتمد • جدة، المملكة العربية السعودية',
              logoText: 'AURA\nTEXTILES',
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

