import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/state/product.provider.dart';
import 'package:smart_market/model/product/presentation/widgets/product_item.widget.dart';

class AllProductPage extends StatefulWidget {
  const AllProductPage({super.key});

  @override
  State<AllProductPage> createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage> {
  final ProductService productService = locator<ProductService>();

  @override
  Widget build(BuildContext context) {
    productService.insertAllProduct(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Smart Market"),
        toolbarHeight: 80,
      ),
      body: Consumer<ProductProvider>(
        builder: (BuildContext context, ProductProvider productProvider, Widget? child) {
          return ColoredBox(
            color: Colors.white,
            child: ListView.builder(
              itemCount: productProvider.allProducts.length,
              itemBuilder: (context, index) => ProductItemWidget(
                currentAllProduct: productProvider.allProducts[index],
                margin: index != productProvider.allProducts.length - 1 ? const EdgeInsets.fromLTRB(13, 13, 13, 0) : const EdgeInsets.fromLTRB(13, 13, 13, 10),
              ),
            ),
          );
        },
      ),
    );
  }
}
