import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/model/cart/domain/entities/cart_product.entity.dart';
import 'package:smart_market/model/cart/domain/entities/create_cart.entity.dart';
import 'package:smart_market/model/cart/presentation/dialog/create_cart.dialog.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/widgets/image/product_image_grid.widget.dart';

import '../../../../core/errors/connection_error.dart';
import '../../../../core/errors/refresh_token_expired.error.dart';
import '../../../../core/utils/check_jwt_duration.dart';
import '../../../../core/utils/format_number.dart';
import '../../../../core/utils/get_snackbar.dart';
import '../../../../core/widgets/dialog/handle_network_error_on_dialog.dialog.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';
import '../../../account/domain/entities/account.entity.dart';
import '../../../account/domain/service/account.service.dart';
import '../../../cart/domain/entities/cart.entity.dart';
import '../../../cart/domain/service/cart.service.dart';
import '../../../cart/presentation/dialog/pay_now.dialog.dart';
import '../../../user/domain/entities/profile.entity.dart';
import '../../../user/domain/service/user.service.dart';
import '../../../user/presentation/dialog/force_logout.dialog.dart';
import '../../../user/presentation/dialog/invitation_login.dialog.dart';
import '../../../user/utils/check_is_logined.dart';
import '../../domain/entities/detail_product.entity.dart';
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
  final UserService _userService = locator<UserService>();
  final AccountService _accountService = locator<AccountService>();
  final RequestAccounts defaultRequestAccountsArgs = const RequestAccounts(align: "DESC", column: "createdAt");
  late Future<Map<String, dynamic>> _detailProductPageFuture;

  @override
  void initState() {
    super.initState();
    _detailProductPageFuture = initDetailProductPageFuture();
  }

  Future<Map<String, dynamic>> initDetailProductPageFuture() async {
    await Future.delayed(const Duration(milliseconds: 500));
    bool isLogined = checkIsLogined();

    ResponseDetailProduct products = await productService.getDetailProduct(widget.productId);

    if (isLogined) {
      await checkJwtDuration();
      ResponseProfile profile = await _userService.getProfile();
      List<ResponseAccount> accounts = await _accountService.fetchAccounts(defaultRequestAccountsArgs);

      return {
        "products": products,
        "address": profile.address,
        "accounts": accounts,
      };
    }
    return {"products": products};
  }

  void handleCartError(Object err) {
    HandleNetworkErrorOnDialogDialog.show(context, err);
  }

  Future<void> pressCreateCart(ResponseDetailProduct responseDetailProduct) async {
    bool isLogined = checkIsLogined();
    if (!isLogined) return InvitationLoginDialog.show(context);

    await checkJwtDuration();

    Future<void> createCart({required int quantity, required int totalPrice}) async {
      ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
      NavigatorState navigator = Navigator.of(context);
      RequestCreateCart args = RequestCreateCart(
        productId: widget.productId,
        quantity: quantity,
        totalPrice: totalPrice,
      );

      try {
        await _cartService.createCart(args);
        scaffoldMessenger.showSnackBar(getSnackBar("해당 상품을 장바구니에 추가하였습니다."));
        navigator.pop();
      } catch (err) {
        handleCartError(err);
      }
    }

    CreateCartDialog.show(
      context,
      product: CartProduct(
        name: responseDetailProduct.product.name,
        price: responseDetailProduct.product.price,
      ),
      createCallback: createCart,
    );
  }

  Future<void> pressPayNow(
    ResponseDetailProduct responseDetailProduct,
    List<ResponseAccount> accounts,
    String address,
  ) async {
    await checkJwtDuration();

    Future<ResponseCarts?> payNow({required int quantity, required int totalPrice}) async {
      NavigatorState navigator = Navigator.of(context);
      RequestCreateCart createCartArgs = RequestCreateCart(
        productId: widget.productId,
        quantity: quantity,
        totalPrice: totalPrice,
      );

      RequestCarts fetchCartArgs = const RequestCarts(
        align: "DESC",
        column: "createdAt",
      );

      try {
        await _cartService.createCart(createCartArgs);
        navigator.pop();
        return _cartService.fetchCarts(fetchCartArgs);
      } catch (err) {
        handleCartError(err);
        return null;
      }
    }

    PayNowDialog.show(
      context,
      product: CartProduct(
        name: responseDetailProduct.product.name,
        price: responseDetailProduct.product.price,
      ),
      payNowCallback: payNow,
      address: address,
      accounts: accounts,
      backRoute: "/detail_product",
    );
  }

  Widget getItemArea(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 15),
            decoration: commonContainerDecoration,
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: appBarColor,
        title: const Text("Product Detail"),
      ),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: _detailProductPageFuture,
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingHandlerWidget(title: "상품 상세 데이터 불러오기..");
            } else if (snapshot.hasError) {
              final error = snapshot.error;
              if (error is ConnectionError) {
                return NetworkErrorHandlerWidget(reconnectCallback: () {
                  setState(() {
                    _detailProductPageFuture = initDetailProductPageFuture();
                  });
                });
              } else if (error is RefreshTokenExpiredError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ForceLogoutDialog.show(context);
                });
                return const SizedBox.shrink();
              } else if (error is DioFailError) {
                return const InternalServerErrorHandlerWidget();
              } else {
                return Center(child: Text("$error"));
              }
            } else {
              final data = snapshot.data!;
              ResponseDetailProduct responseDetailProduct = data["products"];

              return Scaffold(
                backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getItemArea("상품 이미지", ProductImageGridWidget(imageUrls: responseDetailProduct.product.imageUrls)),
                            getItemArea(
                              "상품 정보",
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("이름: ${responseDetailProduct.product.name}", style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 50, 50, 50))),
                                  Text("가격: ${formatNumber(responseDetailProduct.product.price)}원", style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 50, 50, 50))),
                                  Text("원산지: ${responseDetailProduct.product.origin}", style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 50, 50, 50))),
                                  Text("분류: ${responseDetailProduct.product.category}", style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 50, 50, 50))),
                                  Text("설명: ${responseDetailProduct.product.description}", style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 50, 50, 50))),
                                  Row(
                                    children: [
                                      const Text("평점: ", style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 50, 50, 50))),
                                      DisplayAverageScoreWidget(averageScore: responseDetailProduct.product.averageScore),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            getItemArea(
                              "상품 리뷰",
                              SizedBox(
                                height: responseDetailProduct.reviews.isEmpty ? 70 : 450,
                                child: responseDetailProduct.reviews.isEmpty
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
                                          children: responseDetailProduct.reviews.asMap().entries.map((entry) {
                                            int index = entry.key;
                                            Review review = entry.value;
                                            EdgeInsets margin = index != responseDetailProduct.reviews.length - 1 ? const EdgeInsets.fromLTRB(8, 8, 8, 0) : const EdgeInsets.fromLTRB(8, 8, 8, 8);
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
                          pressCallback: () => pressCreateCart(responseDetailProduct),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 1,
                        child: CommonButtonBarWidget(
                          icon: Icons.payment,
                          title: "바로 구매하기",
                          backgroundColor: Colors.orange,
                          pressCallback: () {
                            if (checkIsLogined()) {
                              pressPayNow(responseDetailProduct, data["accounts"], data["address"]);
                            } else {
                              InvitationLoginDialog.show(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
