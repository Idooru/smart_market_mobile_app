import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 240, 240, 240),
);

final Container appBarColor = Container(
  color: const Color.fromARGB(255, 240, 240, 240), // 스크롤 될 시 색상 변경 방지
);

final BoxDecoration commonContainerDecoration = BoxDecoration(
  color: Colors.white,
  border: Border.all(width: 0.6, color: const Color.fromARGB(255, 210, 210, 210)),
  borderRadius: BorderRadius.circular(12),
);

final BoxDecoration searchBarDecoration = BoxDecoration(
  color: Colors.white,
  border: Border.all(width: 2, color: const Color.fromARGB(255, 210, 210, 210)),
  borderRadius: BorderRadius.circular(50),
);

const BoxDecoration searchHistoryDecoration = BoxDecoration(
  color: Colors.white,
  border: Border(
    bottom: BorderSide(
      color: Colors.grey, // 밑줄 색
      width: 0.2, // 밑줄 두께
    ),
  ),
);

const BoxDecoration searchResultDecoration = BoxDecoration(
  border: Border(
    bottom: BorderSide(
      color: Colors.grey, // 밑줄 색
      width: 0.2, // 밑줄 두께
    ),
  ),
);

final BoxDecoration quickButtonDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color: const Color.fromARGB(255, 200, 200, 200),
);
