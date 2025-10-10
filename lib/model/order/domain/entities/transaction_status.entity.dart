import 'package:flutter/material.dart';

class TransactionStatus {
  final String text;
  final Color color;

  const TransactionStatus({
    required this.text,
    required this.color,
  });

  factory TransactionStatus.generate(String status) {
    if (status == "success") {
      return const TransactionStatus(
        text: "결제 완료",
        color: Colors.green,
      );
    } else {
      return const TransactionStatus(
        text: "결제 취소",
        color: Colors.red,
      );
    }
  }
}
