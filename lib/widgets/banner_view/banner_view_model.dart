

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerViewModel {
  BannerViewModel({
    required this.ref,
    required this.setState,
  });

  WidgetRef ref;
  ViewChange setState;

  init() {

  }

  dispose() {

  }

  Uri getLaunchUrl(Uri uri) {
    String uriStr = uri.toString();
    final bool isContain = _checkContainToken(uriStr);
    if(isContain) {
      final int tIdIndex = uriStr.indexOf('&tId=');
      uriStr = uriStr.substring(0, tIdIndex);
      final UserInfoModel userInfo = ref.read(userInfoProvider);
      final String token = userInfo.commToken ?? '';
      final String avatar = userInfo.memberInfo?.avatarPath ?? '';
      uriStr += '&tId=$token&avatar=${HttpSetting.baseImagePath + avatar}';
    }
    final Uri launchUri = Uri.parse(uriStr);
    return launchUri;
  }

  Future<void> launch(Uri uri) async {
    final Uri launchUri = getLaunchUrl(uri);
    launchUrl(launchUri);
  }

    bool _checkContainToken(String uriStr) {
    final bool isContain = uriStr.contains('tId=');
    return isContain;
  }
}