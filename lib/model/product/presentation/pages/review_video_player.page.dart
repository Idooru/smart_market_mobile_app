import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReviewVideoPlayerPageArgs {
  final String url;

  const ReviewVideoPlayerPageArgs({required this.url});
}

class ReviewVideoPlayerPage extends StatefulWidget {
  final String url;

  const ReviewVideoPlayerPage({super.key, required this.url});

  @override
  State<ReviewVideoPlayerPage> createState() => _ReviewVideoPlayerPageState();
}

class _ReviewVideoPlayerPageState extends State<ReviewVideoPlayerPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 40,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          Center(
            child: IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 70,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
