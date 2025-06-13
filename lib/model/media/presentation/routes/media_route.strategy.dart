import 'package:flutter/material.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/model/media/presentation/pages/camera.page.dart';

final Map<String, RouteStrategy> mediaRouteStrategies = {
  "/camera": CameraRouteStrategy(),
};

class CameraRouteStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    final args = settings.arguments as CameraPageArgs;
    return MaterialPageRoute(
      builder: (context) => CameraPage(
        camera: args.camera,
        appendMedia: args.appendMedia,
      ),
    );
  }
}
