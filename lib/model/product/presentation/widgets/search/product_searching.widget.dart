import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/widgets/common/custom_scrollbar.widget.dart';
import 'package:smart_market/core/widgets/handler/internal_server_error_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/network_error_handler.widget.dart';
import 'package:smart_market/model/product/domain/entities/search_product.entity.dart';
import 'package:smart_market/model/product/domain/service/product.service.dart';
import 'package:smart_market/model/product/presentation/state/product_filtered.provider.dart';
import 'package:smart_market/model/product/presentation/state/product_search.provider.dart';

class ProductSearchingWidget extends StatefulWidget {
  final void Function(String keyword, ProductSearchProvider searchProvider, ProductFilteredProvider filteredProvider, void Function(RequestSearchProducts) callback) search;
  final void Function(RequestSearchProducts args) updateProductList;

  const ProductSearchingWidget({
    super.key,
    required this.search,
    required this.updateProductList,
  });

  @override
  State<ProductSearchingWidget> createState() => _ProductSearchingWidgetState();
}

class _ProductSearchingWidgetState extends State<ProductSearchingWidget> {
  final ProductService productService = locator<ProductService>();
  late Future<List<String>> _getProductAutoCompleteFuture;

  List<TextSpan> highlightInitialMatch(String text, String keyword) {
    if (keyword.trim().isEmpty) return [TextSpan(text: text)];

    const int base = 0xAC00;
    const List<String> initialsList = ['ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'];

    final List<String> initials = [];
    final List<int> indexMap = [];

    // text에서 초성 리스트와 인덱스를 추출합니다.
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final code = char.codeUnitAt(0);
      if (code >= 0xAC00 && code <= 0xD7A3) {
        final offset = code - base;
        final choIdx = offset ~/ (21 * 28);
        initials.add(initialsList[choIdx]);
        indexMap.add(i);
      }
    }

    // keyword에서 공백을 제거한 후, 초성 문자열로 변환
    final keywordInitials = keyword.replaceAll(RegExp(r'\s+'), '');

    // text의 초성 리스트에서 keywordInitials를 찾습니다.
    final joinedInitials = initials.join();
    final matchIndex = joinedInitials.indexOf(keywordInitials);

    if (matchIndex == -1) return [TextSpan(text: text)];

    final matchLength = keywordInitials.length;
    final startTextIndex = indexMap[matchIndex];
    final endTextIndex = indexMap[matchIndex + matchLength - 1] + 1;

    return [
      TextSpan(text: text.substring(0, startTextIndex)),
      TextSpan(
        text: text.substring(startTextIndex, endTextIndex),
        style: const TextStyle(color: Colors.black),
      ),
      TextSpan(text: text.substring(endTextIndex)),
    ];
  }

  List<TextSpan> highlightKeyword(String text, String keyword) {
    if (keyword.isEmpty) return [TextSpan(text: text)];

    // 공백 제거한 버전
    String cleanText = text.replaceAll(RegExp(r'\s+'), '');
    String cleanKeyword = keyword.replaceAll(RegExp(r'\s+'), '');

    int matchIndex = cleanText.indexOf(cleanKeyword);
    if (matchIndex == -1) return [TextSpan(text: text)];

    // 원래 text의 인덱스 기준으로 강조할 범위 추적
    final List<TextSpan> spans = [];
    int cleanIndex = 0;
    int matchedChars = 0;
    bool isMatching = false;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (char.trim().isEmpty) {
        spans.add(TextSpan(text: char)); // 공백은 그대로 추가
        continue;
      }

      if (cleanIndex == matchIndex) {
        isMatching = true;
      }

      if (isMatching && matchedChars < cleanKeyword.length) {
        spans.add(TextSpan(
          text: char,
          style: const TextStyle(color: Colors.black),
        ));
        matchedChars++;
      } else {
        spans.add(TextSpan(text: char));
      }

      cleanIndex++;
      if (matchedChars == cleanKeyword.length) {
        isMatching = false;
      }
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductSearchProvider, ProductFilteredProvider>(
      builder: (BuildContext context, ProductSearchProvider searchProvider, ProductFilteredProvider filteredProvider, Widget? child) {
        _getProductAutoCompleteFuture = productService.getProductAutocomplete(searchProvider.keyword);

        return Expanded(
          child: ColoredBox(
            color: const Color.fromARGB(255, 235, 235, 235),
            child: FutureBuilder(
              future: _getProductAutoCompleteFuture,
              builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                } else if (snapshot.hasError) {
                  DioFailError error = snapshot.error as DioFailError;
                  if (error.message.contains("Timeout") || error.message.contains('Socket')) {
                    return NetworkErrorHandlerWidget(reconnectCallback: () {
                      setState(() {
                        _getProductAutoCompleteFuture = productService.getProductAutocomplete(searchProvider.keyword);
                      });
                    });
                  } else {
                    return const InternalServerErrorHandlerWidget();
                  }
                } else {
                  List<String> autoCompletes = snapshot.data!;
                  ScrollController scrollController = ScrollController();

                  return SizedBox(
                    width: double.infinity,
                    child: autoCompletes.isNotEmpty
                        ? CustomScrollbarWidget(
                            scrollController: scrollController,
                            childWidget: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: autoCompletes
                                    .map(
                                      (autoComplete) => GestureDetector(
                                        onTap: () => widget.search(autoComplete, searchProvider, filteredProvider, widget.updateProductList),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(255, 245, 245, 245),
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey, // 밑줄 색
                                                width: 0.2, // 밑줄 두께
                                              ),
                                            ),
                                          ),
                                          child: Text.rich(
                                            TextSpan(
                                              children: RegExp(r'^[ㄱ-ㅎ\s]+$').hasMatch(searchProvider.keyword)
                                                  ? highlightInitialMatch(autoComplete, searchProvider.keyword)
                                                  : highlightKeyword(autoComplete, searchProvider.keyword),
                                              style: const TextStyle(color: Color.fromARGB(255, 100, 100, 100)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          )
                        : const Center(
                            child: Text("해당 이름의 상품이 존재하지 않습니다."),
                          ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
