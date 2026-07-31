import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/search_item.dart';
import '../../domain/repositories/search_repository.dart';

part 'search_repository_impl.g.dart';

class SearchRepositoryImpl implements SearchRepository {
  final List<SearchItem> _mockItems = const [
    SearchItem(
      id: '1',
      title: 'خيوط قطن غزل 100%',
      description: 'خيوط قطن ممشط فائقة الجودة للمصانع الدائرية والنسيج.',
      category: 'خيوط',
      price: 4.5,
      imageUrl: 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=150&q=80',
    ),
    SearchItem(
      id: '2',
      title: 'قماش كتان مصري فاخر',
      description: 'كتان طبيعي 100% مناسب للملابس الصيفية والمنسوجات المنزلية.',
      category: 'أقمشة كتان',
      price: 12.0,
      imageUrl: 'https://images.unsplash.com/photo-1606744824163-985d376605aa?auto=format&fit=crop&w=150&q=80',
    ),
    SearchItem(
      id: '3',
      title: 'قماش حرير صناعي',
      description: 'حرير ناعم ومقاوم للتجاعيد للتصاميم الفاخرة.',
      category: 'أقمشة حرير',
      price: 18.5,
      imageUrl: 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?auto=format&fit=crop&w=150&q=80',
    ),
    SearchItem(
      id: '4',
      title: 'صوف إنجليزي ثقيل',
      description: 'صوف طبيعي 100% للشتاء والأزياء الراقية.',
      category: 'أقمشة صوف',
      price: 25.0,
      imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=150&q=80',
    ),
  ];

  @override
  Future<List<SearchItem>> searchItems(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (query.trim().isEmpty) return _mockItems;
    return _mockItems
        .where((item) =>
            item.title.contains(query) ||
            item.description.contains(query) ||
            item.category.contains(query))
        .toList();
  }
}

@riverpod
SearchRepository searchRepository(SearchRepositoryRef ref) {
  return SearchRepositoryImpl();
}

