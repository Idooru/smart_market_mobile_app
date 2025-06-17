import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/media/presentation/pages/camera.page.dart';

import '../../../../core/widgets/handler/loading_handler.widget.dart';
import '../provider/review_image.provider.dart';

class PhotoCameraPage extends StatefulWidget {
  const PhotoCameraPage({super.key});

  @override
  State<PhotoCameraPage> createState() => _PhotoCameraPageState();
}

class _PhotoCameraPageState extends CameraPageState<PhotoCameraPage> {
  late CameraController _controller;
  late Future<void> _photoCameraPageFuture;

  @override
  void initState() {
    super.initState();

    _photoCameraPageFuture = initPhotoCameraPageFuture();
  }

  Future<void> initPhotoCameraPageFuture() async {
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

  Future<void> pressPhotoCamera(ReviewImageProvider provider) async {
    NavigatorState navigator = Navigator.of(context);

    try {
      XFile xfile = await _controller.takePicture();
      File file = File(xfile.path);

      provider.appendReviewImages([file]);
    } catch (err) {
      debugPrint("err: $err");
    } finally {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewImageProvider>(
      builder: (BuildContext context, ReviewImageProvider provider, Widget? child) {
        return Scaffold(
          body: FutureBuilder<void>(
            future: _photoCameraPageFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraArea(
                  controller: _controller,
                  pressFilmingCallback: () => pressPhotoCamera(provider),
                  buttonColor: Colors.white,
                  filmingIcon: Icons.camera_alt,
                );
              } else {
                return const LoadingHandlerWidget(title: "사진 촬영 카메라 불러오기..");
              }
            },
          ),
        );
      },
    );
  }
}
