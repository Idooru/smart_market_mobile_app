import 'package:flutter/material.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/model/user/presentation/pages/edit_password.page.dart';
import 'package:smart_market/model/user/presentation/pages/edit_profile.page.dart';
import 'package:smart_market/model/user/presentation/pages/register.page.dart';

class RegisterRouteStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const RegisterPage(),
      settings: settings,
    );
  }
}

class EditProfileRouteStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    final args = settings.arguments as EditProfilePageArgs;
    return MaterialPageRoute(
      builder: (context) => EditProfilePage(profile: args.profile),
      settings: settings,
    );
  }
}

class EditPasswordRouteStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const EditPasswordPage(),
      settings: settings,
    );
  }
}
