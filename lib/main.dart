import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/account/presentation/provider/create_account.provider.dart';
import 'package:smart_market/model/media/presentation/provider/review_image.provider.dart';
import 'package:smart_market/model/order/presentation/provider/after_create_order.provider.dart';
import 'package:smart_market/model/order/presentation/provider/create_order.provider.dart';
import 'package:smart_market/model/product/presentation/provider/product_filtered.provider.dart';
import 'package:smart_market/model/product/presentation/provider/product_search.provider.dart';
import 'package:smart_market/model/review/presentation/provider/edit_review.provider.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';

import 'model/main/presentation/pages/navigation.page.dart';
import 'model/main/presentation/pages/splash.page.dart';
import 'model/media/presentation/provider/review_video.provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocator();
  await dotenv.load(fileName: 'assets/config/.env');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductFilteredProvider()),
        ChangeNotifierProvider(create: (context) => ProductSearchProvider()),
        ChangeNotifierProvider(create: (context) => EditUserColumnProvider()),
        ChangeNotifierProvider(create: (context) => CreateAccountProvider()),
        ChangeNotifierProvider(create: (context) => CreateOrderProvider()),
        ChangeNotifierProvider(create: (context) => CompleteCreateOrderProvider()),
        ChangeNotifierProvider(create: (context) => EditReviewProvider()),
        ChangeNotifierProvider(create: (context) => ReviewImageProvider()),
        ChangeNotifierProvider(create: (context) => ReviewVideoProvider()),
      ],
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
          final args = settings.arguments as NavigationPageArgs?;
          return MaterialPageRoute(
            builder: (_) => NavigationPage(initialIndex: args?.selectedIndex ?? 0),
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
