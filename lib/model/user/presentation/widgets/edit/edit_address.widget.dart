import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/input_widget.mixin.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';
import 'package:smart_market/core/common/validate.entity.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';
import 'package:smart_market/model/user/common/interface/edit_detector.interface.dart';
import 'package:smart_market/model/user/domain/service/user_validate.service.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';

class EditAddressWidget extends StatefulWidget {
  final String? beforeAddress;
  final bool isLastWidget;

  const EditAddressWidget({
    super.key,
    this.beforeAddress,
    this.isLastWidget = false,
  });

  @override
  State<EditAddressWidget> createState() => EditAddressWidgetState();
}

class EditAddressWidgetState extends EditWidgetState<EditAddressWidget> with InputWidget, NetWorkHandler implements EditDetector {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController addressController = TextEditingController();
  final UserValidateService _userValidateService = locator<UserValidateService>();
  late EditUserColumnProvider _provider;
  late bool _isValid;

  String _errorMessage = "";

  @override
  FocusNode get focusNode => _focusNode;

  @override
  void initState() {
    super.initState();
    _provider = context.read<EditUserColumnProvider>();
    _isValid = widget.beforeAddress != null;

    if (widget.beforeAddress != null) addressController.text = widget.beforeAddress!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.setIsAddressValid(_isValid);
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && addressController.text.isEmpty && widget.beforeAddress != null) {
        addressController.text = widget.beforeAddress!;
        setState(() {
          _isValid = true;
          _errorMessage = "";
        });

        _provider.setIsAddressValid(_isValid);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Future<void> detectInput(String? _) async {
    bool isValidLocal;
    String errorMessage;

    try {
      ResponseValidate result = await _userValidateService.validateAddress(
        beforeAddress: widget.beforeAddress,
        currentAddress: addressController.text,
      );

      isValidLocal = result.isValidate;
      errorMessage = result.message;
    } catch (err) {
      isValidLocal = false;
      errorMessage = branchErrorMessage(err);
    }

    setState(() {
      _isValid = isValidLocal;
      _errorMessage = errorMessage;
    });

    _provider.setIsAddressValid(_isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Titile("배송지"),
        EditWidget(
          TextField(
            focusNode: _focusNode,
            controller: addressController,
            textInputAction: widget.isLastWidget ? TextInputAction.done : TextInputAction.next,
            style: getInputStyle(),
            onChanged: detectInput,
            decoration: getInputDecoration(Icons.home, _isValid, "배송지를 입력하세요."),
          ),
        ),
        if (!_isValid && _errorMessage.isNotEmpty) Center(child: ErrorArea(_errorMessage)),
      ],
    );
  }
}
