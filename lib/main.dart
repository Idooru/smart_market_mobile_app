import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/account/presentation/provider/create_account.provider.dart';
import 'package:smart_market/model/main/presentation/pages/navigation.page.dart';
import 'package:smart_market/model/product/presentation/provider/product_filtered.provider.dart';
import 'package:smart_market/model/product/presentation/provider/product_search.provider.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';

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
