import 'package:flutter/material.dart';
import 'package:smart_market/model/media/domain/entities/file_source.entity.dart';

class ExpandImageDialog {
  static void show(
    BuildContext context, {
    required FileSource imageFile,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: ExpandImageDialogWidget(imageFile: imageFile),
        );
      },
    );
  }
}

class ExpandImageDialogWidget extends StatelessWidget {
  final FileSource imageFile;

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
          child: imageFile.source == MediaSource.file
              ? Image.file(
                  imageFile.file,
                  fit: BoxFit.contain,
                )
              : Image.network(
                  imageFile.file.path,
                  fit: BoxFit.fill,
                ),
        ),
      ),
    );
  }
}
