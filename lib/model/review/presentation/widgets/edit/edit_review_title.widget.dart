import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';
import 'package:smart_market/model/user/common/interface/edit_detector.interface.dart';

import '../../../../../core/common/input_widget.mixin.dart';
import '../../../../../core/themes/theme_data.dart';
import '../../provider/edit_review.provider.dart';

class EditReviewTitleWidget extends StatefulWidget {
  final String? beforeTitle;
  final bool isLastWidget;

  const EditReviewTitleWidget({
    super.key,
    this.beforeTitle,
    this.isLastWidget = false,
  });

  @override
  State<EditReviewTitleWidget> createState() => EditReviewTitleState();
}

class EditReviewTitleState extends EditWidgetState<EditReviewTitleWidget> with InputWidget implements EditDetector {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController reviewTitleController = TextEditingController();
  late EditReviewProvider _provider;

  bool _isValid = false;
  String _errorMessage = "";

  @override
  FocusNode get focusNode => _focusNode;

  @override
  void initState() {
    super.initState();
    _provider = context.read<EditReviewProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.setIsReviewTitleValid(_isValid);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    reviewTitleController.dispose();
    super.dispose();
  }

  @override
  void detectInput(String? _) {
    bool isValidLocal;
    String errorMessage;

    String reviewTitle = reviewTitleController.text;

    if (reviewTitle.isEmpty) {
      isValidLocal = false;
      errorMessage = "입력된 내용이 없습니다.";
    } else if (reviewTitle.length > 30) {
      isValidLocal = false;
      errorMessage = "길이가 30자를 넘어갑니다.";
    } else {
      isValidLocal = true;
      errorMessage = "";
    }

    setState(() {
      _isValid = isValidLocal;
      _errorMessage = errorMessage;
    });

    _provider.setIsReviewTitleValid(_isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: commonContainerDecoration,
          child: Row(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    "제목",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: reviewTitleController,
                  textInputAction: widget.isLastWidget ? TextInputAction.done : TextInputAction.next,
                  onChanged: detectInput,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        // if (!_isValid && _errorMessage.isNotEmpty) ErrorArea(_errorMessage)
      ],
    );
  }
}
