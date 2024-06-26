import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';
import 'package:frechat/system/websocket/websocket_status.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImagePickerUtil {
  // select video
  static Future<XFile?> selectVideo() async {
    PermissionUtil.checkAndRequestGalleryPermission();
    XFile? video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 30),
    );
    return video;
  }

  //use camera take video
  Future<XFile?> takeVideo() async {
    PermissionUtil.checkAndRequestCameraPermission();
    XFile? video = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 30),
    );
    return video;
  }

  // only use front lens take picture
  static Future<XFile?> takePicFrontCamera({
    bool isLoginState = true,
  }) async {
    PermissionUtil.checkAndRequestCameraPermission();
    XFile? photo = await ImagePicker().pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 50);
    await BaseViewModel.waitUntilToWebSocketConnect(isLoginState: isLoginState);
    return photo;
  }

//pick up multiple image
// Future<List<XFile>?> pickImage() async {
//   try {
//     List<XFile>? selectedImages = await ImagePicker().pickMultiImage(imageQuality: 78);
//     if (selectedImages != null) {
//       //read every single image
//       for (var element in selectedImages) {
//         //maximum image = 10
//         if(_imageList.length < 10) {
//           _imageList.add(element);
//         }
//       }
//     }
//     setState(() {});
//   } on PlatformException catch (e) {
//     GlobalData.printLog('Failed to pick image: $e');
//   }
// }

  String getFileExtension(XFile file) {
    // 副檔名: 用 . 隔開並取陣列中最後一位
    final String fileExtension = file.path.split('.').last.toLowerCase();
    return fileExtension;
  }

  static Future<XFile?> selectImage({
    bool needSaveImage = false,
    bool isLoginState = true,
  }) async {
    PermissionUtil.checkAndRequestGalleryPermission();
    try {

      // gif 如果使用 imageQuality 會不起作用
      // https://github.com/flutter/flutter/issues/34134
      final ImagePicker picker = ImagePicker();
      final XFile? selectedImages = await picker.pickImage(
          source: ImageSource.gallery,
          // imageQuality: 50,
      );
      if (selectedImages != null) {
        /// 檢查是否有開啟存取圖片功能
        if (needSaveImage) {
          final saveImg = saveImageToLocal(xFile: selectedImages,type:  SaveImagType.other);
          await BaseViewModel.waitUntilToWebSocketConnect(isLoginState: isLoginState);
          return saveImg;
        }

        /// 沒有存取圖片則直接return 選取的圖片XFile
        ///read every single image
        await BaseViewModel.waitUntilToWebSocketConnect(isLoginState: isLoginState);
        return selectedImages;
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
    return null;
  }

  static Future<List<XFile>> selectMultiImg({
    bool needSaveImage = false,
    int selectMax = 6,
    bool isLoginState = true
  }) async {
    PermissionUtil.checkAndRequestGalleryPermission();
    try {
      bool isIOS = Platform.isIOS;
      List<XFile> selectedImages = await ImagePicker().pickMultiImage(imageQuality: isIOS ? 50 : null) ?? [];
      // 限制選取圖片的數量最多為6張
      if (selectedImages.length > selectMax) {
        selectedImages = selectedImages.take(selectMax).toList();
      }

      /// 檢查是否有開啟存取圖片功能
      if (needSaveImage) {
        final List<XFile> savedImages = [];
        for (final image in selectedImages) {
          final savedImage = await saveImageToLocal(xFile: image,type: SaveImagType.other);
          if (savedImage != null) {
            savedImages.add(savedImage);
          }
        }
        await BaseViewModel.waitUntilToWebSocketConnect(isLoginState: isLoginState);
        return savedImages;
      }

      await BaseViewModel.waitUntilToWebSocketConnect(isLoginState: isLoginState);
      /// 沒有存取圖片則直接return 選取的圖片XFile列表
      return selectedImages;
    } catch (e) {
      print('Failed to pick images: $e');
    }
    return [];
  }

  static Future<XFile> saveImageToLocal({required XFile xFile, required SaveImagType type, String fileName = ''}) async {
    PermissionUtil.checkAndRequestGalleryPermission();
    final File file = File(xFile.path);
    // 副檔名: 用 . 隔開並取陣列中最後一位
    final String fileExtension = xFile.path.split('.').last.toLowerCase();

    // 獲取應用程序的文檔目錄
    final directory = await getApplicationDocumentsDirectory();

    // 創建聊天室的文件夹和image文件夹
    String targetPath = '';
    if(type == SaveImagType.avatar){
      targetPath = path.join(directory.path, 'avatar');
    }else{
      targetPath = path.join(directory.path, 'chat_room');
    }
    final imagesPath = path.join(targetPath, 'images');
    final targetDir = Directory(targetPath);
    final imagesDir = Directory(imagesPath);
    if (!await targetDir.exists()) await targetDir.create();
    if (!await imagesDir.exists()) await imagesDir.create();

    // 將圖片複製到新的路徑, img名稱以uuid命名
    String newPath = '';
    if(type == SaveImagType.avatar){
      newPath = path.join(imagesPath, fileName);
    }else{
      final uuid = const Uuid().v4();
      newPath = path.join(imagesPath, 'img_$uuid.$fileExtension');
    }


    // 将图片复制到新的路径
    final savedImage = await file.copy(newPath);

    // 返回新的XFile对象
    return XFile(savedImage.path);
  }

  static Future<CroppedFile?> cropImage(XFile? pickedFile, {
    bool isLoginState = true
  }) async {
    PermissionUtil.checkAndRequestGalleryPermission();
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '裁剪',
            toolbarColor: AppColors.mainPink,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: '裁剪',
            cancelButtonTitle: '取消',
            doneButtonTitle: '确认',
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      await BaseViewModel.waitUntilToWebSocketConnect(isLoginState: isLoginState);

      if (croppedFile != null) {
        return croppedFile;
      }
    }
    return null;
  }

  Future<XFile> downloadAndSaveImage(String imageUrl) async {
    PermissionUtil.checkAndRequestGalleryPermission();
    try {
      final uri = Uri.parse(imageUrl);

      final httpClient = HttpClient();
      final request = await httpClient.getUrl(uri);
      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final Uint8List imageBytes =
            await consolidateHttpClientResponseBytes(response);
        XFile xfile = XFile.fromData(imageBytes);
        return xfile;
      } else {
        print('Failed to download image. Status code: ${response.statusCode}');
        return XFile('');
      }
    } catch (e) {
      print('Error downloading and saving image: $e');
      return XFile('');
    }
  }

  static Future<File?> selectImageAndCrop(BuildContext context) async {
    PermissionUtil.checkAndRequestGalleryPermission();
    XFile? xFile = await ImagePickerUtil.selectImage();
    CroppedFile? croppedFile =
        await cropImage(xFile);
    return (croppedFile == null) ? null : File(croppedFile.path);
  }

  //更改圖片名稱
  Future<String> renameAndMoveImage(
      String oldPath, String newFileName) async {
    PermissionUtil.checkAndRequestGalleryPermission();
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String newFilePath = path.join(appDir.path, newFileName);

    File sourceFile = File(oldPath);
    await sourceFile.copy(newFilePath);

    // Now you have copied the image to the new file path with a new name.
    print('Image copied and renamed to: $newFilePath');
    return newFilePath;
  }
}
