import 'package:flutter/material.dart';

class ProductSearchBarWidget extends StatelessWidget {
  final String title;
  final void Function() pressCallback;

  const ProductSearchBarWidget({
    super.key,
    required this.title,
    required this.pressCallback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pressCallback,
      child: Container(
        color: Colors.blueGrey[100],
        height: 45,
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 7, right: 12),
              child: Icon(Icons.search, color: Colors.black),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16, // TextField 내 텍스트 기본 폰트 크기와 일치시킴
                color: Colors.black87, // 일반 텍스트 색상
              ),
            )
          ],
        ),
      ),
    );
  }
}
