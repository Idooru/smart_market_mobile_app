import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

enum CameraMode { photo, video }

class CameraPageArgs {
  final CameraDescription camera;
  final Future<void> Function(File) appendMedia;

  const CameraPageArgs({
    required this.camera,
    required this.appendMedia,
  });
}

class CameraPage extends StatefulWidget {
  final CameraDescription camera;
  final Future<void> Function(File) appendMedia;

  const CameraPage({
    super.key,
    required this.camera,
    required this.appendMedia,
  });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller; // 카메라 컨트롤러
  late Future<void> _initializeControllerFuture; // 컨트롤러 초기화 작업을 담당할 Future 객체

  CameraMode _mode = CameraMode.photo;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> pressPhotoCamera() async {
    try {
      NavigatorState navigator = Navigator.of(context);
      // 컨트롤러 초기화를 기다립니다.
      // await _initializeControllerFuture;

      // 사진 캡처를 시도하고 결과를 저장합니다.
      final image = await _controller.takePicture();
      final file = File(image.path);

      // 캡처된 사진을 보여주는 화면으로 이동합니다.
      // if (!mounted) return;
      // await Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => DisplayPictureScreen(imagePath: image.path),
      //   ),
      // );

      await widget.appendMedia(file);

      navigator.pop();
      // Navigator.pop(context);
    } catch (err) {
      debugPrint('take a picture error');
      debugPrint('$err');
      debugPrintStack();
    }
  }

  Future<void> pressVideoCamera() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Positioned.fill(
                  child: CameraPreview(_controller),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: _mode == CameraMode.photo ? pressPhotoCamera : pressVideoCamera,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Center(
                          child: Icon(
                            _mode == CameraMode.photo ? Icons.camera_alt : Icons.video_call,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _mode = _mode == CameraMode.photo ? CameraMode.video : CameraMode.photo;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.autorenew,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
