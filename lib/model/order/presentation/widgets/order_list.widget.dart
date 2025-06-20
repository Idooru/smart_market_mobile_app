import 'package:flutter/material.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/widgets/common/custom_scrollbar.widget.dart';
import 'package:smart_market/model/order/domain/entities/order.entity.dart';
import 'package:smart_market/model/order/domain/service/order.service.dart';
import 'package:smart_market/model/order/presentation/dialog/order_filter.dialog.dart';
import 'package:smart_market/model/order/presentation/widgets/order_item.widget.dart';

import '../../../../core/errors/connection_error.dart';
import '../../../../core/errors/dio_fail.error.dart';
import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/widgets/common/common_border.widget.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/loading_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';

class OrderListWidget extends StatefulWidget {
  final List<ResponseOrders> orders;

  const OrderListWidget({
    super.key,
    required this.orders,
  });

  @override
  State<OrderListWidget> createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  final OrderService _orderService = locator<OrderService>();
  final RequestOrders defaultRequestOrdersArgs = const RequestOrders(
    align: "DESC",
    column: "createdAt",
    deliveryOption: "none",
    transactionStatus: "none",
  );
  final ScrollController controller = ScrollController();

  late Future<List<ResponseOrders>> _getOrdersFuture;
  bool _isFirstRendering = true;
  bool _isShow = false;

  @override
  void initState() {
    super.initState();
    _getOrdersFuture = _orderService.fetchOrders(defaultRequestOrdersArgs);
  }

  void updateOrders(RequestOrders args) {
    setState(() {
      _getOrdersFuture = _orderService.fetchOrders(args);
    });
  }

  Widget getPageElement(List<ResponseOrders> orders) {
    return Column(
      children: [
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            setState(() {
              _isShow = !_isShow;
            });
          },
          child: Container(
            color: Colors.transparent,
            height: 30,
            child: Row(
              children: [
                const Text(
                  "내 결제 목록",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 5),
                Icon(
                  _isShow ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                  size: 22,
                ),
                const Spacer(),
                _isShow
                    ? GestureDetector(
                        onTap: () => OrderFilterDialog.show(context, updateCallback: updateOrders),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                          decoration: quickButtonDecoration,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.sort, size: 15),
                              Text("결제 정렬"),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        _isShow
            ? CustomScrollbarWidget(
                scrollController: controller,
                childWidget: Container(
                  padding: const EdgeInsets.only(right: 15),
                  margin: const EdgeInsets.only(bottom: 13),
                  height: 700,
                  child: ListView.builder(
                    controller: controller,
                    itemCount: orders.length,
                    itemBuilder: (context, index) => OrderItemWidget(
                      responseOrders: orders[index],
                      margin: index != orders.length - 1 ? const EdgeInsets.only(bottom: 13) : EdgeInsets.zero,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        const CommonBorder(color: Colors.grey),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isFirstRendering
        ? Builder(builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _isFirstRendering = false);
            return getPageElement(widget.orders);
          })
        : FutureBuilder(
            future: _getOrdersFuture,
            builder: (BuildContext context, AsyncSnapshot<List<ResponseOrders>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  children: [
                    SizedBox(height: 30),
                    LoadingHandlerWidget(title: "계좌 리스트 불러오기"),
                  ],
                );
              } else if (snapshot.hasError) {
                final error = snapshot.error;
                if (error is ConnectionError) {
                  return NetworkErrorHandlerWidget(reconnectCallback: () {
                    setState(() {
                      _getOrdersFuture = _orderService.fetchOrders(defaultRequestOrdersArgs);
                    });
                  });
                } else if (error is DioFailError) {
                  return const InternalServerErrorHandlerWidget();
                } else {
                  return Center(child: Text("$error"));
                }
              } else {
                return getPageElement(snapshot.data!);
              }
            },
          );
  }
}
