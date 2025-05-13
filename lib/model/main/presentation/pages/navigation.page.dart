import 'package:flutter/material.dart';
import 'package:smart_market/model/main/presentation/pages/main.page.dart';
import 'package:smart_market/model/main/presentation/pages/test.page.dart';
import 'package:smart_market/model/product/presentation/pages/product_search.page.dart';
import 'package:smart_market/model/user/presentation/pages/client_profile.page.dart';
import 'package:smart_market/model/user/presentation/pages/login.page.dart';
import 'package:smart_market/model/user/presentation/widgets/invitation_login.dialog.dart';
import 'package:smart_market/model/user/utils/check_is_logined.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
  int selectedIndex = 0;

  void updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> tapBottomNavigator(int index) async {
    final capturedContext = context; // await 전에 context 저장
    bool isLogined = await checkIsLogined();
    if ((index == 2 || index == 3) && !isLogined) {
      if (!context.mounted) return;
      InvitationLoginDialog.show(capturedContext, index, updateSelectedIndex);
    } else {
      updateSelectedIndex(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkIsLogined(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        bool isLogined = snapshot.data!;

        List<Widget> pages = [
          const MainPage(),
          const ProductSearchPage(),
          isLogined ? const TestWidget() : const LoginPage(),
          isLogined ? const ClientProfilePage() : const LoginPage(),
        ];

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
      },
    );
  }
}
