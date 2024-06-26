import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_info_with_type_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_strike_up_req.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_info_with_type_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_strike_up_res.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/touch_feedback_util.dart';

class StrikeUpManager{
  StrikeUpManager({required this.ref});
  ProviderRef ref;

  /// 是否已搭訕/心動
  bool isAlreadyStrikeUp({required String userName}){
    final List<ChatUserModel> chatUserModelList = ref.read(chatUserModelNotifierProvider);
    final chatUserModel = chatUserModelList.where((item) => item.userName == userName).toList();
    if(chatUserModel.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  /// 搭訕/心動
  Future<void> strikeUp({
    required String userName,
    required Function(SearchListInfo?) onSuccess,
    required Function(String) onFail
  }) async {
    String permissionCode = await _checkStrikeUpPermissionCode();
    if (permissionCode != ResponseCode.CODE_SUCCESS) {
      ///105:真人认证审核中 or 131:实名验证审核中
      onFail.call(permissionCode);
      return;
    }

    TouchFeedbackUtil.lightImpact();
    List<dynamic> results = await Future.wait([waitTime(1000), sendStrikeUpRequest(userName)]);
    String resultCodeCheck = results[1][1] as String;
    WsNotificationStrikeUpRes strikeUpRes = results[1][0] as WsNotificationStrikeUpRes;

    // 成功
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ChatRoomInfo chatRoomInfo = strikeUpRes.chatRoom!;
      SearchListInfo searchListInfo = SearchListInfo(roomId: chatRoomInfo.roomId, roomName: chatRoomInfo.roomName, roomIcon: chatRoomInfo.roomIcon,
        userCount: chatRoomInfo.userCount, notificationFlag: chatRoomInfo.notificationFlag, cohesionLevel: chatRoomInfo.cohesionLevel, points: chatRoomInfo.points,
        isOnline: chatRoomInfo.isOnline, userName: chatRoomInfo.userName, userId: chatRoomInfo.userId, remark: chatRoomInfo.remark,);
      await ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [ChatUserModel.fromStikeUpModel(strikeUpRes.chatRoom!)]);
      ref.read(strikeUpUpdatedProvider.notifier).state = searchListInfo;
      // final num roomId = strikeUpRes.chatRoom?.roomId ?? 0;
      // final ChatRoomInfo? chatRoom = strikeUpRes.chatRoom;
      // final WsNotificationSearchInfoWithTypeRes res = await _loadNotificationSearchInfoWithType(type: 3, roomIdList: [roomId]);
      // final SearchListInfo? searchListInfo = res.list?.firstWhere((info) => info.roomId == roomId);
      // if (searchListInfo != null && chatRoom != null) {
      //   ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [ChatUserModel.fromWsModel(chatRoom, searchListInfo)]);
      //   ref.read(strikeUpUpdatedProvider.notifier).state = searchListInfo;
      // }
      await onSuccess.call(searchListInfo);
    } else {
      onFail.call(resultCodeCheck);
    }
  }

  ///檢查是否能搭訕/心動（女生需要完成真人與實名認證）
  Future<String> _checkStrikeUpPermissionCode() async {
    final isGirl = ref.read(userInfoProvider).memberInfo?.gender == 0;
    final realPersonAuth = ref.read(userInfoProvider).memberInfo!.realPersonAuth;
    final realNameAuth = ref.read(userInfoProvider).memberInfo!.realNameAuth;
    final CertificationType personAuthType = CertificationModel.getType(authNum: realPersonAuth);
    final CertificationType nameAuthType = CertificationModel.getType(authNum: realNameAuth);
    if (isGirl) {
      if (personAuthType != CertificationType.done ){
        return ResponseCode.CODE_REAL_PERSON_VERIFICATION_UNDER_REVIEW;
      }else if(nameAuthType !=CertificationType.done) {
        return ResponseCode.CODE_REAL_NAME_UNDER_REVIEW;
      } else {
        return ResponseCode.CODE_SUCCESS;
      }
    } else {
      return ResponseCode.CODE_SUCCESS;
    }
  }

  /// 查詢房間User總比數跟明細(4-7)
  Future<WsNotificationSearchInfoWithTypeRes> _loadNotificationSearchInfoWithType({required num type, List<num>? roomIdList}) async {
    final WsNotificationSearchInfoWithTypeReq reqBody = WsNotificationSearchInfoWithTypeReq.create(type: type, roomIdList: roomIdList);
    final WsNotificationSearchInfoWithTypeRes res = await ref.read(notificationWsProvider).wsNotificationSearchInfoWithType(
        reqBody,
        onConnectSuccess: (succMsg){ },
        onConnectFail: (errMsg){}
    );
    return res;
  }

  Future<void> waitTime(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  Future<List<dynamic>> sendStrikeUpRequest(String userName) async {
    String resultCodeCheck = '';
    WsNotificationStrikeUpReq reqBody = WsNotificationStrikeUpReq.create(userName: userName, type: 0);
    WsNotificationStrikeUpRes strikeUpRes = await ref.read(notificationWsProvider).wsNotificationStrikeUp(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );
    return [strikeUpRes, resultCodeCheck];
  }
}