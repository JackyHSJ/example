import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frechat/system/util/video_compress_util.dart';
import 'package:path/path.dart' as pathUtil;
import 'image_compress_util.dart';

class FormDataUtil {
  static Future<FormData> toFormData({required Map<String, dynamic> toJson}) async {
    Map<String, dynamic> json = toJson;
    // API不帶屬性的不傳出
    json.removeWhere((key, value) => value == null);
    json.removeWhere((key, value) {
      if(value is List) {
        return value.isEmpty;
      }
      return false;
    });
    print('api form data body: $json');
    // Convert all Files to MultipartFiles

    final result = await _processJson(json);
    return FormData.fromMap(result);
  }

  static Future<Map<String, dynamic>> _processJson(Map<String, dynamic> json) async {
    for (dynamic key in json.keys.toList()) {

      /// 處理圖片
      if (json[key] is File) {
        /// 壓縮圖片至小於 1MB
        final fileExtension = pathUtil.extension((json[key] as File).path).toLowerCase();

        if (fileExtension == '.gif') {
          json[key] = await MultipartFile.fromFile((json[key] as File).path, filename: 'temp$fileExtension');
        }

        // Adding .png extension alongside .jpg
        if (fileExtension == '.jpg' || fileExtension == '.png' || fileExtension == '.jpeg' || fileExtension == '.bmp') {
          final file = await ImageCompressUtil.compressFile(json[key]);

          String path = file!.path;
          json[key] = await MultipartFile.fromFile(path, filename: 'temp$fileExtension');
        }

        if (fileExtension == '.aac') {
          String path = (json[key] as File).path;
          json[key] = await MultipartFile.fromFile(path);
        }
      }

      /// 處理陣列圖片
      if (json[key] is List<File>) {
        /// 壓縮圖片至小於 1MB
        List<MultipartFile> files = [];
        for (File img in json[key]) {
          final fileExtension = pathUtil.extension(img.path).toLowerCase();

          if (fileExtension == '.gif') {
            files.add(await MultipartFile.fromFile(img.path, filename: 'temp$fileExtension'));
          }

          // Adding .png extension alongside .jpg
          if (fileExtension == '.jpg' || fileExtension == '.png' || fileExtension == '.jpeg' || fileExtension == '.bmp') {
            final file = await ImageCompressUtil.compressFile(img);

            String path = file!.path;
            files.add(await MultipartFile.fromFile(path, filename: 'temp$fileExtension'));
          }

          if (fileExtension == '.mp4' || fileExtension == '.mov') {
            String path = await VideoCompressUtil.compressMediaFile(img);
            files.add(await MultipartFile.fromFile(path, filename: 'temp$fileExtension'));
          }
        }
        json[key] = files;
      }
    }
    return json;
  }
}
