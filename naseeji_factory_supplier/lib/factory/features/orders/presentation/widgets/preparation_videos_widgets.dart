import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'orders_reusable_widgets.dart';

class VideosHeaderWidget extends StatelessWidget {
  final String orderId;

  const VideosHeaderWidget({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'سجل فيديوهات التحضير للطلب: $orderId',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        const Text(
          'فيديوهات مراقبة الجودة، وعمليات التعبئة، والتحميل المباشر المرفوعة من المورد.',
          style: TextStyle(color: Colors.grey, fontSize: 10),
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}

class VideosListWidget extends StatelessWidget {
  final List<Map<String, String>> videos;
  final ValueChanged<Map<String, String>> onVideoTap;

  const VideosListWidget({
    super.key,
    required this.videos,
    required this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Text('لا توجد فيديوهات مرفوعة حالياً.'),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: videos.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final video = videos[index];
        return VideoCardWidget(
          video: video,
          onPlay: () => onVideoTap(video),
        );
      },
    );
  }
}

class VideoCardWidget extends StatelessWidget {
  final Map<String, String> video;
  final VoidCallback onPlay;

  const VideoCardWidget({
    super.key,
    required this.video,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return VideoCard(
      thumbnail: video['thumbnail'] ?? '',
      duration: video['duration'] ?? '',
      date: video['date'] ?? '',
      note: video['note'] ?? '',
      onPlay: onPlay,
    );
  }
}

class VideoPlayerWidget extends StatelessWidget {
  final Map<String, String> video;

  const VideoPlayerWidget({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              video['note'] ?? 'مشغل الفيديو',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: const Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.movie_creation_outlined, color: Colors.white30, size: 64),
                  Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 48),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'المدة: ${video['duration'] ?? ''} • تم الرفع في: ${video['date'] ?? ''}',
              style: const TextStyle(color: Colors.white70, fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }
}



