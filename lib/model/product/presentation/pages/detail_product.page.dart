import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/get_snackbar.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/model/cart/domain/entities/create_cart.entity.dart';
import 'package:smart_market/model/cart/presentation/dialog/create_cart.dialog.dart';
import 'package:smart_market/model/product/domain/entities/detail_product.entity.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/widgets/display_average_score.widget.dart';
import 'package:smart_market/model/product/presentation/widgets/image/product_image_grid.widget.dart';
import 'package:smart_market/model/product/presentation/widgets/item/review_item.widget.dart';
import 'package:smart_market/model/user/utils/get_user_info.dart';

import '../../../../core/errors/connection_error.dart';
import '../../../../core/utils/check_jwt_duration.dart';
import '../../../../core/widgets/dialog/handle_network_error_on_dialog.dialog.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';
import '../../../cart/domain/service/cart.service.dart';
import '../../../user/presentation/dialog/invitation_login.dialog.dart';
import '../../../user/utils/check_is_logined.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("detail"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.all(20),
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
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "상품 이미지",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    ProductImageGridWidget(imageUrls: data.product.imageUrls),
                    const SizedBox(height: 5),
                    const Text(
                      "상품 정보",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("이름: ${data.product.name}", style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 50, 50, 50))),
                          Text("가격: ${data.product.price}", style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 50, 50, 50))),
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
                    const SizedBox(height: 15),
                    const Text(
                      "상품 리뷰",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      height: data.reviews.isEmpty ? 70 : 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: (() => data.reviews.isEmpty
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
                            ))(),
                    ),
                    getUserInfo().userRole != "admin"
                        ? Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 200, 200, 200),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 19,
                                          color: Color.fromARGB(255, 70, 70, 70),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "리뷰 작성하기",
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 70, 70, 70),
                                            fontSize: 17,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () => pressCreateCart(data),
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.shopping_cart,
                                          size: 19,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "장바구니 담기",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 5),
                  ],
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
