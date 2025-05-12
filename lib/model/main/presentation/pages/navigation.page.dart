import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/main/presentation/pages/main.page.dart';
import 'package:smart_market/model/main/presentation/pages/test.page.dart';
import 'package:smart_market/model/main/presentation/pages/test2.page.dart';
import 'package:smart_market/model/product/presentation/pages/product_search.page.dart';
import 'package:smart_market/model/user/presentation/pages/login.page.dart';
import 'package:smart_market/model/user/presentation/state/login.provider.dart';
import 'package:smart_market/model/user/presentation/widgets/invitation_login.dialog.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
  int selectedIndex = 0;

  late LoginProvider loginProvider;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    loginProvider = context.read<LoginProvider>();
    pages = [
      const MainPage(),
      const ProductSearchPage(),
      if (loginProvider.isLogined) const TestWidget() else const LoginPage(),
      if (loginProvider.isLogined) const Test2Widget() else const LoginPage(),
    ];
  }

  void updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void tapBottomNavigator(int index) {
    if (index == 2 || index == 3) {
      InvitationLoginDialog.show(context, index, updateSelectedIndex);
    } else {
      updateSelectedIndex(index);
    }
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
