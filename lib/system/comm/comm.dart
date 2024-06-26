import 'dart:io';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/analytics/analytics_login.dart';
import 'package:frechat/models/analytics/analytics_register.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/req/add_activity_post_req.dart';
import 'package:frechat/models/req/check_app_version_req.dart';
import 'package:frechat/models/req/error_log_req.dart';
import 'package:frechat/models/req/greet_module_add_req.dart';
import 'package:frechat/models/req/greet_module_edit_req.dart';
import 'package:frechat/models/req/member_register_req.dart';
import 'package:frechat/models/req/send_sms_req.dart';
import 'package:frechat/models/req/upload_real_person_img_req.dart';
import 'package:frechat/models/res/add_activity_post_res.dart';
import 'package:frechat/models/res/base_res.dart';
import 'package:frechat/models/res/check_app_version_res.dart';
import 'package:frechat/models/res/greet_module_add_res.dart';
import 'package:frechat/models/res/greet_module_edit_res.dart';
import 'package:frechat/models/res/member_register_res.dart';
import 'package:frechat/models/res/send_sms_res.dart';
import 'package:frechat/models/res/upload_real_person_img_res.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/repository/http_manager.dart';
import 'package:frechat/system/comm/comm_endpoints.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/aes_util.dart';
import 'package:frechat/system/util/baidu_location_util.dart';
import 'package:frechat/system/util/permission_util.dart';

import '../../models/req/account_modify_user_req.dart';
import '../../models/req/member_login_req.dart';
import '../../models/req/member_logout_req.dart';
import '../../models/req/report/report_user_req.dart';
import '../../models/res/account_modify_user_res.dart';
import '../../models/res/member_login_res.dart';
import '../../models/res/member_logout_res.dart';
import '../../models/res/report_user_res.dart';
import '../global/shared_preferance.dart';
import '../providers.dart';

class CommAPI {
  CommAPI({required this.ref});
  final ProviderRef ref;

  DateTime? _lastLoginSuccessTime;

  //檢查 Server 存活
  Future<BaseRes?> keepAliveCheck({
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    BaseRes? res = await DioUtil(
      onConnectSuccess: onConnectSuccess, onConnectFail: onConnectFail,
      baseUrl: AppConfig.baseUri
    ).get(CommEndpoint.keepAliveCheck);
    return (res == null) ? (null) : (res);
  }

  //Login
  Future<MemberLoginRes?> memberLogin(
    MemberLoginReq? memberLoginReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final String loginData = ref.read(userInfoProvider).loginData ?? '';
    final String commToken = ref.read(userInfoProvider).commToken ?? '';
    final osType = Platform.isIOS ? 0 : 1;
    final String envStr = await AppConfig.getEnvStr();
    final String tData = AesUtil.encode(rawData: '$envStr@$commToken');
    final String appId = AppConfig.getBundleId();
    final String loginType = await FcPrefs.getLoginType();

    final MemberLoginReq quickLoginReq = MemberLoginReq(
      // data: loginData, // 快速登入不帶
      tdata: tData,
      appId: appId,
      osType: osType,
      tokenType: loginType,
      merchant: await AppConfig.getMerChant(),
      version: AppConfig.appVersion
      // location: zone
      // type: 2
    );
    if (memberLoginReq != null) {
      memberLoginReq
        ..appId = appId
        ..osType = osType;
    }
    String? resultCodeCheck;
    BaseRes? res = await DioUtil(
      onConnectSuccess: (succMsg) {
        resultCodeCheck = succMsg;
        onConnectSuccess(succMsg);
      },
      onConnectFail: onConnectFail,
      baseUrl: AppConfig.baseUri
    ).post(CommEndpoint.memberLogin, data: (memberLoginReq == null) ? quickLoginReq.toBody() : memberLoginReq.toBody());

    /// 登入成功 res 存入Prefs
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      final memberLoginRes = MemberLoginRes.fromJson(res!.resultMap);
      await ref.read(userUtilProvider.notifier).setDataToPrefs(
            commToken: memberLoginRes.tId,
            userId: memberLoginRes.userId,
            userName: memberLoginRes.userName,
            nickName: memberLoginRes.nickname,
          );
      //記憶最近一次登入成功的時間，用以提供防止5秒內連續登入的檢驗方法提供。
      _lastLoginSuccessTime = DateTime.now();
    }

    return (res == null) ? (null) : (MemberLoginRes.fromJson(res.resultMap));
  }

