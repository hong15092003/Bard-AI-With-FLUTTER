
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ContentStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/content.json');
  }

  Future<String> readContent() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If enContenting an error, return 0
      return 'Error';
    }
  }

  Future<File> writeContent(final content) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$content');
  }
}
