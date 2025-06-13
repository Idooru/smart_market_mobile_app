import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/widgets/common/conditional_button_bar.widget.dart';
import 'package:smart_market/model/account/domain/entities/account.entity.dart';
import 'package:smart_market/model/cart/domain/service/cart.service.dart';
import 'package:smart_market/model/order/presentation/pages/complete_create_order.page.dart';
import 'package:smart_market/model/order/presentation/provider/create_order.provider.dart';
import 'package:smart_market/model/order/presentation/widgets/calculate_price.widget.dart';
import 'package:smart_market/model/order/presentation/widgets/select_delivery_option.widget.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';

import '../../../../core/utils/get_it_initializer.dart';
import '../../../cart/domain/entities/cart.entity.dart';
import '../../../user/presentation/widgets/edit/edit_address.widget.dart';
import '../../domain/entities/create_order.entity.dart';

class CreateOrderPageArgs {
  final String address;
  final bool isCreateCart;
  final void Function() updateCallback;
  final String backRoute;

  const CreateOrderPageArgs({
    required this.address,
    required this.isCreateCart,
    required this.updateCallback,
    required this.backRoute,
  });
}

class CreateOrderPage extends StatefulWidget {
  final String address;
  final bool isCreateCart;
  final void Function() updateCallback;
  final String backRoute;

  const CreateOrderPage({
    super.key,
    required this.address,
    required this.isCreateCart,
    required this.updateCallback,
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
      isCreateCart: widget.isCreateCart,
      updateCallback: widget.updateCallback,
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
                if (!widget.isCreateCart) {
                  final CartService cartService = locator<CartService>();
                  for (Cart cart in orderProvider.carts) {
                    cartService.deleteCart(cart.id);
                  }
                }
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
