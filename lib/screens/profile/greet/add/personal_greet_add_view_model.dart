
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/req/greet_module_add_req.dart';
import 'package:frechat/models/req/greet_module_edit_req.dart';
import 'package:frechat/models/res/greet_module_add_res.dart';
import 'package:frechat/models/ws_req/greet/ws_greet_module_delete_req.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_list_res.dart';
import 'package:frechat/screens/profile/edit/audio/personal_edit_audio_view_model.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_manager.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/audio_util.dart';
import 'package:frechat/system/util/image_picker_util.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';

class PersonalGreetAddViewModel {
  PersonalGreetAddViewModel({
    required this.ref,
    required this.setState,
  });

  ViewChange setState;
  WidgetRef ref;
  File? imgFile;
  GreetModuleInfo? model;
  List<GreetModuleInfo> moduleNameList = [];
  bool isUpdateModeUrlImg = true;

  late TextEditingController moduleNameTextController;
  late TextEditingController introTextController;
  bool isClick = false;
  SettingRecordStatus recordStatus = SettingRecordStatus.unRecord;

  init(BuildContext context, {
    GreetModuleInfo? model,
    required List<GreetModuleInfo> moduleNameList,
  }) {
    // AudioUtils.filePath = null;
    moduleNameTextController = TextEditingController();
    introTextController = TextEditingController();
    this.model = model;
    this.moduleNameList = moduleNameList;
    moduleNameTextController.text = model?.modelName ?? '';
    introTextController.text = model?.greetingText ?? '';
    imgFile = (model?.greetingPic == null) ? null : File(model!.greetingPic!);
    AudioUtils.filePath = model?.greetingAudio?.filePath;
  }

  dispose() {
    moduleNameTextController.dispose();
    introTextController.dispose();
  }

  String getFileExtension(XFile file) {
    // 副檔名: 用 . 隔開並取陣列中最後一位
    final String fileExtension = file.path.split('.').last.toLowerCase();
    return fileExtension;
  }

  selectImg(BuildContext context, {
    required Function() onShowFrequentlyDialog
  }) async {
    List<String> validTypeList = ['jpg','png','jpeg','gif','bmp'];
    //防止連續登入問題 (裁圖/照相功能會造成斷線)
    if (ref.read(commApiProvider).isLegalForNextLogin()) {
      /// 連續跳出登入會造成錯誤
      // imgFile = await ImagePickerUtil.selectImageAndCrop(context);
      // 選取 .bmp 的圖片時，image_picker 會自動將其轉換為 .jpg 檔案。
      // 選取 .jpeg 的圖片時，image_picker 會自動將其轉換為 .jpg 檔案。
      final XFile? imgXFile = await ImagePickerUtil.selectImage(isLoginState: true);
      if (imgXFile == null) {
        imgFile = null;
      } else {
        final String fileExtension = getFileExtension(imgXFile);
        if (validTypeList.contains(fileExtension)) {
          imgFile = File(imgXFile.path);
        } else {
          imgFile = null;
          if (context.mounted) {
            BaseViewModel.showToast(context, '图片档案格式不正确，请选择 JPG、JPEG、PNG或GIF、BMP格式上传。');
          }
        }
      }
      isUpdateModeUrlImg = false;
      setState((){});
    } else {
      await onShowFrequentlyDialog();
    }
  }

  takeImg(BuildContext context, {
    required Function() onShowFrequentlyDialog
  }) async {
    //防止連續登入問題 (裁圖/照相功能會造成斷線)
    if (ref.read(commApiProvider).isLegalForNextLogin()) {
      final XFile? imgXFile = await ImagePickerUtil.takePicFrontCamera();
      if(imgXFile == null) {
        return ;
      }
      imgFile = File(imgXFile.path);
      isUpdateModeUrlImg = false;
      setState((){});
    } else {
      await onShowFrequentlyDialog();
    }
  }

