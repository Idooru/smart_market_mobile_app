import 'package:flutter/material.dart';
import 'package:smart_market/model/main/presentation/page/app_main.page.dart';

class ProductSearchButtonWidget extends StatelessWidget {
  const ProductSearchButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          final state = context.findAncestorStateOfType<AppMainPageState>();
          state?.tapBottomNavigator(1); // index 1 = ProductSearchPage
        },
        child: Container(
          color: Colors.blueGrey[100],
          height: 45,
          padding: const EdgeInsets.all(5),
          child: const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                ),
                child: Icon(Icons.search),
              ),
              Text("상품 검색 하기"),
            ],
          ),
        ),
      ),
    );
  }
}
