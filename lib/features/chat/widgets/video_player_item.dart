import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({super.key, required this.videoUrl});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerPlusController videoPlayerController;
  bool isPlay = false;

  @override
  void initState() {
    print("*****************");
    print("The url is ${widget.videoUrl}");
    videoPlayerController = CachedVideoPlayerPlusController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.setVolume(1);
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(children: [
        CachedVideoPlayerPlus(videoPlayerController),
        Align(
          alignment: Alignment.center,
          child: IconButton(
            onPressed: () {
              if (isPlay) {
                videoPlayerController.pause();
              } else {
                videoPlayerController.play();
              }

              setState(() {
                isPlay = !isPlay;
              });
            },
            icon: isPlay
                ? const Icon(Icons.pause_circle)
                : const Icon(Icons.play_circle),
          ),
        ),
      ]),
    );
  }
}
