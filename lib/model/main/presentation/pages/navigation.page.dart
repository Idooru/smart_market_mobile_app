import 'package:flutter/material.dart';

import '../../../cart/presentation/pages/cart.page.dart';
import '../../../product/presentation/pages/product_search.page.dart';
import '../../../user/presentation/dialog/invitation_login.dialog.dart';
import '../../../user/presentation/pages/profile.page.dart';
import '../../../user/utils/check_is_logined.dart';
import 'main.page.dart';

class NavigationPageArgs {
  final int selectedIndex;

  const NavigationPageArgs({
    required this.selectedIndex,
  });
}

class NavigationPage extends StatefulWidget {
  final int initialIndex;

  const NavigationPage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<NavigationPage> createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
  late int _selectedIndex;

  List<Widget> pages = [
    const MainPage(),
    const ProductSearchPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.initialIndex;
  }

  void tapBottomNavigator(int index) {
    if ((index == 2 || index == 3) && !checkIsLogined()) {
      return InvitationLoginDialog.show(context);
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      "/home",
      (route) => false,
      arguments: NavigationPageArgs(selectedIndex: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 220, 220, 220),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: tapBottomNavigator,
      ),
    );
  }
}
