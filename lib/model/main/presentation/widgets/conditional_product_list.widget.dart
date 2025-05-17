import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/handler/internal_server_error_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/network_error_handler.widget.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/widgets/item/product_grid_item.widget.dart';

class ConditionalProductListWidget extends StatefulWidget {
  final String title;
  final int count;
  final String condition;

  const ConditionalProductListWidget({
    super.key,
    required this.title,
    required this.count,
    required this.condition,
  });

  @override
  State<ConditionalProductListWidget> createState() => _ConditionalProductListWidgetState();
}

class _ConditionalProductListWidgetState extends State<ConditionalProductListWidget> {
  final ProductService service = locator<ProductService>();
  late Future<List<ResponseSearchProduct>> getConditionalProductFuture;

  @override
  void initState() {
    super.initState();
    RequestConditionalProducts args = RequestConditionalProducts(
      count: widget.count,
      condition: widget.condition,
    );

    getConditionalProductFuture = service.getConditionalProducts(args);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          FutureBuilder(
            future: getConditionalProductFuture,
            builder: (BuildContext context, AsyncSnapshot<List<ResponseSearchProduct>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [
                    const SizedBox(height: 50),
                    LoadingHandlerWidget(title: "${widget.title} 불러오기.."),
                    const SizedBox(height: 50),
                  ],
                );
              } else if (snapshot.hasError) {
                DioFailError err = snapshot.error as DioFailError;
                if (err.message == "none connection") {
                  return Column(
                    children: [
                      const SizedBox(height: 25),
                      NetworkErrorHandlerWidget(reconnectCallback: () {
                        RequestConditionalProducts args = RequestConditionalProducts(
                          count: 10,
                          condition: widget.condition,
                        );

                        setState(() {
                          getConditionalProductFuture = service.getConditionalProducts(args);
                        });
                      }),
                      const SizedBox(height: 25),
                    ],
                  );
                } else {
                  return const Column(
                    children: [
                      SizedBox(height: 25),
                      InternalServerErrorHandlerWidget(),
                      SizedBox(height: 25),
                    ],
                  );
                }
              } else if (snapshot.hasData) {
                final products = snapshot.data!;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: products.map((product) => ProductGridItemWidget(product: product)).toList(),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          )
        ],
      ),
    );
  }
}
