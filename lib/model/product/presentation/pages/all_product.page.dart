import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/handler/internal_server_error_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/network_error_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/model/product/domain/entities/response/all_product.entity.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/widgets/product_item.widget.dart';
import 'package:smart_market/model/product/presentation/widgets/search_filter.widget.dart';

class AllProductPage extends StatefulWidget {
  const AllProductPage({super.key});

  @override
  State<AllProductPage> createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage> {
  final ProductService productService = locator<ProductService>();
  late Future<List<AllProduct>> _getAllProductFuture;

  @override
  void initState() {
    super.initState();
    _getAllProductFuture = productService.getAllProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 45,
                color: const Color.fromARGB(255, 39, 40, 41),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: IconButton(
                  icon: const Icon(
                    Icons.filter,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => Dialog(
                        child: SearchFilterWidget(
                          filterCallback: (args) {
                            setState(() {
                              _getAllProductFuture = productService.getAllProduct(args);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.blueGrey[100],
                  height: 45,
                  padding: const EdgeInsets.all(5),
                  child: TextField(
                    // controller: controller,
                    // focusNode: focusNode,
                    // onChanged: (String search) => phonebookService.searchUser(phonbook, search),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                      hintText: "상품 이름 검색",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ColoredBox(
        color: Colors.white,
        child: FutureBuilder(
          future: _getAllProductFuture,
          builder: (BuildContext context, AsyncSnapshot<List<AllProduct>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingHandlerWidget(title: "상품 전체 데이터 불러오기..");
            } else if (snapshot.hasError) {
              DioFailError error = snapshot.error as DioFailError;
              if (error.message.contains("Timeout") || error.message.contains('Socket')) {
                return NetworkErrorHandlerWidget(reconnectCallback: () {
                  setState(() {
                    _getAllProductFuture = productService.getAllProduct();
                  });
                });
              } else {
                return const InternalServerErrorHandlerWidget();
              }
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => ProductItemWidget(
                  currentAllProduct: data[index],
                  margin: index != data.length - 1 ? const EdgeInsets.fromLTRB(13, 13, 13, 0) : const EdgeInsets.fromLTRB(13, 13, 13, 10),
                ),
              );
            } else {
              return const Center(child: Text('데이터가 없습니다.'));
            }
          },
        ),
      ),
    );
  }
}
