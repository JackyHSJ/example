import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageCompressUtil {
  static Future<File?> compressFile(File file, {int quality = 90, int targetSizeKb = 1024, int minQuality = 10}) async {
    final dir = file.parent;
    final uuid = Uuid().v4();
    final targetPath = dir.absolute.path + "/$uuid.jpg";

    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
    );

    // Check if the file size is smaller than target size
    final File resultFile = File(result!.path);

    final fileLength = resultFile.lengthSync() / 1024; // length in Kb
    if(fileLength < targetSizeKb || quality <= minQuality) {
      return resultFile;
    } else {
      // Reduce quality and compress again
      return compressFile(file, quality: quality - 10, targetSizeKb: targetSizeKb, minQuality: minQuality);
    }
  }

  static Future<Uint8List> compressBytes(Uint8List data) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp.jpg');
    await tempFile.writeAsBytes(data);

    /// WeChat thumb data size limit is 32KB
    final compressedFile = await ImageCompressUtil.compressFile(
      tempFile,
      quality: 90,
      targetSizeKb: 32,
      minQuality: 10,
    );

    // Read the compressed image data back into a Uint8List
    final compressedImageData = await compressedFile!.readAsBytes();

    // Clean up: delete the temporary file
    await tempFile.delete();

    return compressedImageData;
  }
}
