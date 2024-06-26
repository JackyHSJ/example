//這個類別包裝所有跟中國移動相關的 Android/iOS API, 供專案內需要用到的任何地方使用。
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/req/member_login_req.dart';
import 'package:frechat/models/req/send_sms_req.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/loading_dialog/loading_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quickpass_yidun_flutter/quickpass_flutter_plugin.dart';


class NTESDUNMobAuth {

  static QuickpassFlutterPlugin quickLoginPlugin = QuickpassFlutterPlugin();

  static String f_result_key = "success";
  static String id = "d459ee6b6dbd44808629a3a732840c2c";
  static List<String> tokenList = [];


  String _result = "token=";



  /// sdk 初始化是否完成
  static void isInitSuccess(BuildContext context) {
    quickLoginPlugin.init(id, 4, true).then((map) {
      bool result = map?[f_result_key];
      if(result){
        // BaseViewModel.showToast(context, '易盾初始化成功');
      }else{
        BaseViewModel.showToast(context, '初始化失败');
      }
    });
  }

  /// 登录预取号
  static Future<bool> preLogin(BuildContext context) async {
    tokenList = [];
    Map? map = await quickLoginPlugin.preFetchNumber();
    if (map?['success'] == true) {
      var ydToken = map?['token'];
      tokenList.add(ydToken);
      return true;
    } else {
      var ydToken = map?['token'];
      var errorMsg = map?['errorMsg'];
      return false;
    }
  }

  //一键登陆
  static Future<bool> quickLogin(BuildContext context) async {
    String file = "";
    if (Platform.isIOS) {
      file = "assets/json/ios-light-config.json";
    } else if (Platform.isAndroid) {
      file = "assets/json/android-light-config.json";
    }

    // 使用await直接等待loadString的结果
    var value = await rootBundle.loadString(file);
    var configMap = {"uiConfig": json.decode(value)};
    quickLoginPlugin.setUiConfig(configMap);

    Map? map = await quickLoginPlugin.onePassLogin();
    if (map?["success"]) {
      var accessToken = map?["accessToken"];
      tokenList.add(accessToken);
      quickLoginPlugin.closeLoginAuthView();
      return true;
    } else {
      var errorMsg = map?["msg"];
      quickLoginPlugin.closeLoginAuthView();
      return false;
    }
  }

  /// 获取短信验证码
  static Future<void> getSMSCode(
      String phoneNumber, WidgetRef ref, BuildContext context,
      {required Function() onConnectFail}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final reqBody = SendSmsReq.create(phonenumber: phoneNumber, appId: packageInfo.packageName);
    await ref.read(commApiProvider).sendSms(reqBody,
        onConnectSuccess: (succMsg) {}, onConnectFail: (errMsg) {
          BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
          onConnectFail();
        });
  }

  //假登入、驗證碼登入
  static Future<void> loginInWithSMSOrPassword(BuildContext context,
      String phoneNumber, String verificationCode, WidgetRef ref, bool express,
      {required Function(String) onConnectSuccess,
        required Function(String) onConnectFail,
        required Function() onConnectRegister}) async {
    FcPrefs.setVerificationCode(verificationCode);
    ref.read(userUtilProvider.notifier).setDataToPrefs(phoneNumber: phoneNumber);
    final String envStr = await AppConfig.getEnvStr();
    MemberLoginReq req = MemberLoginReq.create(
        env: envStr, //環境
        phoneNumber: phoneNumber, //手機號
        phoneToken: verificationCode, //一鍵登入Token
        deviceModel: await AppConfig.getDevice(), //设备型号
        currentVersion: AppConfig.appVersion, //当前版本号
        systemVersion: AppConfig.buildNumber,
        express: express,
        type: 2,
        tdata: '',
        merchant: await AppConfig.getMerChant(),
        tokenType: '',
        version: AppConfig.appVersion
    );
    ref.read(authenticationProvider).loginAndConnectWs(req: req, onConnectSuccess: (succMsg) async {
          /// 登入成功，只有登入頁登入需要多存這兩個參數
          await ref.read(userUtilProvider.notifier).setDataToPrefs(loginData: req.data, phoneNumber: phoneNumber);
          onConnectSuccess(succMsg);
        },
        onConnectFail: (errMsg) {
          if (errMsg == ResponseCode.CODE_ACCOUNT_NOT_FOUND) {
            onConnectRegister();
          } else {
            onConnectFail(errMsg ?? '');
          }
        });
  }

}