  //檢查距上次登入時間點是否已超過5秒
  bool isLegalForNextLogin() {
    if (_lastLoginSuccessTime == null ||
        DateTime.now()
            .subtract(const Duration(seconds: 5))
            .isAfter(_lastLoginSuccessTime!)) {
      return true;
    }
    return false;
  }

  //註冊
  Future<MemberRegisterRes?> memberRegister(
    MemberRegisterReq memberRegisterReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final osType = Platform.isIOS ? 0 : 1;
    final String appId = AppConfig.getBundleId();
    // await PermissionUtil.checkAndRequestLocationPermission();
    // final String location = await BaiduLocationUtil.getLocation();
    memberRegisterReq
      ..appId = appId
      ..osType = osType;
      // ..location = location;
    final formData = await memberRegisterReq.toFormData();
    BaseRes? res = await DioUtil(
        onConnectSuccess: onConnectSuccess, onConnectFail: onConnectFail,
        baseUrl: AppConfig.baseUri
    ).post(CommEndpoint.memberRegister, data: formData);

    if(res == null) {
      return null;
    }

    final Map<String, dynamic> resJsonObj = Map<String, dynamic>.from(res?.resultMap);
    final MemberRegisterRes memberRegisterRes = MemberRegisterRes.fromJson(resJsonObj);

    /// 檢查是否為null
    if(memberRegisterRes.userId == null || memberRegisterRes.userId == 0) {
      return null;
    }
    _sendAnalyticsRegister(memberRegisterRes);
    return memberRegisterRes;
  }

  //登出
  Future<MemberLogoutRes?> memberLogout(
    MemberLogoutReq memberLogoutReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    BaseRes? res = await DioUtil(
        onConnectSuccess: onConnectSuccess, onConnectFail: onConnectFail,
        baseUrl: AppConfig.baseUri
    ).post(CommEndpoint.memberLogout, data: memberLogoutReq.toBody());
    return (res == null) ? (null) : (MemberLogoutRes.fromJson(res.resultMap));
  }

  // 舉報用戶
  Future<ReportUserRes?> reportUser(ReportUserReq reportUserReq,
      {required Function(String) onConnectSuccess,
      required Function(String) onConnectFail}) async {
    final FormData reqBody = await reportUserReq.toFormData();
    BaseRes? res = await DioUtil(
        onConnectSuccess: onConnectSuccess, onConnectFail: onConnectFail,
        baseUrl: AppConfig.baseUri
    ).post(
        CommEndpoint.reportUser,
        data: reqBody
    );
    return (res == null) ? (null) : (ReportUserRes.fromJson(res.resultMap));
  }

  // 更新用戶信息
  Future<MemberModifyUserRes?> memberModifyUser(
      MemberModifyUserReq memberModifyUserReq,
      {required Function(String) onConnectSuccess,
      required Function(String) onConnectFail}) async {
    final formData = await memberModifyUserReq.toFormData();

    BaseRes? res = await DioUtil(
        onConnectSuccess: onConnectSuccess, onConnectFail: onConnectFail,
        baseUrl: AppConfig.baseUri
    ).post(CommEndpoint.memberModifyUser, data: formData);

    return (res == null)
        ? (null)
        : (MemberModifyUserRes.fromJson(res.resultMap));
  }

  /// 新增招呼模板
  Future<GreetModuleAddRes?> greetModuleAdd(GreetModuleAddReq greetModuleAddReq,
      {required Function(String) onConnectSuccess,
      required Function(String) onConnectFail}) async {
    final formData = await greetModuleAddReq.toFormData();
    BaseRes? res = await DioUtil(
        onConnectSuccess: onConnectSuccess, onConnectFail: onConnectFail,
        baseUrl: AppConfig.baseUri
    ).post(CommEndpoint.greetModuleAdd, data: formData);

    return (res == null) ? (null) : (GreetModuleAddRes.fromJson(res.resultMap));
  }

  /// 編輯招呼模板
  Future<GreetModuleEditRes?> greetModuleEdit(
      GreetModuleEditReq greetModuleEditReq,
      {required Function(String) onConnectSuccess,
      required Function(String) onConnectFail}) async {
    final formData = await greetModuleEditReq.toFormData();
    BaseRes? res = await DioUtil(
        onConnectSuccess: onConnectSuccess, onConnectFail: onConnectFail,
        baseUrl: AppConfig.baseUri
    ).post(CommEndpoint.greetModuleEdit, data: formData);

    return (res == null)
        ? (null)
        : (GreetModuleEditRes.fromJson(res.resultMap));
  }

