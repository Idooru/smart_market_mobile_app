import 'package:flutter/material.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/model/media/presentation/pages/photo_camera.page.dart';
import 'package:smart_market/model/media/presentation/pages/video_camera.page.dart';

final Map<String, RouteStrategy> mediaRouteStrategies = {
  "/photo_camera": PhotoCameraRouteStrategy(),
  "/video_camera": VideoCameraRouteStrategy(),
};

class PhotoCameraRouteStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const PhotoCameraPage());
  }
}

class VideoCameraRouteStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const VideoCameraPage());
  }
}
