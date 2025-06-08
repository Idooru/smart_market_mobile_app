import 'package:flutter/material.dart';
import 'package:smart_market/core/themes/theme_data.dart';

mixin InputWidget {
  Padding getTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 3, bottom: 5),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }

  Container getEditWidget(Widget widget) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: commonContainerDecoration,
      child: widget,
    );
  }

  TextStyle getInputTextStyle() {
    return const TextStyle(fontSize: 16, color: Color.fromARGB(255, 90, 90, 90));
  }

  Center getErrorArea(String errorMessage) {
    return Center(
      child: Column(
        children: [
          Text(errorMessage, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  InputDecoration getInputDecoration(IconData icon, bool isValid, String hintText) {
    return InputDecoration(
      isDense: true,
      border: InputBorder.none,
      prefixIcon: Icon(icon, color: isValid ? Colors.green : Colors.red),
      hintText: hintText,
    );
  }
}
