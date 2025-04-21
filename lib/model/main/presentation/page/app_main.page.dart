import 'package:flutter/material.dart';
import 'package:smart_market/model/product/presentation/pages/all_product.page.dart';
import 'package:smart_market/model/main/presentation/page/test.page.dart';
import 'package:smart_market/model/main/presentation/page/test2.page.dart';

class AppMainPage extends StatefulWidget {
  const AppMainPage({super.key});

  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> {
  int selectedIndex = 1;

  List<Widget> pages = [const Test2Widget(), const AllProductPage(), const TestWidget()];

  void tapBottomNavigator(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Smart Market"),
      ),
      body: SafeArea(child: pages.elementAt(selectedIndex)),
      bottomNavigationBar: SizedBox(
        height: 95,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(255, 207, 207, 207),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_mall),
              label: "products",
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
      ),
    );
  }
}
