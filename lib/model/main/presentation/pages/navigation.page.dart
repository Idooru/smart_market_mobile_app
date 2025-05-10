import 'package:flutter/material.dart';
import 'package:smart_market/model/main/presentation/pages/main.page.dart';
import 'package:smart_market/model/main/presentation/pages/test.page.dart';
import 'package:smart_market/model/main/presentation/pages/test2.page.dart';
import 'package:smart_market/model/product/presentation/pages/product_search.page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
  int selectedIndex = 0;

  List<Widget> pages = [
    const MainPage(),
    const ProductSearchPage(),
    const Test2Widget(),
    const TestWidget(),
  ];

  void tapBottomNavigator(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Colors.blueGrey[300]!,
        child: SafeArea(
          child: pages.elementAt(selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "main",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page),
            label: "profile",
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        onTap: tapBottomNavigator,
      ),
    );
  }
}
