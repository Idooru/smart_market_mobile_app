import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/main/presentation/pages/navigation.page.dart';
import 'package:smart_market/model/product/presentation/state/product_filtered.provider.dart';
import 'package:smart_market/model/product/presentation/state/product_search.provider.dart';

void main() async {
  initLocator();
  await dotenv.load(fileName: 'assets/config/.env');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductFilteredProvider()),
        ChangeNotifierProvider(create: (context) => ProductSearchProvider()),
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
      routes: {
        '/home': (context) {
          return const NavigationPage();
        },
      },
      onGenerateRoute: (RouteSettings settings) {
        final strategy = routeStrategies[settings.name];
        if (strategy != null) {
          return strategy.route(settings);
        }
        return null;
      },
      home: const NavigationPage(),
    );
  }
}
