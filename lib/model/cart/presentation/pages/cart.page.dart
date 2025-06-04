import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/connection_error.dart';
import 'package:smart_market/model/cart/domain/entities/cart.entity.dart';
import 'package:smart_market/model/cart/domain/service/cart.service.dart';
import 'package:smart_market/model/cart/presentation/widgets/cart_list.widget.dart';
import 'package:smart_market/model/user/domain/entities/profile.entity.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';

import '../../../../core/errors/dio_fail.error.dart';
import '../../../../core/errors/refresh_token_expired.error.dart';
import '../../../../core/utils/check_jwt_duration.dart';
import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/loading_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';
import '../../../account/domain/entities/account.entity.dart';
import '../../../account/domain/service/account.service.dart';
import '../../../user/presentation/dialog/force_logout.dialog.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = locator<CartService>();
  final UserService _userService = locator<UserService>();
  final AccountService _accountService = locator<AccountService>();
  final RequestAccounts defaultRequestAccountsArgs = const RequestAccounts(align: "DESC", column: "createdAt");
  late Future<Map<String, dynamic>> _cartPageFuture;

  @override
  void initState() {
    super.initState();
    _cartPageFuture = initCartPageFuture();
  }

  Future<Map<String, dynamic>> initCartPageFuture() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await checkJwtDuration();

    ResponseCarts carts = await _cartService.fetchCarts(const RequestCarts(align: "DESC", column: "createdAt"));
    ResponseProfile profile = await _userService.getProfile();
    List<ResponseAccount> accounts = await _accountService.getAccounts(defaultRequestAccountsArgs);

    return {
      "carts": carts,
      "address": profile.address,
      "accounts": accounts,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _cartPageFuture,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingHandlerWidget(title: "장바구니 목록 페이지 불러오기..");
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            if (error is ConnectionError) {
              return NetworkErrorHandlerWidget(reconnectCallback: () {
                setState(() {
                  _cartPageFuture = initCartPageFuture();
                });
              });
            }
            if (error is RefreshTokenExpiredError) {
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
            return Scaffold(
              appBar: AppBar(
                title: const Text("Cart List"),
                centerTitle: false,
                flexibleSpace: Container(
                  color: Colors.blueGrey[300],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: CartListWidget(
                  accounts: snapshot.data!["accounts"],
                  carts: snapshot.data!["carts"],
                  address: snapshot.data!["address"],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
