import 'package:flutter/cupertino.dart';

abstract class AccessReviewItemWidget<T extends StatefulWidget> extends State<T> {
  Widget ReviewHeader({
    required String productName,
    required String subTitle,
    int? modifyCount,
  }) {
    return Container(
      height: 40,
      color: const Color.fromARGB(255, 250, 250, 250),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              productName,
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(width: 5),
            Text(
              subTitle,
              style: const TextStyle(color: Color.fromARGB(255, 90, 90, 90)),
            ),
          ],
        ),
      ),
    );
  }

  Widget ReviewBody({
    required void Function() unfocusCallback,
    required List<Widget> widgets,
  }) {
    return GestureDetector(
      onTap: unfocusCallback,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: widgets),
      ),
    );
  }
}
