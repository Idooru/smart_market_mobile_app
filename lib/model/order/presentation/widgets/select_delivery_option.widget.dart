import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/input_widget.mixin.dart';
import 'package:smart_market/model/order/presentation/provider/create_order.provider.dart';

import '../../../../core/widgets/common/radio.widget.dart';

class SelectDeliveryOption extends StatefulWidget {
  const SelectDeliveryOption({super.key});

  @override
  State<SelectDeliveryOption> createState() => SelectDeliveryOptionState();
}

class SelectDeliveryOptionState extends State<SelectDeliveryOption> with InputWidget {
  late CreateOrderProvider provider;
  String selectedDeliveryOption = "default";

  @override
  void initState() {
    super.initState();
    provider = context.read<CreateOrderProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.setIsDeliveryOptionValid(true);
      provider.setSelectedDeliveryOption(selectedDeliveryOption);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle("배송 옵션"),
        getEditWidget(
          RadioGeneratorWidget(
            args: RadioGenerateArgs(
              title: "",
              radioWidgets: [
                RadioItemWidget(
                  optionTitle: "기본 배송",
                  value: "default",
                  groupValue: selectedDeliveryOption,
                  selectRadioCallback: (value) {
                    setState(() {
                      selectedDeliveryOption = value!;
                      provider.setSelectedDeliveryOption(selectedDeliveryOption);
                    });
                  },
                ),
                RadioItemWidget(
                  optionTitle: "신속 배송",
                  value: "speed",
                  groupValue: selectedDeliveryOption,
                  selectRadioCallback: (value) {
                    setState(() {
                      selectedDeliveryOption = value!;
                      provider.setSelectedDeliveryOption(selectedDeliveryOption);
                    });
                  },
                ),
                RadioItemWidget(
                  optionTitle: "안전 배송",
                  value: "safe",
                  groupValue: selectedDeliveryOption,
                  selectRadioCallback: (value) {
                    setState(() {
                      selectedDeliveryOption = value!;
                      provider.setSelectedDeliveryOption(selectedDeliveryOption);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
