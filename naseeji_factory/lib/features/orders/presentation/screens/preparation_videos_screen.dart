import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../widgets/preparation_videos_widgets.dart';

class PreparationVideosScreen extends StatefulWidget {
  final String orderId;

  const PreparationVideosScreen({super.key, required this.orderId});

  @override
  State<PreparationVideosScreen> createState() => _PreparationVideosScreenState();
}

class _PreparationVideosScreenState extends State<PreparationVideosScreen> {
  final List<Map<String, String>> _mockVideos = const [
    {
      'thumbnail': 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17',
      'duration': '١:٤٥ دقيقة',
      'date': '2026/07/08',
      'note': 'فيديو توثيق فحص عينات الشد والمقاومة',
    },
    {
      'thumbnail': 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d',
      'duration': '٢:١٠ دقيقة',
      'date': '2026/07/12',
      'note': 'فيديو التحميل والفرز والتعبئة النهائية',
    },
  ];

  void _playVideo(Map<String, String> video) {
    showDialog(
      context: context,
      builder: (context) => VideoPlayerWidget(video: video),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل فيديوهات التحضير'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: VideosHeaderWidget(orderId: widget.orderId),
            ),
            Expanded(
              child: VideosListWidget(
                videos: _mockVideos,
                onVideoTap: _playVideo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
