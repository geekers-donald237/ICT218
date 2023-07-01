import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  late bool isVideoPlaying = true;
  bool isIconVisible = false;
  double iconSize = 64.0;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        setState(
            () {}); // Met à jour l'interface utilisateur une fois que la vidéo est initialisée
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  Duration getCurrentPosition() {
  return videoPlayerController.value.position;
}

  void togglePlayPause() {
    setState(() {
      if (videoPlayerController.value.isPlaying) {
        videoPlayerController.pause();
        isVideoPlaying = false;
      } else {
        videoPlayerController.play();
        isVideoPlaying = true;
      }
      isIconVisible = true;
      Timer(const Duration(seconds: 2), () {
        setState(() {
          isIconVisible = false;
        });
      });
    });
  }

  void animateIconSize() {
    setState(() {
      iconSize = 80.0;
    });
    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        iconSize = 64.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Vérifie si la vidéo est initialisée
    if (videoPlayerController.value.isInitialized) {
      return GestureDetector(
        onTap: () {
          togglePlayPause();
          animateIconSize();
        },
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: VideoPlayer(videoPlayerController),
            ),
            Align(
              alignment: Alignment.center,
              child: AnimatedOpacity(
                opacity: isIconVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 100),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: iconSize,
                  height: iconSize,
                  child: Icon(
                    isVideoPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: size.width,
        height: size.height,
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
