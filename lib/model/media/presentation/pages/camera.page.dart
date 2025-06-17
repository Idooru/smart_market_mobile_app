import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

abstract class CameraPageState<T extends StatefulWidget> extends State<T> {
  Widget CameraArea({
    required CameraController controller,
    required void Function() pressFilmingCallback,
    required IconData filmingIcon,
    required Color buttonColor,
  }) {
    return Stack(
      children: [
        Positioned.fill(child: CameraPreview(controller)),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
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
              onTap: pressFilmingCallback,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Center(
                  child: Icon(
                    filmingIcon,
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
  }
}
