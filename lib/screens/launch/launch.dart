import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/device_platform_model.dart';
import 'package:frechat/models/ws_req/account/ws_account_end_call_req.dart';
import 'package:frechat/screens/home/home.dart';
import 'package:frechat/screens/launch/launch_view_model.dart';
import 'package:frechat/screens/welcome.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/assets_path/assets_txt_path.dart';
import 'package:frechat/system/authentication_manager.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/pageview_ad_dialog/pageview_ad_dialog.dart';
import 'package:frechat/widgets/shared/dialog/base_dialog.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/dialog/privacy_policy_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/textfromasset/textfromasset_widget.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/original/app_images.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:page_transition/page_transition.dart';

import '../../system/provider/user_info_provider.dart';

/// 一個跳轉用的空畫面，主要負責 App 啟動邏輯。
/// 判斷是否有可用的 accessToken 來嘗試自動登入會在這個地方做。
class Launch extends ConsumerStatefulWidget {
  const Launch({super.key});

  @override
  ConsumerState<Launch> createState() => _LaunchState();
}

class _LaunchState extends ConsumerState<Launch> with AfterLayoutMixin{
  late LaunchViewModel viewModel;
  AppTheme? theme;
  AppImageTheme? appImageTheme;

  @override
  void initState() {
    super.initState();
    viewModel = LaunchViewModel(ref: ref);
    viewModel.init();
    GlobalData.launch = const Launch();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await _launch();
    //Do some initialize stuffs here...
    final bool isNotFirstLogin = await FcPrefs.getIsNotFirstLogin();
    if(isNotFirstLogin && globalStuffsHasInitialized() == true){
      openPageViewAdDialog();
      _checkAndEndCall();
    } else {
      privacyPolicyDialog();
    }

    //Don't remove this.
    setState(() {});
  }

  Future<void> _checkAndEndCall() async {
    try{
      String callJson = await FcPrefs.getCallStatus();
      Map<String, dynamic> callJsonMap = {};
      callJsonMap = json.decode(callJson) as Map<String, dynamic>;
      if(callJsonMap['isCalling']){
        final reqBody = WsAccountEndCallReq.create(
          channel: callJsonMap['channel'],
          roomId: callJsonMap['roomId'],
        );
        await ref.read(accountWsProvider).wsAccountEndCall(reqBody,
            onConnectSuccess: (succMsg){},
            onConnectFail: (errMsg) {});
      }
    }on FormatException {
      debugPrint('The info.extendedData is not valid JSON');
    }
  }

  void privacyPolicyDialog(){
    BaseDialog(context).showTransparentDialog(widget: PrivacyPolicyDialog(
      onConfirm: () async {
        await FcPrefs.setIsNotFirstLogin(true);
        openPageViewAdDialog();
      }
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = ref.watch(userInfoProvider).theme;
    appImageTheme = theme?.getAppImageTheme;
    final fullHigh = MediaQuery.of(context).size.height;
    final fullWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: null,
        resizeToAvoidBottomInset: false,
        body: theme == null
          ? _loading()
          : Image.asset(appImageTheme?.splashBg ?? '',
            height: fullHigh,
            width: fullWidth,
            fit: BoxFit.fill,
          ),
      ),
    );
  }

  _loading() {
    return Center(
      child: LoadingAnimationWidget.fourRotatingDots (
        color: AppColors.mainPink,
        size: WidgetValue.primaryLoading,
      ),
    );
  }

  Future<void> openPageViewAdDialog() async {
    ref.read(deepLinkProvider).init();
    ref.read(analyticsProvider).init();
    DevicePlatformModel.getDeviceModel();

    /// 載入資料 loadDataPrefs
    await _initWs(
        onConnectSuccess: (succMsg) async {
          await ref.read(authenticationProvider).preload(context);

          /// 連線成功，接下來做取得RTM Token 並做 Zego init
          /// get rtc token to Login Zego
          _initZego();
        },
        onConnectFail: (errMsg) {
          ref.read(authenticationProvider).clearAllData(enableClearUserInfo: false);
          BaseViewModel.pushAndRemoveUntil(context, Welcome(), pageTransitionType: PageTransitionType.fade);
        }
    );
  }

  Future<void> _launch() async {
    //Do launch things...
    log('[Launching...]');
    /// Todo: 判斷是否有 access token 可以用，

    //有的話就直接登入進 home
    //We can add any check stuffs logics here.
    await ref.read(userUtilProvider.notifier).loadDataPrefs();
    await initializeGlobalStuffs(ref);
  }

  //[By Jacky]: 據說是讓 webSocket 跑起來的方法，其實可以包成一個 init 解決不是? by Neo
  Future<void> _initWs({
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    /// websocket connect & open listener
    await ref.read(webSocketUtilProvider).connectWebSocket(
      onConnectSuccess: (succMsg) {
        final AuthenticationManager authentication = ref.read(authenticationProvider);
        authentication.sendModifyLocation();
        authentication.sendAnalyticsLogin();
        onConnectSuccess(succMsg);
      },
      onConnectFail: (errMsg) {
        ref.read(authenticationProvider).loginAndConnectWs(
          onConnectSuccess: onConnectSuccess,
          onConnectFail: onConnectFail
        );
      }
    );
  }

  _initZego() async {
    if(mounted) {
      String? resultCodeCheck;
      final res = await viewModel.getRTMToken(context,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg
      );
      if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
        final bool initZegoRes = await ref.read(authenticationProvider).initZego(wsAccountGetRTMTokenRes: res);
        if(initZegoRes) {
          BaseViewModel.pushAndRemoveUntil(context, Home(showAdvertise: true,));
        } else {
          viewModel.logout(context);
        }
      }
    }
  }
}
