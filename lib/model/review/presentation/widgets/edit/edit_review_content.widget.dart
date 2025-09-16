import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/input_widget.mixin.dart';
import 'package:smart_market/core/widgets/common/focus_edit.widget.dart';

import '../../../../../core/themes/theme_data.dart';
import '../../../../user/common/interface/edit_detector.interface.dart';
import '../../provider/edit_review.provider.dart';

class EditReviewContentWidget extends StatefulWidget {
  final String? beforeContent;

  const EditReviewContentWidget({super.key, this.beforeContent});

  @override
  State<EditReviewContentWidget> createState() => EditReviewContentWidgetState();
}

class EditReviewContentWidgetState extends EditWidgetState<EditReviewContentWidget> with InputWidget implements EditDetector {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController reviewContentController = TextEditingController();
  late EditReviewProvider _provider;

  bool _isValid = false;
  String _errorMessage = "";

  @override
  FocusNode get focusNode => _focusNode;

  @override
  void initState() {
    super.initState();
    _provider = context.read<EditReviewProvider>();

    if (widget.beforeContent != null) {
      reviewContentController.text = widget.beforeContent!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.setIsReviewContentValid(_isValid);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    reviewContentController.dispose();
    super.dispose();
  }

  @override
  void detectInput(String? _) {
    bool isValidLocal;
    String errorMessage;

    String reviewContent = reviewContentController.text;

    if (reviewContent.isEmpty) {
      isValidLocal = false;
      errorMessage = "입력된 내용이 없습니다.";
    } else if (reviewContent.length > 300) {
      isValidLocal = false;
      errorMessage = "길이가 300자를 넘어갑니다.";
    } else {
      isValidLocal = true;
      errorMessage = "";
    }

    setState(() {
      _isValid = isValidLocal;
      _errorMessage = errorMessage;
    });

    if (widget.beforeContent == reviewContent) {
      _isValid = false;
    }

    _provider.setIsReviewContentValid(_isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 220,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: commonContainerDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "본문",
                style: TextStyle(fontSize: 14),
              ),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: reviewContentController,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  onChanged: detectInput,
                  minLines: null,
                  maxLines: null, // ← 중요: 줄 제한을 없앰
                  expands: true, // ← 중요: Expanded와 함께 사용해 전체 공간 채움
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Text(
                "입력 길이: (${reviewContentController.text.length}/300)",
                style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 130, 130, 130)),
              ),
            ],
          ),
        ),
        // if (!_isValid && _errorMessage.isNotEmpty) ErrorArea(_errorMessage)
      ],
    );
  }
}
