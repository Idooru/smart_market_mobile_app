import 'dart:io';

import 'package:flutter/material.dart';

class ExpandImageDialog {
  static void show(BuildContext context, {required File imageFile}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: ExpandImageDialogWidget(
            imageFile: imageFile,
          ),
        );
      },
    );
  }
}

class ExpandImageDialogWidget extends StatelessWidget {
  final File imageFile;

  const ExpandImageDialogWidget({
    super.key,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: InteractiveViewer(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            imageFile,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
