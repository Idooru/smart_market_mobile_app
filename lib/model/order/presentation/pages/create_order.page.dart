import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/widgets/common/conditional_button_bar.widget.dart';
import 'package:smart_market/model/account/domain/entities/account.entity.dart';
import 'package:smart_market/model/order/presentation/pages/complete_create_order.page.dart';
import 'package:smart_market/model/order/presentation/provider/create_order.provider.dart';
import 'package:smart_market/model/order/presentation/widgets/calculate_price.widget.dart';
import 'package:smart_market/model/order/presentation/widgets/select_delivery_option.widget.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';

import '../../../../core/utils/get_it_initializer.dart';
import '../../../cart/domain/entities/cart.entity.dart';
import '../../../cart/domain/service/cart.service.dart';
import '../../../user/presentation/widgets/edit/edit_address.widget.dart';
import '../../domain/entities/create_order.entity.dart';

class CreateOrderPageArgs {
  final String address;
  final String? backRoute;

  const CreateOrderPageArgs({
    required this.address,
    this.backRoute,
  });
}

class CreateOrderPage extends StatefulWidget {
  final String address;
  final String? backRoute;

  const CreateOrderPage({
    super.key,
    required this.address,
    required this.backRoute,
  });

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final GlobalKey<SelectDeliveryOptionState> _optionKey = GlobalKey<SelectDeliveryOptionState>();
  final GlobalKey<EditAddressWidgetState> _addressKey = GlobalKey<EditAddressWidgetState>();
  late CreateOrderProvider provider;

  @override
  void initState() {
    super.initState();
    provider = context.read<CreateOrderProvider>();
  }

  @override
  void dispose() {
    provider.clearAll();
    super.dispose();
  }

  Future<void> pressCreateOrder(List<Cart> carts) async {
    RequestCreateOrder requestCreateOrderArgs = RequestCreateOrder(
      deliveryOption: _optionKey.currentState!.selectedDeliveryOption,
      deliveryAddress: _addressKey.currentState!.addressController.text,
    );

    CompleteCreateOrderPageArgs successCreateOrderPageArgs = CompleteCreateOrderPageArgs(
      args: requestCreateOrderArgs,
      carts: carts,
      backRoute: widget.backRoute,
    );

    Navigator.of(context).pushNamed("/complete_create_order", arguments: successCreateOrderPageArgs);
  }

  ConditionalButtonBarWidget getCreateOrderButton(CreateOrderProvider orderProvider, EditUserColumnProvider userProvider) {
    ResponseAccount mainAccount = orderProvider.accounts.firstWhere((account) => account.isMainAccount);
    bool isSatisfiedBalance = mainAccount.balance >= orderProvider.cartTotalPrice;
    bool isAllValid = (orderProvider.isDeliveryOptionValid && userProvider.isAddressValid) && isSatisfiedBalance;

    return ConditionalButtonBarWidget(
      title: '결제 주문하기',
      isValid: isAllValid,
      pressCallback: () => pressCreateOrder(orderProvider.carts),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CreateOrderProvider, EditUserColumnProvider>(
      builder: (BuildContext context, CreateOrderProvider orderProvider, EditUserColumnProvider userProvider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Create Order"),
            centerTitle: false,
            flexibleSpace: appBarColor,
            leading: IconButton(
              onPressed: () {
                /* 상품 상세 페이지에서 즉시 구매로 넘어온 경우 이전 페이지로 뒤돌아갈 backRoute가 담김
                 * 이를 조건으로 상품 상세 페이지에서 담긴 상품인지, 장바구니 리스트 페이지에서 담긴 상품인지 구별함
                 * 즉시 구매로 장바구니에 담은 상품이 이 페이지를 나가서 존재할 필요가 없으므로
                 * 즉시 구매로 장바구니에 담은 상품을 제거함
                 */
                if (widget.backRoute != null) {
                  CartService cartService = locator<CartService>();
                  for (Cart cart in orderProvider.carts) {
                    cartService.deleteCart(cart.id);
                  }
                }

                /* 반대의 경우는 장바구니 리스트 페이지에서 넘어온 경우
                 * 사용자가 구매를 미루려는 의도로 페이지를 나갈 수 있으니
                 * 굳이 장바구니에 담은 상품을 제거 할 필요 없음
                 */
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  SelectDeliveryOption(key: _optionKey),
                  EditAddressWidget(beforeAddress: widget.address, key: _addressKey, isLastWidget: true),
                  const SizedBox(height: 5),
                  const CalculatePriceWidget(),
                  const SizedBox(height: 10),
                  getCreateOrderButton(orderProvider, userProvider),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
