import 'package:flutter/material.dart';
import 'package:smart_market/core/utils/check_jwt_duration.dart';
import 'package:smart_market/model/order/common/const/default_request_order_args.dart';
import 'package:smart_market/model/order/presentation/widgets/order_item.widget.dart';

import '../../../../core/errors/connection_error.dart';
import '../../../../core/errors/dio_fail.error.dart';
import '../../../../core/themes/theme_data.dart';
import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/widgets/common/custom_scrollbar.widget.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/loading_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';
import '../../domain/entities/order.entity.dart';
import '../../domain/service/order.service.dart';
import '../dialog/order_filter.dialog.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrderService _orderService = locator<OrderService>();
  final ScrollController controller = ScrollController();
  late Future<List<ResponseOrders>> _getOrdersFuture;

  bool _hasFilterButton = false;

  @override
  void initState() {
    super.initState();
    _getOrdersFuture = initOrdersPage();
  }

  Future<List<ResponseOrders>> initOrdersPage() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await checkJwtDuration();

    return _orderService.fetchOrders(defaultRequestOrdersArgs);
  }

  void updateHasFilterButton(bool value) {
    if (_hasFilterButton == value) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _hasFilterButton = value;
      });
    });
  }

  void updateOrders(RequestOrders args) {
    setState(() {
      _getOrdersFuture = _orderService.fetchOrders(args);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ResponseOrders>>(
        future: _getOrdersFuture,
        builder: (BuildContext context, AsyncSnapshot<List<ResponseOrders>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingHandlerWidget(title: "결제 리스트 불러오기");
          } else if (snapshot.hasError) {
            updateHasFilterButton(false);
            final error = snapshot.error;
            if (error is ConnectionError) {
              return NetworkErrorHandlerWidget(reconnectCallback: () {
                updateOrders(defaultRequestOrdersArgs);
              });
            } else if (error is DioFailError) {
              return const InternalServerErrorHandlerWidget();
            } else {
              return Center(child: Text("$error"));
            }
          } else {
            List<ResponseOrders> orders = snapshot.data!;
            updateHasFilterButton(orders.isNotEmpty);
            return Scaffold(
              appBar: AppBar(
                title: const Text("My orders"),
                centerTitle: false,
                flexibleSpace: appBarColor,
                actions: [
                  _hasFilterButton
                      ? IconButton(
                          onPressed: () => OrderFilterDialog.show(context, updateCallback: updateOrders),
                          icon: const Icon(Icons.tune, color: Colors.black),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              body: CustomScrollbarWidget(
                scrollController: controller,
                childWidget: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: controller.hasClients ? 13 : 10,
                  ),
                  child: Builder(
                    builder: (context) {
                      if (orders.isNotEmpty) {
                        return ListView.builder(
                          controller: controller,
                          itemCount: orders.length,
                          itemBuilder: (context, index) => OrderItemWidget(
                            responseOrders: orders[index],
                            margin: index != orders.length - 1 ? const EdgeInsets.only(bottom: 10) : EdgeInsets.zero,
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            "구매 내역이 없습니다.",
                            style: TextStyle(
                              color: Color.fromARGB(255, 90, 90, 90),
                              fontSize: 15,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
