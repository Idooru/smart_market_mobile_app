import 'package:flutter/material.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/product/domain/entities/response/all_product.entity.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
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
    return Scaffold(
      body: FutureBuilder(
        future: productService.getAllProduct(context),
        builder: (BuildContext context, AsyncSnapshot<List<AllProduct>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ColoredBox(
              color: Colors.white,
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => ProductItemWidget(
                  currentAllProduct: data[index],
                  margin: index != data.length - 1 ? const EdgeInsets.fromLTRB(13, 13, 13, 0) : const EdgeInsets.fromLTRB(13, 13, 13, 10),
                ),
              ),
            );
          } else {
            return const Center(child: Text('데이터가 없습니다.'));
          }
        },
      ),
    );
  }
}
