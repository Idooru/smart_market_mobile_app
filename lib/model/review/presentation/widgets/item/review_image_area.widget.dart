import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/media/domain/entities/file_source.entity.dart';
import 'package:smart_market/model/media/presentation/provider/media.provider.dart';
import 'package:smart_market/model/review/presentation/widgets/item/review_media_area.widget.dart';

import '../../../../media/presentation/dialog/expand_image.dialog.dart';
import '../../../../media/presentation/dialog/media_overflow.dialog.dart';
import '../../../../media/presentation/provider/review_image.provider.dart';

class ReviewImageAreaWidget extends StatefulWidget {
  final ReviewImageProvider provider;
  final List<String>? beforeImageUrls;

  const ReviewImageAreaWidget({
    super.key,
    required this.provider,
    this.beforeImageUrls,
  });

  @override
  State<ReviewImageAreaWidget> createState() => _ReviewImageAreaWidgetState();
}

class _ReviewImageAreaWidgetState extends ReviewMediaWidgetState<ReviewImageAreaWidget> {
  @override
  void initState() {
    super.initState();

    if (widget.beforeImageUrls != null) {
      try {
        List<FileSource> beforeReviewImages = widget.beforeImageUrls!
            .map((url) => File(url))
            .map((file) => FileSource(
                  file: file,
                  source: MediaSource.server,
                ))
            .toList();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.provider.appendReviewImages(beforeReviewImages);
        });
      } catch (err) {
        debugPrint("뭥미: $err");
      }
    }
  }

  @override
  Future<void> pressPickAlbum(MediaProvider provider) async {
    provider = provider as ReviewImageProvider;
    provider.setIsUploading(true);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result == null) {
      return provider.setIsUploading(false);
    }

    List<FileSource> imageFiles = result.paths
        .map((path) => File(path!))
        .map((file) => FileSource(
              file: file,
              source: MediaSource.file,
            ))
        .toList();

    if (imageFiles.length + provider.reviewImages.length > provider.maxCount) {
      MediaOverflowDialog.show(context, title: "이미지 업로드 개수를_ 초과하였습니다.");
    } else {
      provider.appendReviewImages(imageFiles);
    }

    provider.setIsUploading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewImageProvider>(
      builder: (BuildContext context, ReviewImageProvider provider, Widget? child) {
        return Column(
          children: [
            Header(
              title: "리뷰 이미지 (${widget.provider.reviewImages.length}/${widget.provider.maxCount})",
              pressTakePicture: () {
                if (widget.provider.reviewImages.length >= widget.provider.maxCount) {
                  MediaOverflowDialog.show(context, title: "이미지 업로드 개수를_ 초과하였습니다.");
                } else {
                  Navigator.of(context).pushNamed("/photo_camera");
                }
              },
              provider: widget.provider,
              buttonText: "이미지 업로드",
            ),
            MediaFileShowcase(
              height: 160,
              mediaLength: widget.provider.reviewImages.length,
              isUploading: widget.provider.isUploading,
              loadingTitle: "이미지 업로드 중..",
              builderCallback: (context, index) {
                FileSource reviewImage = provider.reviewImages[index];
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => ExpandImageDialog.show(
                        context,
                        imageFile: reviewImage,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: reviewImage.source == MediaSource.file
                              ? Image.file(
                                  reviewImage.file,
                                  fit: BoxFit.fill,
                                )
                              : Image.network(
                                  reviewImage.file.path,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => ExpandImageDialog.show(
                        context,
                        imageFile: reviewImage,
                      ),
                      icon: const Icon(Icons.search, size: 50, color: Colors.white),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: CancelButton(() => widget.provider.removeReviewImage(index)),
                    ),
                    // if (_deletingImageId == reviewImage.id) doing("이미지 삭제중.."),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
