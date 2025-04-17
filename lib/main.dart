import 'package:flutter/material.dart';
import 'package:smart_market/core/themes/theme_data.dart';
// import 'package:provider/provider.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';

void main() {
  initLocator();
  /*
   * 현재 생성된 Provider 없으므로 잠시 비워둠
   */
  // MultiProvider(
  //   providers: const [],
  //   child: const MyApp(),
  // );

  /* Provider 사용시 위 코드로 대체해야함 */
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Hello World"),
          backgroundColor: Colors.red,
        ),
        body: const ColoredBox(color: Colors.red),
      ),
    );
  }
}
