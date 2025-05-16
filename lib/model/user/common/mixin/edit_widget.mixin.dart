import 'package:flutter/material.dart';

mixin EditWidget {
  Container getEditWidget(TextField textField) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 230, 230, 230),
      ),
      child: textField,
    );
  }

  TextStyle getInputTextStyle() {
    return const TextStyle(fontSize: 16, color: Color.fromARGB(255, 90, 90, 90));
  }

  Column getErrorArea(String errorMessage) {
    return Column(
      children: [
        Text(errorMessage, style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 10),
      ],
    );
  }

  InputDecoration getInputDecoration(IconData icon, bool isValid) {
    return InputDecoration(
      isDense: true,
      border: InputBorder.none,
      prefixIcon: Icon(icon, color: isValid ? Colors.green : Colors.red),
    );
  }
}