  /// 上傳真人认证
  Future<UploadRealPersonImgRes?> uploadRealPersonImg(
      UploadRealPersonImgReq uploadRealPersonImgReq,
      {required Function(String) onConnectSuccess,
      required Function(String) onConnectFail}) async {
    final formData = await uploadRealPersonImgReq.toFormData();
    BaseRes? res = await DioUtil(
        onConnectSuccess: onConnectSuccess, onConnectFail: onConnectFail,
        baseUrl: AppConfig.baseUri
    ).post(CommEndpoint.uploadRealPersonImg, data: formData);

    return (res == null)
        ? (null)
        : (UploadRealPersonImgRes.fromJson(res.resultMap));
  }

  /// Error Log to Backend Platform
  Future<void> sendErrorMsgLog(ErrorLogReq errorLogReq) async {
    final Map<String, dynamic> headers = errorLogReq.toBody();
    await DioUtil(
      headers: headers,
      baseUrl: AppConfig.baseDebugUri
    ).post(CommEndpoint.sendErrorMsgLog);
  }

  /// 上傳真人认证
  Future<SendSmsRes?> sendSms(
      SendSmsReq sendSmsReq,
      {required Function(String) onConnectSuccess,
        required Function(String) onConnectFail}) async {
    final formData = sendSmsReq.toBody();
    BaseRes? res = await DioUtil(
        onConnectSuccess: onConnectSuccess, onConnectFail: onConnectFail,
        baseUrl: AppConfig.baseUri
    ).post(CommEndpoint.sendSms, data: formData);

    return (res == null)
        ? (null)
        : (SendSmsRes.fromJson(res.resultMap));
  }

  /// 檢查Server存活與網路速度用
  Future<void> checkAliveAndNetWorkSpeed({
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
    required Function(int) onNetworkTime
  }) async {
    final DateTime sendingTime = DateTime.now();
    try {
      await DioUtil(
        onConnectSuccess: onConnectSuccess, onConnectFail: onConnectFail,
        baseUrl: AppConfig.baseUri
      ).get(CommEndpoint.checkAliveAndNetWorkSpeed);
    } catch (e) {
      onConnectFail(e.toString());
    }
    final DateTime responseTime = DateTime.now();
    /// 計算網路傳輸時間
    final Duration resultTime = responseTime.difference(sendingTime);
    onNetworkTime(resultTime.inMilliseconds);
  }

  /// 動態發佈
  Future<AddActivityPostRes?> addActivityPost(
      AddActivityPostReq activityPostReq,
      {required Function(String) onConnectSuccess,
        required Function(String) onConnectFail}) async {
    final formData = await activityPostReq.toFormData();
    final BaseRes? res = await DioUtil(
        onConnectSuccess: onConnectSuccess, onConnectFail: onConnectFail,
        baseUrl: AppConfig.baseUri
    ).post(CommEndpoint.addActivityPost, data: formData);

    return (res == null)
        ? (null)
        : (AddActivityPostRes.fromJson(res.resultMap));
  }

  _sendAnalyticsRegister(MemberRegisterRes res) {
    final Map<String, dynamic> properties = AnalyticsRegister(
      userId: res.userId,
      tId: res.tId,
      userName: res.userName,
      nickName: res.nickName,
      benefit: res.benefit,
      riskDescription: res.riskDescription,
    ).toMap();
    ref.read(analyticsProvider).register('${res.userId}', properties);
  }

  /// 檢查App版本
  Future<CheckAppVersionRes?> checkAppVersion(
      CheckAppVersionReq checkAppVersionReq,
      {required Function(String) onConnectSuccess,
        required Function(String) onConnectFail}) async {
    final formData = await checkAppVersionReq.toFormData();
    final BaseRes? res = await DioUtil(
        onConnectSuccess: onConnectSuccess, onConnectFail: onConnectFail,
        baseUrl: AppConfig.baseUri
    ).post(CommEndpoint.checkAppVersion, data: formData);

    return (res == null)
        ? (null)
        : (CheckAppVersionRes.fromJson(res.resultMap));
  }
}
