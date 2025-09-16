import 'package:flutter/material.dart';
import 'package:smart_market/core/themes/theme_data.dart';

mixin InputWidget {
  Padding Titile(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 3, bottom: 5),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }

  Container EditWidget(Widget widget) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: commonContainerDecoration,
      child: widget,
    );
  }

  TextStyle getInputStyle() {
    return const TextStyle(fontSize: 16, color: Color.fromARGB(255, 90, 90, 90));
  }

  Widget ErrorArea(List<String> errorMessages) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: errorMessages.map((message) => Text(message, style: const TextStyle(color: Colors.red))).toList(),
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
