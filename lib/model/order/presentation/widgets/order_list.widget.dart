import 'package:flutter/material.dart';
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
  final RequestOrders defaultRequestOrdersArgs = const RequestOrders(align: "DESC", column: "createdAt");
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
        SizedBox(
          width: double.infinity,
          height: 30,
          child: Stack(
            children: [
              const Positioned(
                child: Text(
                  "내 결제 목록",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
              Positioned(
                top: -10,
                left: 93,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isShow = !_isShow;
                    });
                  },
                  icon: Icon(_isShow ? Icons.arrow_drop_down : Icons.arrow_drop_up),
                ),
              ),
              Positioned(
                right: 0,
                child: _isShow
                    ? GestureDetector(
                        onTap: () => OrderFilterDialog.show(context, updateCallback: updateOrders),
                        child: Container(
                          width: 90,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 230, 230, 230),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.sort, size: 15),
                              Text("결제 정렬"),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        _isShow
            ? Column(
                children: orders
                    .map(
                      (order) => OrderItemWidget(responseOrders: order),
                    )
                    .toList(),
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
