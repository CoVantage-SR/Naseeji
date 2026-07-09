import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/business_message.dart';
import '../controllers/business_chat_controller.dart';

class SearchMessagesScreen extends ConsumerStatefulWidget {
  final String? conversationId;
  const SearchMessagesScreen({super.key, this.conversationId});

  @override
  ConsumerState<SearchMessagesScreen> createState() => _SearchMessagesScreenState();
}

class _SearchMessagesScreenState extends ConsumerState<SearchMessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'الكل';
  final List<String> _recentSearches = ['RFQ-8820', 'قطن', 'عرض سعر', '2026-07-06'];

  static const List<String> _filters = [
    'الكل',
    'نصوص',
    'تاريخ',
    'ملفات',
    'صور',
    'فيديو',
    'عروض أسعار',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final targetConvId = widget.conversationId ?? 'conv_001';
    final messagesAsync = ref.watch(businessChatControllerProvider(targetConvId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          textAlign: TextAlign.right,
          onChanged: (v) => setState(() => _searchQuery = v),
          style: TextStyle(fontSize: 15),
          decoration: const InputDecoration(
            hintText: 'بحث في المحادثة...',
            hintStyle: TextStyle(fontSize: 14, color: AppColors.outline),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        actions: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: AppColors.outline),
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final isSelected = _selectedFilter == f;
                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: FilterChip(
                      label: Text(f, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface)),
                      selected: isSelected,
                      onSelected: (_) async {
                        setState(() => _selectedFilter = f);
                        if (f == 'تاريخ') {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppColors.primary,
                                    onPrimary: Colors.white,
                                    onSurface: AppColors.onSurface,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null && mounted) {
                            // Format as YYYY-MM-DD or match Arabic dates (mock search matching)
                            // We can search for this date string
                            final dateStr = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                            setState(() {
                              _searchQuery = dateStr;
                              _searchController.text = dateStr;
                            });
                          }
                        }
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
                      showCheckmark: false,
                      side: BorderSide.none,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 1),
          // Body
          Expanded(
            child: _searchQuery.isEmpty
                ? _RecentSearches(
                    searches: _recentSearches,
                    onTap: (q) {
                      _searchController.text = q;
                      setState(() => _searchQuery = q);
                    },
                    onRemove: (q) => setState(() => _recentSearches.remove(q)),
                  )
                : messagesAsync.when(
                    loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    error: (e, _) => Center(child: Text('خطأ: $e')),
                    data: (messages) {
                      final results = messages.where((m) {
                        // 1. Apply category filters
                        if (_selectedFilter == 'نصوص' && m.type != MessageType.text) {
                          return false;
                        }
                        if (_selectedFilter == 'صور' && m.type != MessageType.image) {
                          return false;
                        }
                        if (_selectedFilter == 'فيديو' && m.type != MessageType.video) {
                          return false;
                        }
                        if (_selectedFilter == 'ملفات' &&
                            m.type != MessageType.pdf &&
                            m.type != MessageType.document) {
                          return false;
                        }
                        if (_selectedFilter == 'عروض أسعار' &&
                            m.type != MessageType.quotationCard &&
                            m.type != MessageType.counterOfferCard &&
                            m.type != MessageType.agreementCard) {
                          return false;
                        }

                        // 2. Apply query filter (case insensitive matching on content, cardData or time)
                        final q = _searchQuery.toLowerCase();
                        return m.content.toLowerCase().contains(q) ||
                            (m.cardData?.toString().toLowerCase().contains(q) ?? false) ||
                            m.time.toLowerCase().contains(q);
                      }).toList();

                      if (results.isEmpty) {
                        return _EmptyResults(query: _searchQuery);
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: Text(
                              '${results.length} نتيجة لـ "$_searchQuery"',
                              style: TextStyle(fontSize: 12, color: AppColors.outline),
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              itemCount: results.length,
                              separatorBuilder: (_, __) => SizedBox(height: 8),
                              itemBuilder: (_, i) => _SearchResultCard(
                                message: results[i],
                                query: _searchQuery,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final BusinessMessage message;
  final String query;

  const _SearchResultCard({required this.message, required this.query});

  @override
  Widget build(BuildContext context) {
    final content = message.content;
    final idx = content.toLowerCase().indexOf(query.toLowerCase());
    final hasHighlight = idx >= 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Text(message.time, style: TextStyle(fontSize: 10, color: AppColors.outline)),
              const Spacer(),
              Text(
                message.isOutgoing ? 'مورد نسيجي' : message.senderName,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          SizedBox(height: 6),
          hasHighlight
              ? RichText(
                  textDirection: TextDirection.rtl,
                  text: TextSpan(
                    style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                    children: [
                      TextSpan(text: content.substring(0, idx)),
                      TextSpan(
                        text: content.substring(idx, idx + query.length),
                        style: TextStyle(backgroundColor: Color(0xFFFFE58F), fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: content.substring(idx + query.length)),
                    ],
                  ),
                )
              : Text(content, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }
}

class _RecentSearches extends StatelessWidget {
  final List<String> searches;
  final Function(String) onTap;
  final Function(String) onRemove;

  const _RecentSearches({required this.searches, required this.onTap, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) {
      return Center(child: Text('لا توجد عمليات بحث سابقة', style: TextStyle(color: AppColors.outline)));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('عمليات البحث الأخيرة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            SizedBox(width: 6),
            Icon(Icons.history, size: 16, color: AppColors.outline),
          ],
        ),
        SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 6,
          children: searches.map((s) => InputChip(
            label: Text(s, style: TextStyle(fontSize: 12)),
            onPressed: () => onTap(s),
            deleteIcon: const Icon(Icons.close, size: 14),
            onDeleted: () => onRemove(s),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
            side: BorderSide.none,
          )).toList(),
        ),
      ],
    );
  }
}

class _EmptyResults extends StatelessWidget {
  final String query;
  const _EmptyResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: AppColors.outlineVariant),
          SizedBox(height: 12),
          Text('لا توجد نتائج لـ "$query"', style: TextStyle(fontSize: 15, color: AppColors.outline)),
          SizedBox(height: 6),
          Text('جرب كلمات مختلفة', style: TextStyle(fontSize: 12, color: AppColors.outline)),
        ],
      ),
    );
  }
}