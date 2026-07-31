import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../providers/reviews_provider.dart';
import '../widgets/write_review_widgets.dart';

class WriteReviewScreen extends ConsumerStatefulWidget {
  final String orderId;
  const WriteReviewScreen({super.key, required this.orderId});

  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  String _reviewText = '';
  bool _isPublic = true;
  final List<String> _images = [];
  final List<String> _videos = [];

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersNotifierProvider);
    final notifier = ref.read(reviewsNotifierProvider.notifier);

    final OrderModel? order = () {
      try {
        return orders.firstWhere((o) => o.id == widget.orderId);
      } catch (_) {
        return null;
      }
    }();

    return Scaffold(
      appBar: AppBar(
        title: const Text('كتابة التقييم'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextEditorWidget(
                text: _reviewText,
                onChanged: (val) => setState(() => _reviewText = val),
              ),
              AppSpacing.hMD,
              MediaUploaderWidget(
                images: _images,
                videos: _videos,
                onUploadImage: () {
                  setState(() {
                    _images.add('https://images.unsplash.com/photo-1598300042247-d088f8ab3a91');
                  });
                },
                onUploadVideo: () {
                  setState(() => _videos.add('video_${_videos.length + 1}.mp4'));
                },
                onRemoveImage: (i) => setState(() => _images.removeAt(i)),
                onRemoveVideo: (i) => setState(() => _videos.removeAt(i)),
              ),
              AppSpacing.hMD,
              VisibilityWidget(
                isPublic: _isPublic,
                onChanged: (val) => setState(() => _isPublic = val),
              ),
              AppSpacing.hLG,
              WriteReviewSubmitWidget(
                isEnabled: _reviewText.length >= 10,
                onSubmit: () {
                  notifier.submitReview(
                    orderId: widget.orderId,
                    supplierId: order?.supplierName ?? '',
                    supplierName: order?.supplierName ?? '',
                    reviewText: _reviewText,
                    images: _images,
                    videos: _videos,
                    isPublic: _isPublic,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم نشر تقييمك بنجاح! شكراً لمشاركتك.')),
                  );
                  context.pop();
                  context.pop();
                },
                onCancel: () => context.pop(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}


