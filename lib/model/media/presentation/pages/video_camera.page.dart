import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/media/presentation/pages/camera.page.dart';
import 'package:smart_market/model/media/presentation/provider/review_video.provider.dart';

import '../../../../core/widgets/handler/loading_handler.widget.dart';
import '../../domain/entities/file_source.entity.dart';

class VideoCameraPage extends StatefulWidget {
  const VideoCameraPage({super.key});

  @override
  State<VideoCameraPage> createState() => _VideoCameraPageState();
}

class _VideoCameraPageState extends CameraPageState<VideoCameraPage> {
  late CameraController _controller;
  late Future<void> _videoCameraPageFuture;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();

    _videoCameraPageFuture = initVideoCameraPageFuture();
  }

  Future<void> initVideoCameraPageFuture() async {
    WidgetsFlutterBinding.ensureInitialized();

    final cameras = await availableCameras();
    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.max,
    );

    return _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      await _controller.startVideoRecording();
      setState(() => _isRecording = true);
    } catch (e) {
      debugPrint("Error starting video recording: $e");
    }
  }

  Future<void> stopRecording(ReviewVideoProvider provider) async {
    NavigatorState navigator = Navigator.of(context);

    try {
      XFile xFile = await _controller.stopVideoRecording();
      File file = File(xFile.path);
      FileSource fileSource = FileSource(file: file, source: MediaSource.file);

      setState(() => _isRecording = false);
      provider.appendReviewVideos([fileSource]);
    } catch (err) {
      debugPrint("err: $err");
    } finally {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewVideoProvider>(
      builder: (BuildContext context, ReviewVideoProvider provider, Widget? child) {
        return Scaffold(
          body: FutureBuilder<void>(
            future: _videoCameraPageFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraArea(
                  controller: _controller,
                  pressFilmingCallback: _isRecording ? () => stopRecording(provider) : startRecording,
                  buttonColor: _isRecording ? Colors.red : Colors.white,
                  filmingIcon: _isRecording ? Icons.stop : Icons.videocam,
                );
              } else {
                return const LoadingHandlerWidget(title: "동영상 촬영 카메라 불러오기..");
              }
            },
          ),
        );
      },
    );
  }
}
