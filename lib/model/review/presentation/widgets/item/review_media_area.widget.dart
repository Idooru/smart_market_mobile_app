import 'package:flutter/material.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/model/media/presentation/provider/media.provider.dart';

import '../../../../../core/themes/theme_data.dart';

abstract class ReviewMediaWidgetState<T extends StatefulWidget> extends State<T> {
  Future<void> pressPickAlbum(MediaProvider provider);

  Widget Header({
    required String title,
    required String buttonText,
    required void Function() pressTakePicture,
    required MediaProvider provider,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      margin: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(title, style: const TextStyle(fontSize: 13)),
          ),
          const Spacer(),
          Row(
            children: [
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
                                onTap: () => pressPickAlbum(provider),
                                child: const ListTile(
                                  leading: Icon(Icons.photo),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(Icons.upload, size: 15),
                        const SizedBox(width: 5),
                        Text(buttonText),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget MediaFileShowcase({
    required double height,
    required int mediaLength,
    required bool isUploading,
    required String loadingTitle,
    required Widget Function(BuildContext, int) builderCallback,
  }) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: commonContainerDecoration,
      child: isUploading
          ? LoadingHandlerWidget(title: loadingTitle)
          : ListView.builder(
              itemCount: mediaLength,
              scrollDirection: Axis.horizontal,
              itemBuilder: builderCallback,
            ),
    );
  }

  Widget CancelButton(void Function() pressCallback) {
    return GestureDetector(
      onTap: pressCallback,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: const Center(
          child: Icon(
            Icons.cancel,
            color: Colors.red,
            size: 20,
          ),
        ),
      ),
    );
  }
}
