import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_market/core/common/input_widget.mixin.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/utils/split_host_url.dart';
import 'package:smart_market/model/media/domain/entities/media_file.entity.dart';

import '../../../../../core/utils/get_it_initializer.dart';
import '../../../../media/domain/service/media.service.dart';

class EditReviewMediaWidget extends StatefulWidget {
  const EditReviewMediaWidget({super.key});

  @override
  State<EditReviewMediaWidget> createState() => EditReviewMediaWidgetState();
}

class EditReviewMediaWidgetState extends State<EditReviewMediaWidget> with InputWidget {
  final MediaService _mediaService = locator<MediaService>();
  bool _isValid = false;
  String _errorMessage = "";
  List<MediaFile> _reviewImages = [];
  List<MediaFile> _reviewVideos = [];

  Future<void> pressTakePicture() async {
    Object? result = await Navigator.of(context).pushNamed("/camera");
    if (result == true) {
      List<MediaFile> reviewImages = await _mediaService.fetchReviewImages();

      setState(() {
        _reviewImages = [..._reviewImages, ...reviewImages];
      });
    }
  }

  Future<void> pressPickAlbum() async {
    try {
      (await ImagePicker().pickMultiImage(limit: 5)).map((xfile) => File(xfile.path)).forEach((image) {
        // uploadMedia(image);
      });
    } catch (err) {
      setState(() {
        _isValid = true;
        _errorMessage = err.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: commonContainerDecoration,
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "미디어 첨부",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                            builder: (context) {
                              return SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: pressTakePicture,
                                      child: const ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text("직접 촬영"),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: pressPickAlbum,
                                      child: const ListTile(
                                        leading: Icon(Icons.photo_album_outlined),
                                        title: Text("엘범에서 가져오기"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 30,
                          decoration: quickButtonDecoration,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.upload, size: 15),
                              SizedBox(width: 5),
                              Text("파일 업로드"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 160,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: commonContainerDecoration,
                child: ListView.builder(
                  itemCount: _reviewImages.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    MediaFile mediaFile = _reviewImages[index];
                    return Container(
                      padding: const EdgeInsets.all(5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          splitHostUrl(mediaFile.url),
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                height: 160,
                decoration: commonContainerDecoration,
              ),
            ],
          ),
        ),
        if (!_isValid && _errorMessage.isNotEmpty) getErrorArea(_errorMessage)
      ],
    );
  }
}
