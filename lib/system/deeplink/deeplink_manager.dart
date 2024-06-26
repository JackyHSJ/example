
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/phone_login/phone_login.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/deeplink/openinstall/openinstall_handler.dart';
import 'package:frechat/system/provider/user_info_provider.dart';

class DeepLinkManager {
  DeepLinkManager({required this.ref});
  ProviderRef ref;

  init () {
    OpenInstallHandler.init(ref, onPushToRegisterPage: (inviteCode) async {
      print('OpenInstallHandler init 123123');
      await ref.read(userUtilProvider.notifier).loadDataPrefs();
      ref.read(userUtilProvider.notifier).setDataToPrefs(inviteCode: inviteCode);
      print('OpenInstallHandler inviteCode 123123');
      final isLogin = ref.read(userUtilProvider.notifier).isUserLoginState;
      if(isLogin) {
        return ;
      }
      final currentContext = BaseViewModel.getGlobalContext();
      BaseViewModel.pushPage(currentContext, const PhoneLogin());
    });

    OpenInstallHandler.getInstall();
  }

  dispose () {  }
}