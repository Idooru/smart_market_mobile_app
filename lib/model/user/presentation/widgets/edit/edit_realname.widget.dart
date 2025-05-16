import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/user/common/interface/edit_detector.interface.dart';
import 'package:smart_market/model/user/common/mixin/edit_widget.mixin.dart';
import 'package:smart_market/model/user/presentation/state/edit_profile.provider.dart';

class EditRealNameWidget extends StatefulWidget {
  const EditRealNameWidget({super.key});

  @override
  State<EditRealNameWidget> createState() => EditRealNameWidgetState();
}

class EditRealNameWidgetState extends State<EditRealNameWidget> with EditWidget implements EditDetector {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController realNameController = TextEditingController();
  late EditProfileProvider _provider;

  bool _isValid = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _provider = context.read<EditProfileProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.setIsRealNameValid(_isValid);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    realNameController.dispose();
    super.dispose();
  }

  @override
  void detectInput(String? _) {
    bool isValidLocal;
    String errorMessage;

    String realName = realNameController.text;

    if (realName.isEmpty) {
      isValidLocal = false;
      errorMessage = "입력된 내용이 없습니다.";
    } else if (realName.length > 20) {
      isValidLocal = false;
      errorMessage = "길이가 20자를 넘어갑니다.";
    } else {
      isValidLocal = true;
      errorMessage = "";
    }

    setState(() {
      _isValid = isValidLocal;
      _errorMessage = errorMessage;
    });

    _provider.setIsRealNameValid(_isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle("이름"),
        getEditWidget(
          TextField(
            focusNode: _focusNode,
            controller: realNameController,
            textInputAction: TextInputAction.next,
            style: getInputTextStyle(),
            onChanged: detectInput,
            decoration: getInputDecoration(Icons.person, _isValid, "이름을 입력하세요."),
          ),
        ),
        if (!_isValid && _errorMessage.isNotEmpty) getErrorArea(_errorMessage)
      ],
    );
  }
}
