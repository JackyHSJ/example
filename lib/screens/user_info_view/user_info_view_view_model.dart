



import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_req/account/ws_account_follow_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_remark_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_leave_group_block_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_leave_group_block_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/screens/user_info_view/user_info_view.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/database/model/visitor_time_model.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/provider/visitor_time_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class UserInfoViewViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;
  num? userId;

  UserInfoViewViewModel({
    required this.ref,
    required this.setState,
    required this.context,
    this.userId,
  });

  // 審核開關
  bool showCallType = false; // 1. 通話
  num isOnline = 0;


  final PageController photoViewPageController = PageController(); // 相冊
  int currentPageIndex = 0; // 相冊頁數
  // List<ActivityPostInfo> feedingList = []; // 動態牆
  // List<dynamic> likeList = [];

  init(BuildContext context) {
    showCallType = ref.read(userInfoProvider).buttonConfigList?.callType == 1 ? true : false;
  }

  // dispose
  dispose() {
    photoViewPageController.dispose();
  }

  //
  //
  //

  // 相冊切換
  onPhotoViewerPageChanged(int index) => setState(() => currentPageIndex = index);

  //拉黑、退出群組(4-3)
  Future<WsNotificationLeaveGroupBlockRes> wsNotificationLeaveGroupBlock({required num roomId, required Function(String) onConnectSuccess, required Function(String) onConnectFail,
  }) async {
    final reqBody = WsNotificationLeaveGroupBlockReq.create(roomId: roomId);
    final WsNotificationLeaveGroupBlockRes res = await ref.read(notificationWsProvider).wsNotificationLeaveGroupBlock(reqBody, onConnectSuccess: (succMsg) {
      onConnectSuccess(succMsg);
    }, onConnectFail: (errMsg) {
      onConnectFail(errMsg);
    });

    return res;
  }

  insertBlockInfoToSqfLite(SearchListInfo searchListInfo) async {
    final num? userId = ref.read(userInfoProvider).userId;
    final model = ChatBlockModel(
      userId: userId,
      friendId: searchListInfo.userId,
      nickName: searchListInfo.remark ?? searchListInfo.roomName,
      filePath: searchListInfo.roomIcon,
      userName: searchListInfo.userName,
    );
    await ref.read(chatBlockModelNotifierProvider.notifier).setDataToSql(chatBlockModelList: [model]);
    await ref.read(unreadMessageManager).updateUnreadCount();
  }

  // 用户交互-修改备注名 5-1
  Future<bool> modifiedAccountRemark(num userID, String remark) async {
    String resultCodeCheck = '';

    final WsAccountRemarkReq reqBody = WsAccountRemarkReq.create(friendId: userID, remark: remark);
    await ref.read(accountWsProvider).wsAccountRemark(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      return true;
    } else {
      if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      return false;
    }
  }

  ///取得成員資料
  Future<WsMemberInfoRes?> getMemberInfoFromUserName(BuildContext context, {required String userName}) async {
    String? resultCodeCheck;
    final num newVisitorType = await _getNewVisitorType(userName);
    final WsMemberInfoReq reqBody = WsMemberInfoReq.create(userName: userName, newVisitor: newVisitorType);
    final WsMemberInfoRes res = await ref.read(memberWsProvider).wsMemberInfo(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      _setVisitorTimeModelInDB(res);
      isOnline = res.isOnline ?? 0;
      return res;
    }

    return null;
  }

  Future<num> _getNewVisitorType(String toUserName) async {
    final UserInfoModel userInfo = ref.read(userInfoProvider);
    final String myUserName = userInfo.memberInfo?.userName ?? '';
    final model = VisitorTimeModel(
      fromUserName: myUserName,
      toUserName: toUserName,
    );
    final List<VisitorTimeModel> modelList = await ref.read(visitorTimeModelNotifierProvider.notifier).loadDataFromUserName(whereModel: model);
    if(modelList.isEmpty) {
      return 1;
    }
    final int expireTime = modelList.first.lastVisitTimestamp?.toInt() ?? 0;
    final DateTime latDateTime = DateTime.fromMillisecondsSinceEpoch(expireTime);
    final Duration difference = DateTime.now().difference(latDateTime).abs();
    final num limitExpireTime = userInfo.myVisitorExpireTime ?? 3;
    if(difference.inDays >= limitExpireTime) {
      return 1;
    }

    return 0;
  }

  _setVisitorTimeModelInDB(WsMemberInfoRes res) {
    final UserInfoModel userInfo = ref.read(userInfoProvider);
    final String myUserName = userInfo.memberInfo?.userName ?? '';
    final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    final myVisitorExpireTime = userInfo.myVisitorExpireTime;
    final VisitorTimeModel model = VisitorTimeModel(
      fromUserName: myUserName,
      toUserName: res.userName,
      toUserGender: res.gender,
      lastVisitTimestamp: currentTimestamp,
      visitorExpireTime: myVisitorExpireTime,
    );
    ref.read(visitorTimeModelNotifierProvider.notifier).setDataToSql(visitorTimeModelList: [model]);
  }

  double getDraggableScrollableSheetSize() {
    final double width = UIDefine.getWidth();
    final double height = UIDefine.getHeight();
    final double size = (height - width) / height;
    return size;
  }
}