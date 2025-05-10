import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_market/model/product/presentation/state/product_filtered.provider.dart';

class HighlightFilteredProductWidget extends StatefulWidget {
  final Text textWidget;

  const HighlightFilteredProductWidget({
    super.key,
    required this.textWidget,
  });

  @override
  State<HighlightFilteredProductWidget> createState() => _HighlightFilteredProductWidgetState();
}

class _HighlightFilteredProductWidgetState extends State<HighlightFilteredProductWidget> {
  bool _showShimmer = true;
  Timer? _shimmerTimer;

  late ProductFilteredProvider productFilteredProvider;

  @override
  void initState() {
    super.initState();
    _shimmerTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _showShimmer = false;
        });
        productFilteredProvider.clearFiltered();
      }
    });
  }

  @override
  void dispose() {
    _shimmerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    productFilteredProvider = context.watch<ProductFilteredProvider>();

    return _showShimmer
        ? Shimmer.fromColors(
            baseColor: Colors.yellow[700]!,
            highlightColor: Colors.red[700]!,
            child: widget.textWidget,
          )
        : widget.textWidget;
  }
}
