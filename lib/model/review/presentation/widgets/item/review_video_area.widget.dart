import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/media/presentation/dialog/media_overflow.dialog.dart';
import 'package:smart_market/model/media/presentation/provider/media.provider.dart';
import 'package:smart_market/model/review/presentation/widgets/item/review_media_area.widget.dart';

import '../../../../media/presentation/provider/review_video.provider.dart';
import '../../../../product/presentation/pages/review_video_player.page.dart';

class ReviewVideoAreaWidget extends StatefulWidget {
  const ReviewVideoAreaWidget({super.key});

  @override
  State<ReviewVideoAreaWidget> createState() => ReviewVideoAreaWidgetState();
}

class ReviewVideoAreaWidgetState extends ReviewMediaWidgetState<ReviewVideoAreaWidget> {
  @override
  Future<void> pressPickAlbum(MediaProvider provider) async {
    provider = provider as ReviewVideoProvider;
    provider.setIsUploading(true);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
    );

    if (result == null) {
      return provider.setIsUploading(false);
    }

    List<File> videoFiles = result.paths.map((path) => File(path!)).toList();

    if (videoFiles.length + provider.reviewVideos.length > provider.maxCount) {
      MediaOverflowDialog.show(context, title: "비디오");
    } else {
      provider.appendReviewVideos(videoFiles);
    }

    provider.setIsUploading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewVideoProvider>(
      builder: (BuildContext context, ReviewVideoProvider provider, Widget? child) {
        return Column(
          children: [
            Header(
              title: "리뷰 비디오 (${provider.reviewVideos.length}/${provider.maxCount})",
              pressTakePicture: () {
                if (provider.reviewVideos.length >= provider.maxCount) {
                  MediaOverflowDialog.show(context, title: "비디오");
                } else {
                  Navigator.of(context).pushNamed("/video_camera");
                }
              },
              provider: provider,
              buttonText: "비디오 업로드",
            ),
            MediaFileShowcase(
              height: 120,
              mediaLength: provider.reviewVideos.length,
              isUploading: provider.isUploading,
              loadingTitle: "비디오 업로드 중..",
              builderCallback: (context, index) {
                File reviewVideo = provider.reviewVideos[index];
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          "/review_video_player",
                          arguments: ReviewVideoPlayerPageArgs(file: reviewVideo),
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              "/review_video_player",
                              arguments: ReviewVideoPlayerPageArgs(file: reviewVideo),
                            );
                          },
                          // onPressed: () => ExpandImageDialog.show(context, url: reviewVideo.url),
                          icon: const Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 3,
                      child: CancelButton(() => provider.removeReviewVideo(index)),
                    ),
                    // if (isDeleting) doing("비디오 삭제중.."),
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
