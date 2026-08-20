import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/features/welcome/models/video_item.dart';
import 'package:three_alfa_mobile_app/features/welcome/widgets/video_card.dart';
import 'package:video_player/video_player.dart';

class VideosSection extends StatelessWidget {
  final List<VideoItem> _videos = [
    VideoItem(
      thumbnailAsset: 'assets/welcome/thumbnails/thumbnails1.jpg',
      title: 'Video 1',
      duration: '0:27',
      videoUrl: 'assets/welcome/videos/video1.mp4',
    ),
    VideoItem(
      thumbnailAsset: 'assets/welcome/thumbnails/thumbnails2.jpg',
      title: 'Video 2',
      duration: '1:24',
      videoUrl: 'assets/welcome/videos/video2.mp4',
    ),
  ];

  void _openVideo(BuildContext context, VideoItem video) {
    showDialog(
      context: context,
      builder: (_) => SizedBox(
        height: 50,
        child: Dialog(
          backgroundColor: Colors.black,
          clipBehavior: Clip.antiAlias,
          child: VideoDialog(video: video),
        ),
      ),
    );
  }

  VideosSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.3.w),
      child: Row(
        children: [
          for (int i = 0; i < _videos.length; i++) ...[
            Expanded(
              child: AspectRatio(
                aspectRatio: 0.95,
                child: VideoCard(
                  thumbnailAsset: _videos[i].thumbnailAsset,
                  title: _videos[i].title,
                  duration: _videos[i].duration,
                  onTap: () => _openVideo(context, _videos[i]),
                ),
              ),
            ),
            if (i != _videos.length - 1) Gap(3.w),
          ],
        ],
      ),
    );
  }
}

class VideoDialog extends StatefulWidget {
  final VideoItem video;

  const VideoDialog({super.key, required this.video});

  @override
  State<VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset(widget.video.videoUrl)
      ..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: true,
          looping: false,
        );

        setState(() {});
      });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) {
      return const SizedBox(
        width: 350,
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Chewie(controller: _chewieController!),
      ),
    );
  }
}
