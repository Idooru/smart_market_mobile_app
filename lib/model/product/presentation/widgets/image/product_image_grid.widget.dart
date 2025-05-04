import 'package:flutter/material.dart';

class ProductImageGridWidget extends StatefulWidget {
  final List<String> imageUrls;

  const ProductImageGridWidget({
    super.key,
    required this.imageUrls,
  });

  @override
  State<ProductImageGridWidget> createState() => _ProductImageGridWidgetState();
}

class _ProductImageGridWidgetState extends State<ProductImageGridWidget> {
  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.75,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: PageView(
        controller: pageController,
        children: widget.imageUrls
            .map(
              (url) => Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      url,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
