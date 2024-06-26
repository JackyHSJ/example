import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/req/member_logout_req.dart';
import 'package:frechat/screens/profile/greet/personal_greet.dart';
import 'package:frechat/screens/profile/setting/about/personal_setting_about.dart';
import 'package:frechat/screens/profile/setting/beauty/personal_setting_beauty.dart';
import 'package:frechat/screens/profile/setting/iap/personal_setting_iap.dart';
import 'package:frechat/screens/profile/setting/notification/personal_setting_notification.dart';
import 'package:frechat/screens/profile/setting/privacy_setting/privacy_setting_page.dart';
import 'package:frechat/screens/profile/setting/teen/personal_setting_teen.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/provider/chat_audio_model_provider.dart';
import 'package:frechat/system/provider/chat_call_model_provider.dart';
import 'package:frechat/system/provider/chat_image_model_provider.dart';
import 'package:frechat/system/provider/chat_message_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/zego_call/zego_login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../../models/profile/personal_setting_model.dart';
import 'block/personal_setting_block.dart';
import 'delete/personal_setting_delete.dart';

class PersonalSettingViewModel {
  PersonalSettingViewModel({
    required this.ref,
    required this.setState,
  });

  WidgetRef ref;
  ViewChange setState;

  List<PersonalSettingModel> cellList = [
    // PersonalSettingModel(
    //     title: '绑定账号',
    //     des: '12300001234',
    //     enableArrow: false,
    //     checkTelBinding: true),
    PersonalSettingModel(title: '美颜设置', pushPage: PersonalSettingBeauty()),
    /// 第一版不上 註解掉
    // PersonalSettingModel(
    //     title: '消息通知', pushPage: PersonalSettingNotification()),
    PersonalSettingModel(title: '收费设置', pushPage: PersonalSettingIAP()),
    PersonalSettingModel(title: '招呼设置', pushPage: PersonalGreet()),
    PersonalSettingModel(title: '青少年模式', pushPage: PersonalSettingTeen()),
    PersonalSettingModel(title: '隐私设置', pushPage: PrivacySettingPage()),
    PersonalSettingModel(title: '黑名单', pushPage: PersonalSettingBlock()),
    // PersonalSettingModel(title: '去评分'),
    PersonalSettingModel(title: '关于产品', pushPage: PersonalSettingAbout()),
    PersonalSettingModel(title: '清除暂存', des: '0MB', isCacheCell: true),
    PersonalSettingModel(
        title: '账号注销协议', des: '清除所有资料', pushPage: PersonalSettingDelete()),
  ];

  bool isLoading = false;

  init() {
    // final String phoneNumber = ref.read(userInfoProvider).phoneNumber ?? '';
    // cellList[0].des = phoneNumber;
    _getCacheNum();
  }

  dispose() {

  }

  _getCacheNum() async {
    /// Flutter 中用於圖片暫存
    int flutterBytes = PaintingBinding.instance.imageCache.currentSizeBytes;
    double flutterMB = flutterBytes / (1024 * 1024);

    /// 指定路徑硬體上的資料夾底下暫存
    final dicSize = await _getTemporaryDirectorySize();
    double dicMB = dicSize / (1024 * 1024);

    /// 總共暫存
    final double sumCache = flutterMB + dicMB;
    cellList.forEach((cell) {
      if(cell.isCacheCell) {
        cell.des = '${sumCache.toStringAsFixed(2)} MB';
      }
    });
    setState((){});
  }


  Future<int> _getTemporaryDirectorySize() async {
    final directory = await getTemporaryDirectory();
    int totalSize = 0;

    await for (var file in directory.list(recursive: true)) {
      if (file is File) {
        totalSize += await file.length();
      }
    }
    return totalSize;
  }

  clearCache(BuildContext context) async {
    PaintingBinding.instance.imageCache.clear();
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      final libCacheDir = Directory(path.join(cacheDir.path, 'libCachedImageData'));
      if (libCacheDir.existsSync()) {
        libCacheDir.deleteSync(recursive: true);
      }
    }
    await _getCacheNum();
    if(context.mounted) {
      BaseViewModel.showToast(context, '清除暂存成功');
    }
  }
}
