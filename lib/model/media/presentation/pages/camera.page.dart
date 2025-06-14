import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:smart_market/model/media/domain/service/media.service.dart';

import '../../../../core/utils/get_it_initializer.dart';

enum CameraMode { photo, video }

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final MediaService _mediaService = locator<MediaService>();
  late CameraDescription camera;
  late CameraController _controller; // 카메라 컨트롤러
  late Future<void> _cameraPageFuture; // 컨트롤러 초기화 작업을 담당할 Future 객체
  CameraMode _mode = CameraMode.photo;

  @override
  void initState() {
    super.initState();

    _cameraPageFuture = initCameraPageFuture();
  }

  Future<void> initCameraPageFuture() async {
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

  Future<void> pressPhotoCamera() async {
    NavigatorState navigator = Navigator.of(context);
    try {
      // 사진 캡처를 시도하고 결과를 저장합니다.
      XFile image = await _controller.takePicture();
      File file = File(image.path);

      await _mediaService.uploadReviewImages([file]);

      navigator.pop(true);
    } catch (err) {
      navigator.pop(false);
    }
  }

  Future<void> pressVideoCamera() async {
    try {} catch (err) {
      debugPrint('take a picture error');
      debugPrint('$err');
      debugPrintStack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _cameraPageFuture,
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
