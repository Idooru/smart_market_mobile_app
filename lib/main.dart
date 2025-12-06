import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/provider_initializer.dart';

import 'model/main/presentation/pages/navigation.page.dart';
import 'model/main/presentation/pages/splash.page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocator();
  await dotenv.load(fileName: 'assets/config/.env');

  runApp(
    MultiProvider(
      providers: initProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      initialRoute: "/loading",
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == "/loading") {
          return MaterialPageRoute(
            builder: (_) => const SplashPage(),
            settings: settings,
          );
        } else if (settings.name == '/home') {
          final args = settings.arguments as NavigationPageArgs;
          return MaterialPageRoute(
            builder: (_) => NavigationPage(initialIndex: args.selectedIndex),
            settings: settings,
          );
        } else {
          final strategy = routeStrategies[settings.name];
          if (strategy != null) {
            return strategy.route(settings);
          }
          return null;
        }
      },
    );
  }
}
