
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile(String fileName) async {
    final String path = await _localPath;
    return File('$path/$fileName');
  }

  static Future<File> writeText(List<String> textList, {
    required String fileName
  }) async {
    final File file = await _localFile(fileName);
    final String writeText = textList.join('\n\n');
    final File resultFile = await file.writeAsString(writeText, mode: FileMode.append);
    return resultFile;
  }

  static Future<void> clearWriteText({
    required String fileName
  }) async {
    final File file = await _localFile(fileName);
    await file.writeAsString('');
  }
}