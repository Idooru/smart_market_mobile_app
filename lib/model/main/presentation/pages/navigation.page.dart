import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/handler/internal_server_error_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/network_error_handler.widget.dart';
import 'package:smart_market/model/cart/presentation/pages/cart.page.dart';
import 'package:smart_market/model/main/presentation/pages/main.page.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/pages/product_search.page.dart';
import 'package:smart_market/model/user/presentation/dialog/invitation_login.dialog.dart';
import 'package:smart_market/model/user/presentation/pages/client_profile.page.dart';
import 'package:smart_market/model/user/utils/check_is_logined.dart';

import '../../../../core/errors/connection_error.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
  final ProductService _service = locator<ProductService>();
  late Future<Map<String, dynamic>> _mainPageFuture;

  bool _isLoaded = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _mainPageFuture = initMainPageFuture();
  }

  Future<Map<String, dynamic>> initMainPageFuture() async {
    await Future.delayed(const Duration(seconds: 3));

    RequestConditionalProducts highRatedProductArgs = const RequestConditionalProducts(count: 10, condition: "high-rated-product");
    RequestConditionalProducts mostReviewProductArgs = const RequestConditionalProducts(count: 10, condition: "most-review-product");

    List<ResponseSearchProduct> highRatedProducts = await _service.getConditionalProducts(highRatedProductArgs);
    List<ResponseSearchProduct> mostReviewProducts = await _service.getConditionalProducts(mostReviewProductArgs);

    return {"high-rated-products": highRatedProducts, "most-review-products": mostReviewProducts};
  }

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void tapBottomNavigator(int index) {
    final capturedContext = context; // await 전에 context 저장
    bool isLogined = checkIsLogined();
    if ((index == 2 || index == 3) && !isLogined) {
      if (!context.mounted) return;
      InvitationLoginDialog.show(capturedContext);
    } else {
      updateSelectedIndex(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[300],
      body: FutureBuilder<Map<String, dynamic>>(
        future: _mainPageFuture,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Smart Market", style: TextStyle(color: Colors.white, fontSize: 40)),
                  SizedBox(height: 15),
                  CircularProgressIndicator(color: Colors.white),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            if (error is ConnectionError) {
              return NetworkErrorHandlerWidget(reconnectCallback: () {
                setState(() {
                  _mainPageFuture = initMainPageFuture();
                });
              });
            } else if (error is DioFailError) {
              return const InternalServerErrorHandlerWidget();
            } else {
              return Center(child: Text("$error"));
            }
          } else {
            Map<String, dynamic> datas = snapshot.data!;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _isLoaded = true;
              });
            });

            List<Widget> pages = [
              MainPage(pageArgs: datas),
              const ProductSearchPage(),
              const CartPage(),
              const ClientProfilePage(),
            ];

            return ColoredBox(
              color: Colors.blueGrey[300]!,
              child: SafeArea(
                child: pages.elementAt(_selectedIndex),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: _isLoaded
          ? BottomNavigationBar(
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
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.black,
              onTap: tapBottomNavigator,
            )
          : null,
    );
  }
}
