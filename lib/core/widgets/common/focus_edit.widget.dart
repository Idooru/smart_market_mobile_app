import 'package:flutter/material.dart';

abstract class EditWidgetState<T extends StatefulWidget> extends State<T> {
  FocusNode get focusNode;
}

class FocusEditWidget<T extends EditWidgetState> extends StatefulWidget {
  final GlobalKey<T> editWidgetKey;
  final Widget editWidget;

  const FocusEditWidget({
    super.key,
    required this.editWidgetKey,
    required this.editWidget,
  });

  @override
  State<FocusEditWidget> createState() => _FocusEditWidgetState();
}

class _FocusEditWidgetState extends State<FocusEditWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.editWidgetKey.currentState!.focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.editWidget;
  }
}
