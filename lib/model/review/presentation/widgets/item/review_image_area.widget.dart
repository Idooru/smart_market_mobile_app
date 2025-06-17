import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/media/presentation/provider/media.provider.dart';
import 'package:smart_market/model/review/presentation/widgets/item/review_media_area.widget.dart';

import '../../../../media/presentation/dialog/expand_image.dialog.dart';
import '../../../../media/presentation/dialog/media_overflow.dialog.dart';
import '../../../../media/presentation/provider/review_image.provider.dart';

class ReviewImageAreaWidget extends StatefulWidget {
  const ReviewImageAreaWidget({super.key});

  @override
  State<ReviewImageAreaWidget> createState() => _ReviewImageAreaWidgetState();
}

class _ReviewImageAreaWidgetState extends ReviewMediaWidgetState<ReviewImageAreaWidget> {
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

    List<File> imageFiles = result.paths.map((path) => File(path!)).toList();

    if (imageFiles.length + provider.reviewImages.length > provider.maxCount) {
      MediaOverflowDialog.show(context, title: "이미지");
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
              title: "리뷰 이미지 (${provider.reviewImages.length}/${provider.maxCount})",
              pressTakePicture: () {
                if (provider.reviewImages.length >= provider.maxCount) {
                  MediaOverflowDialog.show(context, title: "이미지");
                } else {
                  Navigator.of(context).pushNamed("/photo_camera");
                }
              },
              provider: provider,
              buttonText: "이미지 업로드",
            ),
            MediaFileShowcase(
              height: 160,
              mediaLength: provider.reviewImages.length,
              isUploading: provider.isUploading,
              loadingTitle: "이미지 업로드 중..",
              builderCallback: (context, index) {
                File reviewImage = provider.reviewImages[index];
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => ExpandImageDialog.show(context, imageFile: reviewImage),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.file(
                            reviewImage,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => ExpandImageDialog.show(context, imageFile: reviewImage),
                      icon: const Icon(Icons.search, size: 50, color: Colors.white),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: CancelButton(() => provider.removeReviewImage(index)),
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
