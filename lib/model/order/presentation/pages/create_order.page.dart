import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';
import 'package:smart_market/core/widgets/common/conditional_button_bar.widget.dart';
import 'package:smart_market/model/order/domain/service/order.service.dart';
import 'package:smart_market/model/order/presentation/provider/create_order.provider.dart';
import 'package:smart_market/model/order/presentation/widgets/select_delivery_option.widget.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';

import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/utils/get_snackbar.dart';
import '../../../user/presentation/widgets/edit/edit_address.widget.dart';
import '../../domain/entities/order.entity.dart';

class CreateOrderPageArgs {
  final String address;
  final void Function() updateCallback;

  const CreateOrderPageArgs({
    required this.address,
    required this.updateCallback,
  });
}

class CreateOrderPage extends StatefulWidget {
  final String address;
  final void Function() updateCallback;

  const CreateOrderPage({
    super.key,
    required this.address,
    required this.updateCallback,
  });

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> with NetWorkHandler {
  final OrderService _orderService = locator<OrderService>();
  final GlobalKey<SelectDeliveryOptionState> _optionKey = GlobalKey<SelectDeliveryOptionState>();
  final GlobalKey<EditAddressWidgetState> _addressKey = GlobalKey<EditAddressWidgetState>();

  bool _hasError = false;
  String _errorMessage = "";

  Future<void> pressCreateOrder() async {
    NavigatorState navigator = Navigator.of(context);
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    RequestOrder args = RequestOrder(
      deliveryOption: _optionKey.currentState!.selectedDeliveryOption,
      deliveryAddress: _addressKey.currentState!.addressController.text,
    );

    try {
      await _orderService.createOrder(args);
      widget.updateCallback();
      navigator.pop();
      scaffoldMessenger.showSnackBar(getSnackBar('결제 주문이 완료되었습니다.'));
    } catch (err) {
      setState(() {
        _hasError = true;
        _errorMessage = branchErrorMessage(err);
      });
    }
  }

  ConditionalButtonBarWidget getCreateOrderButton(CreateOrderProvider orderProvider, EditUserColumnProvider userProvider) {
    bool isAllValid = orderProvider.isDeliveryOptionValid && userProvider.isAddressValid;

    return ConditionalButtonBarWidget(
      title: '결제 주문하기',
      isValid: isAllValid,
      pressCallback: pressCreateOrder,
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
            flexibleSpace: Container(
              color: Colors.blueGrey[300], // 스크롤 될 시 색상 변경 방지
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
                  const SizedBox(height: 10),
                  getCreateOrderButton(orderProvider, userProvider),
                  const SizedBox(height: 20),
                  if (_hasError) getErrorMessageWidget(_errorMessage),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
