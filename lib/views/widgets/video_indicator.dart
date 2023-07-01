import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoIndicator extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoIndicator({required this.controller});

  @override
  _VideoIndicatorState createState() => _VideoIndicatorState();
}

class _VideoIndicatorState extends State<VideoIndicator> {
  late VideoPlayerController _controller;
  late double _progressValue;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _progressValue = 0.0;
    _controller.addListener(_onProgressUpdated);
  }

  void _onProgressUpdated() {
    final progress = _controller.value.position.inMilliseconds /
        _controller.value.duration.inMilliseconds;
    setState(() {
      _progressValue = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _progressValue,
      min: 0.0,
      max: 1.0,
      onChanged: (newValue) {
        final position =
            Duration(milliseconds: (newValue * _controller.value.duration.inMilliseconds).round());
        _controller.seekTo(position);
      },
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onProgressUpdated);
    super.dispose();
  }
}
