import 'package:flutter/material.dart';

SnackBar getSnackBar(String message) {
  return SnackBar(
    content: Text(message),
    duration: const Duration(milliseconds: 2500),
  );
}