  // 新增招呼語
  addGreet(BuildContext context) async {
    isClick = true;
    final token = ref.read(userInfoProvider).commToken ?? '';
    final String? module = getModuleName(moduleNameTextController.text);
    if(module == null) {
      BaseViewModel.showToast(context, '亲～招呼语标题不能重复呦');
      return ;
    }
    Duration? audioTimeDuration = await AudioUtils.getAudioTime( audioUrl: AudioUtils.filePath??'', addBaseImagePath: false);
    GreetModuleAddReq reqBody = GreetModuleAddReq.create(
      tId: token,
      modelName: getModuleName(moduleNameTextController.text),
      greetingAudio: AudioUtils.filePath == null ? null : File(AudioUtils.filePath ?? ''),
      greetingPic: imgFile,
      greetingText: introTextController.text,
      greetingAudioLength:  audioTimeDuration?.inMilliseconds ??0,
    );

    ref.read(commApiProvider).greetModuleAdd(reqBody,
        onConnectSuccess: (succMsg) {
          BaseViewModel.popPage(context);
          BaseViewModel.popPage(context);
          isClick = false;
        },
        onConnectFail: (errMsg) {
          isClick = false;
          BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
        }
    );
  }

  String? getModuleName(String moduleName) {
    if(moduleName == '' || moduleName.isEmpty) {
      int index = 1;
      String defaultName = '预设$index';
      moduleNameList.map((name) {
        if(name.modelName == defaultName) {
          index++;
          defaultName = '预设$index';
        }
      }).toList();
      return defaultName;
    }
    final List<GreetModuleInfo> greetList = ref.read(userInfoProvider).greetModuleList?.list ?? [];
    final bool isContain = greetList.any((greet) => greet.modelName == moduleName);
    if(isContain) {
      return null;
    }

    return moduleName;
  }

  updateGreet(BuildContext context) async {
    isClick = true;
    XFile? audioUrlXFile;
    XFile? imgUrlXFile;
    File? audio;
    File? img;
    final token = ref.read(userInfoProvider).commToken ?? '';
    final checkAudio = model!.greetingAudio == AudioUtils.filePath;
    final checkImg = model!.greetingPic?.contains(imgFile!.path) ?? false;
    if(checkAudio && (model!.greetingAudio != null)) {
      String filePath = model?.greetingAudio?.filePath ?? '';
      audioUrlXFile = await DioUtil.getUrlAsXFile(HttpSetting.baseImagePath + filePath);
      audio = File(audioUrlXFile!.path);
    } else if(AudioUtils.filePath != null) {
      audio = File(AudioUtils.filePath!);
    }
    if(checkImg && (model!.greetingPic != null)) {
      imgUrlXFile = await DioUtil.getUrlAsXFile(HttpSetting.baseImagePath + imgFile!.path);
      img = File(imgUrlXFile!.path);
    } else {
      img = imgFile;
    }
    Duration? audioTimeDuration = await AudioUtils.getAudioTime( audioUrl: audio?.path ??'', addBaseImagePath: false);

    GreetModuleEditReq reqBody = GreetModuleEditReq.create(
      tId: token,
      id: model!.id,
      greetingAudio: audio,
      greetingPic: img,
      greetingText: introTextController.text,
      greetingAudioLength: audioTimeDuration?.inMilliseconds ?? 0,
    );
    ref.read(commApiProvider).greetModuleEdit(reqBody,
        onConnectSuccess: (succMsg) {
          BaseViewModel.popPage(context);
          BaseViewModel.popPage(context);
          isClick = false;
        },
        onConnectFail: (errMsg) {
          isClick = false;
          BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
        }
    );
  }

  deleteGreet(BuildContext context,{
    required String deleteId
  }) {
    final WsGreetModuleDeleteReq reqBody = WsGreetModuleDeleteReq.create(ids: deleteId);
    ref.read(greetWsProvider).wsGreetModuleDelete(reqBody,
        onConnectSuccess: (succMsg) {
          BaseViewModel.popPage(context);
          BaseViewModel.popPage(context);
          BaseViewModel.popPage(context);
        },
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
  }
}