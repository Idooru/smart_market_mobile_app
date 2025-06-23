import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/media/domain/entities/file_source.entity.dart';
import 'package:smart_market/model/media/presentation/dialog/media_overflow.dialog.dart';
import 'package:smart_market/model/media/presentation/provider/media.provider.dart';
import 'package:smart_market/model/review/presentation/widgets/item/review_media_area.widget.dart';

import '../../../../media/presentation/provider/review_video.provider.dart';
import '../../../../product/presentation/pages/review_video_player.page.dart';

class ReviewVideoAreaWidget extends StatefulWidget {
  final ReviewVideoProvider provider;
  final List<String>? beforeVideoUrls;

  const ReviewVideoAreaWidget({
    super.key,
    required this.provider,
    this.beforeVideoUrls,
  });

  @override
  State<ReviewVideoAreaWidget> createState() => ReviewVideoAreaWidgetState();
}

class ReviewVideoAreaWidgetState extends ReviewMediaWidgetState<ReviewVideoAreaWidget> {
  @override
  void initState() {
    super.initState();

    if (widget.beforeVideoUrls != null) {
      List<FileSource> beforeReviewVideos = widget.beforeVideoUrls!
          .map((url) => File(url))
          .map((file) => FileSource(
                file: file,
                source: MediaSource.server,
              ))
          .toList();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.provider.appendReviewVideos(beforeReviewVideos);
      });
    }
  }

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

    List<FileSource> videoFiles = result.paths
        .map((path) => File(path!))
        .map((file) => FileSource(
              file: file,
              source: MediaSource.file,
            ))
        .toList();

    if (videoFiles.length + provider.reviewVideos.length > provider.maxCount) {
      MediaOverflowDialog.show(context, title: "비디오");
    } else {
      provider.appendReviewVideos(videoFiles);
    }

    provider.setIsUploading(false);
  }

  void navigateVideoPlayerPage(FileSource reviewVideo) {
    // ReviewVideoPlayerPageArgs args = widget.source == VideoSource.file ? ReviewVideoPlayerPageArgs(file: reviewVideo) : ReviewVideoPlayerPageArgs(url: reviewVideo.path);
    Navigator.of(context).pushNamed("/review_video_player", arguments: reviewVideo);
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
                FileSource reviewVideo = provider.reviewVideos[index];
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => navigateVideoPlayerPage(reviewVideo),
                      child: Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: IconButton(
                          onPressed: () => navigateVideoPlayerPage(reviewVideo),
                          icon: const Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 3,
                      child: CancelButton(() => provider.removeReviewVideo(index)),
                    ),
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
