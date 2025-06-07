import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/get_snackbar.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/model/cart/domain/entities/create_cart.entity.dart';
import 'package:smart_market/model/cart/presentation/dialog/create_cart.dialog.dart';
import 'package:smart_market/model/product/domain/entities/detail_product.entity.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/widgets/image/product_image_grid.widget.dart';

import '../../../../core/errors/connection_error.dart';
import '../../../../core/utils/check_jwt_duration.dart';
import '../../../../core/utils/format_number.dart';
import '../../../../core/widgets/dialog/handle_network_error_on_dialog.dialog.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';
import '../../../cart/domain/service/cart.service.dart';
import '../../../user/presentation/dialog/invitation_login.dialog.dart';
import '../../../user/utils/check_is_logined.dart';
import '../widgets/display_average_score.widget.dart';
import '../widgets/item/review_item.widget.dart';

class DetailProductPageArgs {
  final String productId;

  const DetailProductPageArgs({required this.productId});
}

class DetailProductPage extends StatefulWidget {
  final String productId;

  const DetailProductPage({
    super.key,
    required this.productId,
  });

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  final ProductService productService = locator<ProductService>();
  final CartService _cartService = locator<CartService>();
  late Future<ResponseDetailProduct> _getDetailProductFuture;

  @override
  void initState() {
    super.initState();
    _getDetailProductFuture = productService.getDetailProduct(widget.productId);
  }

  void handleCartError(Object err) {
    HandleNetworkErrorOnDialogDialog.show(context, err);
  }

  Future<void> pressCreateCart(ResponseDetailProduct product) async {
    bool isLogined = checkIsLogined();
    if (!isLogined) return InvitationLoginDialog.show(context);

    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    await checkJwtDuration();
    Future<void> createCart({required int quantity, required int totalPrice}) async {
      RequestCreateCart args = RequestCreateCart(
        productId: widget.productId,
        quantity: quantity,
        totalPrice: totalPrice,
      );

      try {
        await _cartService.createCart(args);
        scaffoldMessenger.showSnackBar(getSnackBar("해당 상품을 장바구니에 추가하였습니다."));
      } catch (err) {
        handleCartError(err);
      }
    }

    CreateCartDialog.show(
      context,
      product: product,
      createCallback: createCart,
    );
  }

  Widget getItemArea(String title, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border.all(width: 0.6, color: const Color.fromARGB(255, 210, 210, 210)),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
          child
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(color: const Color.fromARGB(255, 240, 240, 240)),
        title: const Text("Product Detail"),
      ),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: _getDetailProductFuture,
          builder: (BuildContext context, AsyncSnapshot<ResponseDetailProduct> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingHandlerWidget(title: "상품 상세 데이터 불러오기..");
            } else if (snapshot.hasError) {
              final error = snapshot.error;
              if (error is ConnectionError) {
                return NetworkErrorHandlerWidget(reconnectCallback: () {
                  setState(() {
                    _getDetailProductFuture = productService.getDetailProduct(widget.productId);
                  });
                });
              } else if (error is DioFailError) {
                return const InternalServerErrorHandlerWidget();
              } else {
                return Center(child: Text("$error"));
              }
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              return Scaffold(
                backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getItemArea("상품 이미지", ProductImageGridWidget(imageUrls: data.product.imageUrls)),
                            getItemArea(
                              "상품 정보",
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("이름: ${data.product.name}", style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 50, 50, 50))),
                                    Text("가격: ${formatNumber(data.product.price)}원", style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 50, 50, 50))),
                                    Text("원산지: ${data.product.origin}", style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 50, 50, 50))),
                                    Text("분류: ${data.product.category}", style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 50, 50, 50))),
                                    Text("설명: ${data.product.description}", style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 50, 50, 50))),
                                    Row(
                                      children: [
                                        const Text("평점: ", style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 50, 50, 50))),
                                        DisplayAverageScoreWidget(averageScore: data.product.averageScore),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            getItemArea(
                              "상품 리뷰",
                              SizedBox(
                                height: data.reviews.isEmpty ? 70 : 450,
                                child: data.reviews.isEmpty
                                    ? const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.warning, size: 18),
                                          SizedBox(width: 5),
                                          Text("아직 상품 리뷰가 존재하지 않습니다."),
                                        ],
                                      )
                                    : SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: data.reviews.asMap().entries.map((entry) {
                                            int index = entry.key;
                                            Review review = entry.value;
                                            EdgeInsets margin = index != data.reviews.length - 1 ? const EdgeInsets.fromLTRB(8, 8, 8, 0) : const EdgeInsets.fromLTRB(8, 8, 8, 8);
                                            return ReviewItemWidget(review: review, margin: margin);
                                          }).toList(),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: CommonButtonBarWidget(
                          icon: Icons.shopping_cart,
                          title: "장바구니 담기",
                          backgroundColor: Colors.blue,
                          pressCallback: () => pressCreateCart(data),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 1,
                        child: CommonButtonBarWidget(
                          icon: Icons.edit,
                          title: "리뷰 작성하기",
                          backgroundColor: const Color.fromARGB(255, 200, 200, 200),
                          pressCallback: () {},
                        ),
                      ),
                    ],
                  ),
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
