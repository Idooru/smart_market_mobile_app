import 'package:flutter/material.dart';
import 'package:smart_market/model/media/domain/entities/file_source.entity.dart';

class ExpandImageDialog {
  static void show(
    BuildContext context, {
    required FileSource imageFile,
    required List<FileSource> imageFiles,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: ExpandImageDialogWidget(
            imageFile: imageFile,
            imageFiles: imageFiles,
          ),
        );
      },
    );
  }
}

class ExpandImageDialogWidget extends StatefulWidget {
  final FileSource imageFile;
  final List<FileSource> imageFiles;

  const ExpandImageDialogWidget({
    super.key,
    required this.imageFile,
    required this.imageFiles,
  });

  @override
  State<ExpandImageDialogWidget> createState() => _ExpandImageDialogWidgetState();
}

class _ExpandImageDialogWidgetState extends State<ExpandImageDialogWidget> {
  late PageController _pageController;
  late int _initialPage;

  @override
  void initState() {
    super.initState();
    _initialPage = widget.imageFiles.indexOf(widget.imageFile);
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageFiles.length,
        itemBuilder: (context, index) {
          final fileSource = widget.imageFiles[index];
          return InteractiveViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: fileSource.source == MediaSource.file
                  ? Image.file(
                      fileSource.file,
                      fit: BoxFit.contain,
                    )
                  : Image.network(
                      fileSource.file.path,
                      fit: BoxFit.contain,
                    ),
            ),
          );
        },
      ),
    );
  }
}
