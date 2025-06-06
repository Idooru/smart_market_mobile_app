import 'package:flutter/material.dart';

import '../../../../core/widgets/common/radio.widget.dart';
import '../../domain/entities/order.entity.dart';

final Map<String, String> _filterMap = {};

class OrderFilterDialog {
  static void show(BuildContext context, {required void Function(RequestOrders args) updateCallback}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: OrderFilterDialogWidget(updateCallback: updateCallback),
      ),
    );
  }
}

class OrderFilterDialogWidget extends StatefulWidget {
  final void Function(RequestOrders args) updateCallback;

  const OrderFilterDialogWidget({
    super.key,
    required this.updateCallback,
  });

  @override
  State<OrderFilterDialogWidget> createState() => _OrderFilterDialogState();
}

class _OrderFilterDialogState extends State<OrderFilterDialogWidget> {
  String _selectedAlign = _filterMap["select-align"] ?? "DESC";
  String _selectedColumn = _filterMap["select-column"] ?? "createdAt";
  String _selectedDeliveryOption = _filterMap["select-delivery-option"] ?? "none";
  String _selectedTransactionStatus = _filterMap["select-transaction-status"] ?? "none";

  void initFilterMap() {
    setState(() {
      _selectedAlign = "DESC";
      _selectedColumn = "createdAt";
      _selectedDeliveryOption = "none";
      _selectedTransactionStatus = "none";
    });
  }

  void filterOrder() {
    RequestOrders args = RequestOrders(
      align: _selectedAlign,
      column: _selectedColumn,
      deliveryOption: _selectedDeliveryOption,
      transactionStatus: _selectedTransactionStatus,
    );

    widget.updateCallback(args);

    _filterMap["select-align"] = _selectedAlign;
    _filterMap["select-column"] = _selectedColumn;
    _filterMap["select-delivery-option"] = _selectedDeliveryOption;
    _filterMap["select-transaction-status"] = _selectedTransactionStatus;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 333,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
            child: Center(
              child: Text(
                "결제 내역 필터링",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  RadioGeneratorWidget(
                    args: RadioGenerateArgs(
                      title: "순서",
                      radioWidgets: [
                        RadioItemWidget(
                          optionTitle: "낮은순",
                          value: "ASC",
                          groupValue: _selectedAlign,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedAlign = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "높은순",
                          value: "DESC",
                          groupValue: _selectedAlign,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedAlign = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  RadioGeneratorWidget(
                    args: RadioGenerateArgs(
                      title: "기준",
                      radioWidgets: [
                        RadioItemWidget(
                          optionTitle: "생성일",
                          value: "createdAt",
                          groupValue: _selectedColumn,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedColumn = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "총합 금액",
                          value: "totalPrice",
                          groupValue: _selectedColumn,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedColumn = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  RadioGeneratorWidget(
                    args: RadioGenerateArgs(
                      title: "배송 옵션",
                      radioWidgets: [
                        RadioItemWidget(
                          optionTitle: "없음",
                          value: "none",
                          groupValue: _selectedDeliveryOption,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedDeliveryOption = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "기본",
                          value: "default",
                          groupValue: _selectedDeliveryOption,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedDeliveryOption = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "신속 배송",
                          value: "speed",
                          groupValue: _selectedDeliveryOption,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedDeliveryOption = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "안전 배송",
                          value: "safe",
                          groupValue: _selectedDeliveryOption,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedDeliveryOption = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  RadioGeneratorWidget(
                    args: RadioGenerateArgs(
                      title: "주문 상태",
                      radioWidgets: [
                        RadioItemWidget(
                          optionTitle: "없음",
                          value: "none",
                          groupValue: _selectedTransactionStatus,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedTransactionStatus = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "성공",
                          value: "success",
                          groupValue: _selectedTransactionStatus,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedTransactionStatus = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "실패",
                          value: "fail",
                          groupValue: _selectedTransactionStatus,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedTransactionStatus = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "보류",
                          value: "hold",
                          groupValue: _selectedTransactionStatus,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedTransactionStatus = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: initFilterMap,
                    child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 180, 180, 180),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "필터링 초기화",
                          style: TextStyle(
                            color: Color.fromARGB(255, 70, 70, 70),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      color: Color.fromARGB(255, 70, 70, 70),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  onPressed: filterOrder,
                  child: const Text(
                    '찾기',
                    style: TextStyle(
                      color: Color.fromARGB(255, 70, 70, 70),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
