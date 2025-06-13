import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:smart_market/core/common/input_widget.mixin.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/model/media/presentation/pages/camera.page.dart';

class EditReviewMediaWidget extends StatefulWidget {
  const EditReviewMediaWidget({super.key});

  @override
  State<EditReviewMediaWidget> createState() => EditReviewMediaWidgetState();
}

class EditReviewMediaWidgetState extends State<EditReviewMediaWidget> with InputWidget {
  List<File> reviewMedias = [];

  bool _isValid = false;
  String _errorMessage = "";

  Future<bool> appendMedia(File file) async {
    setState(() {
      reviewMedias = [...reviewMedias, file];
    });
    // for (int i = 0; i < receiptImageProvider.uploadedReceipts.length; i++) {
    //   String currentFile = extractFilename(receiptImageProvider.uploadedReceipts[i].path);
    //   String newFile = extractFilename(file.path);
    //
    //   if (currentFile == newFile) {
    //     return await showDuplicatedFileDialog(context);
    //   }
    // }

    return true;
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
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 60,
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
                                      onTap: () async {
                                        WidgetsFlutterBinding.ensureInitialized();
                                        NavigatorState navigator = Navigator.of(context);

                                        try {
                                          final cameras = await availableCameras();
                                          final firstCamera = cameras.first;

                                          navigator.pushNamed(
                                            "/camera",
                                            arguments: CameraPageArgs(
                                              camera: firstCamera,
                                              appendMedia: appendMedia,
                                            ),
                                          );
                                        } catch (err) {
                                          setState(() {
                                            _isValid = true;
                                            _errorMessage = err.toString();
                                          });
                                        }
                                      },
                                      child: const ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text("직접 촬영"),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
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
                              Icon(Icons.camera, size: 15),
                              SizedBox(width: 5),
                              Text("촬영"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!_isValid && _errorMessage.isNotEmpty) getErrorArea(_errorMessage)
      ],
    );
  }
}
