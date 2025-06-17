class MediaFile {
  final String id;
  final String whatHeader;
  final String url;
  final String fileName;

  const MediaFile({
    required this.id,
    required this.whatHeader,
    required this.url,
    required this.fileName,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "whatHeader": whatHeader,
      "url": url,
      "fileName": fileName,
    };
  }

  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      id: json["id"],
      whatHeader: json["whatHeader"],
      url: json["url"],
      fileName: json["fileName"],
    );
  }
}
