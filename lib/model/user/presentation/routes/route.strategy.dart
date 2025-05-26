import 'package:flutter/material.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/model/user/presentation/pages/edit_password.page.dart';
import 'package:smart_market/model/user/presentation/pages/edit_profile.page.dart';
import 'package:smart_market/model/user/presentation/pages/find_email.page.dart';
import 'package:smart_market/model/user/presentation/pages/login.page.dart';
import 'package:smart_market/model/user/presentation/pages/register.page.dart';
import 'package:smart_market/model/user/presentation/pages/reset_password.page.dart';

final Map<String, RouteStrategy> userRouteStrategies = {
  "/login": LoginRouteStrategy(),
  "/register": RegisterRouteStrategy(),
  "/find_email": FindEmailRouteStrategy(),
  "/reset_password": ResetPasswordRouteStrategy(),
  "/edit_profile": EditProfileRouteStrategy(),
  "/edit_password": EditPasswordRouteStrategy(),
};

class LoginRouteStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => LoginPage(),
      settings: settings,
    );
  }
}

class RegisterRouteStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const RegisterPage(),
      settings: settings,
    );
  }
}

class FindEmailRouteStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const FindEmailPage(),
      settings: settings,
    );
  }
}

class ResetPasswordRouteStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    final args = settings.arguments as ResetPasswordPageArgs;
    return MaterialPageRoute(
      builder: (context) => ResetPasswordPage(email: args.email),
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
