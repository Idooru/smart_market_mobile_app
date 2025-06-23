import 'dart:io';

enum MediaSource { file, server }

class FileSource {
  final File file;
  final MediaSource source;

  const FileSource({
    required this.file,
    required this.source,
  });
}
