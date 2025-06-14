class MediaFile {
  final String id;
  final String url;
  final int size;

  const MediaFile({
    required this.id,
    required this.url,
    required this.size,
  });

  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      id: json["id"],
      url: json["url"],
      size: json["size"],
    );
  }
}
