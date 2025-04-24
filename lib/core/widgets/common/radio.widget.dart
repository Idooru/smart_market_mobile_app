import 'package:flutter/material.dart';

class RadioGenerateArgs {
  final String title;
  final List<RadioItemWidget> radioWidgets;

  const RadioGenerateArgs({
    required this.title,
    required this.radioWidgets,
  });
}

class RadioGeneratorWidget extends StatefulWidget {
  final RadioGenerateArgs args;

  const RadioGeneratorWidget({
    super.key,
    required this.args,
  });

  @override
  State<RadioGeneratorWidget> createState() => _RadioGeneratorWidgetState();
}

class _RadioGeneratorWidgetState extends State<RadioGeneratorWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose(); // 메모리 누수 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.args.title,
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: SingleChildScrollView(
            // controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(children: widget.args.radioWidgets),
          ),
        )
      ],
    );
  }
}

class RadioItemWidget extends StatelessWidget {
  final String optionTitle;
  final String value;
  final String? groupValue;
  final void Function(String?) selectRadioCallback;

  const RadioItemWidget({
    super.key,
    required this.optionTitle,
    required this.value,
    required this.groupValue,
    required this.selectRadioCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: selectRadioCallback,
            activeColor: Colors.blueGrey,
          ),
        ),
        Text(
          optionTitle,
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(width: 15)
      ],
    );
  }
}
