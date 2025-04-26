import 'package:flutter/material.dart';

class CustomScrollbarWidget extends StatelessWidget {
  final ScrollController scrollController;
  final Widget childWidget;

  const CustomScrollbarWidget({
    super.key,
    required this.scrollController,
    required this.childWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 5, // 스크롤바 두께
      radius: const Radius.circular(10), // 스크롤바 모서리 둥글기
      thumbVisibility: true, // 항상 보이도록 (원하면 false로 변경 가능)
      interactive: true,
      trackVisibility: true, // 스크롤 트랙 표시
      scrollbarOrientation: ScrollbarOrientation.right,
      controller: scrollController,
      child: childWidget,
    );
  }
}
