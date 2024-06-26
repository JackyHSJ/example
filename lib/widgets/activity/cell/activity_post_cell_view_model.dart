
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/req/report/report_user_req.dart';
import 'package:frechat/models/res/report_user_res.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_delete_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_donate_post_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_info_with_type_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_strike_up_req.dart';
import 'package:frechat/models/ws_req/post_like/ws_post_add_like_req.dart';
import 'package:frechat/models/ws_req/post_like/ws_post_return_like_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_delete_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_donate_post_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_list_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_info_with_type_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_strike_up_res.dart';
import 'package:frechat/models/ws_res/post_like/ws_post_add_like_res.dart';
import 'package:frechat/models/ws_res/post_like/ws_post_return_like_res.dart';
import 'package:frechat/models/ws_res/report/ws_report_search_type_res.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/system/util/dialog_util.dart';
import 'package:frechat/system/util/real_person_name_auth_util.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/widgets/shared/bottom_sheet/recharge/recharge_bottom_sheet.dart';
import 'package:frechat/widgets/shared/dialog/recharge_dialog.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../../models/ws_res/notification/ws_notification_search_list_res.dart';
import '../../../screens/chatroom/chatroom_viewmodel.dart';

class ActivityPostCellViewModel {
  ActivityPostCellViewModel({required this.setState, required this.ref});
  ViewChange setState;
  WidgetRef ref;

  init() {}

  dispose() {}

  /// 是否已搭訕/心動
  Future<bool> isAlreadyStrikeUp({required String userName}) async {
    final bool isAlreadyStrikeUp = await ref.read(strikeUpProvider).isAlreadyStrikeUp(userName: userName);
    return isAlreadyStrikeUp;
  }

  /// 開啟聊天室
  Future<SearchListInfo?> openChatRoom({required String userName}) async {
    final List<ChatUserModel> chatUserModelList = ref.watch(chatUserModelNotifierProvider);
    final ChatUserModel currentChatUserModel = chatUserModelList.firstWhere((info) {
      return info.userName == userName;
    });
    return ConvertUtil.transferChatUserModelToSearchListInfo(currentChatUserModel);
  }

  /// 搭訕/心動
  Future<void> strikeUp({required String userName,required Function(String) onFail}) async {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    await ref.read(strikeUpProvider).strikeUp(
        userName: userName,
        onSuccess: (searchListInfo) {
          final isGirl = ref.read(userInfoProvider).memberInfo?.gender == 0;
          if (isGirl) {
            _sendCommonPhrases(currentContext, searchListInfo: searchListInfo);
          } else {
            _sendPickUpPhrases(currentContext, searchListInfo: searchListInfo);
          }
          if (currentContext.mounted) {
            final String label = isGirl ? '心动' : '搭讪';
            final String name = searchListInfo?.remark ?? searchListInfo?.roomName ?? '';
            BaseViewModel.showToast(currentContext, '您已$label $name！');
          }
          // setState((){});
        },
        onFail: (msg) {
          onFail.call(msg);
        });
  }

  ///搭訕常用語
  Future<void> _sendPickUpPhrases(BuildContext context, {SearchListInfo? searchListInfo}) async {
    final ChatRoomViewModel viewModel = ChatRoomViewModel(ref: ref, setState: setState, context: context);
    final String data = await rootBundle.loadString('assets/txt/strike_up_list_pick_up_phrases.txt');
    final List<String> list = const LineSplitter().convert(data);
    final Random random = Random();
    //Api 3-1
    viewModel.sendTextMessage(
        searchListInfo: searchListInfo,
        message: list[random.nextInt(list.length)],
        contentType: 3,
        isStrikeUp: true,);
  }

  ///心動常用語
  Future<void> _sendCommonPhrases(BuildContext context, {SearchListInfo? searchListInfo}) async {
    /// 判斷是否有招呼與設置
    final List<GreetModuleInfo> greetList = ref
        .read(userInfoProvider)
        .greetModuleList
        ?.list ?? [];
    final ChatRoomViewModel viewModel = ChatRoomViewModel(ref: ref, setState: setState, context: context);
    final girlGreet = greetList.where((greet) {
      final authType = CertificationModel.getGreetType(authNum: greet.status ?? 0);
      return CertificationType.using == authType;
    }).toList();

    /// 無設置招呼語
    if (girlGreet.isEmpty) {
      String data = await rootBundle
          .loadString('assets/txt/strike_up_list_common_phrases.txt');
      List<String> list = const LineSplitter().convert(data);
      Random random = Random();
      //Api 3-1
      viewModel.sendTextMessage(
          searchListInfo: searchListInfo,
          message: list[random.nextInt(list.length)],
          isStrikeUp: true,
          contentType: 3,);
      return;
    }

    /// 待補上
    if (girlGreet.first.greetingPic != null) {
      viewModel.sendImageMessage(
          searchListInfo: searchListInfo,
          unRead: 1,
          isStrikeUp: true,
          imgUrl: girlGreet.first.greetingPic);
    }

    if (girlGreet.first.greetingText != null) {
      viewModel.sendTextMessage(
          searchListInfo: searchListInfo,
          message: girlGreet.first.greetingText,
          isStrikeUp: true,);
    }

    if (girlGreet.first.greetingAudio != null) {
      viewModel.sendVoiceMessage(
          searchListInfo: searchListInfo,
          unRead: 1,
          isStrikeUp: true,
          audioUrl: girlGreet.first.greetingAudio?.filePath);
    }
  }

  bool isEnabledDonate(ActivityPostInfo postInfo){
    bool isEnabled = false;
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    final num blockType = ref.read(userInfoProvider).buttonConfigList?.blockType ?? 0;
    final String personalUserName = ref.read(userInfoProvider).memberInfo?.userName ?? '';

    //只有男生可打賞功能，除後台設定審核中時，皆不開啟功能
    if(gender == 1 && blockType == 0){
      isEnabled = true;
    }

    // 自己的貼文不能打賞
    if (personalUserName == postInfo.userName) {
      isEnabled = false;
    }

    return isEnabled;
  }

  /// 打賞動態(19-7)
  Future<void> donateActivityPost({
    required num freFeedId,
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    // String resultCodeCheck = '';
    final WsActivityDonatePostReq reqBody = WsActivityDonatePostReq.create(freFeedId: freFeedId);

    final WsActivityDonatePostRes res = await ref.read(activityWsProvider).wsActivityDonatePost(
      reqBody,
      onConnectSuccess: (succMsg) => onConnectSuccess(succMsg),
      onConnectFail: (errMsg) => onConnectFail(errMsg),
    );
  }


  /// 舉報貼文(/freChat/report/report)
  Future<void> reportActivityPost({
    required num feedId,
    required ReportListInfo reportListInfo,
    required String reportText,
    required num userId,
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    // String resultCodeCheck = '';
    String tId = await FcPrefs.getCommToken();
    final ReportUserReq req = ReportUserReq.create(
      tId: tId,
      type: 2,
      remark: reportText,
      reportSettingId: reportListInfo.id ?? 0,
      feedsId: feedId,
      userId: userId,
    );
    final ReportUserRes? res = await ref.read(commApiProvider).reportUser(req,
      onConnectSuccess: (succMsg) => onConnectSuccess(succMsg),
      onConnectFail: (errMsg) => onConnectFail(errMsg)
    );

    // if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
    // } else {
    //
    // }
  }


  /// 刪除自己貼文(19-4)
  Future<void> deletePersonalActivityPost(
      {required num feedsId,
      required Function(String) onConnectSuccess,
      required Function(String) onConnectFail}) async {

    String resultCodeCheck = '';
    final WsActivityDeleteReq reqBody = WsActivityDeleteReq.create(feedsId: feedsId);
    final WsActivityDeleteRes res = await ref.read(activityWsProvider).wsActivityDelete(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      await _reloadPersonalActivityPost();
      onConnectSuccess.call(resultCodeCheck);
    } else {
      onConnectFail.call(resultCodeCheck);
    }
  }


  /// 更新自己的動態貼文（用於上傳貼文後，更新自己的貼文到 provider）
  Future<void> _reloadPersonalActivityPost() async {
    String resultCodeCheck = '';
    WsActivitySearchInfoType type = WsActivitySearchInfoType.personal;
    String typeString = WsActivitySearchInfoType.values.indexOf(type).toString();
    final WsActivitySearchInfoReq reqBody = WsActivitySearchInfoReq.create(type: typeString, condition: '0');
    final WsActivitySearchInfoRes res = await ref.read(activityWsProvider).wsActivitySearchInfo(
      reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      res.type = type;
      _refreshActivityAllLikePostIdList(res.likeList??[]);
      ref.read(userUtilProvider.notifier).loadActivityInfoPersonal(res);
    }
  }
  /// 更新至 全部已按讚動態貼文ID清單
  Future<void> _refreshActivityAllLikePostIdList(List<dynamic> likeList) async{
    List<dynamic> allLikeList = await ref.read(userInfoProvider).activityAllLikePostIdList?? [];
    Set<dynamic> mergedSet = {};
    mergedSet.addAll(allLikeList);
    mergedSet.addAll(likeList);
    List<dynamic> mergedList = mergedSet.toList();
    ref.read(userUtilProvider.notifier).loadActivityAllLikePostIdList(mergedList);
  }

  /// 判斷是否已按讚過
  bool isAlreadyLike({required List<dynamic> likeList, required num id}) {
    final bool isContain = likeList.contains(id);
    return isContain;
  }

  /// 新增按讚（20-1）
  Future<void> addLike({required num postId}) async {

    final UserInfoModel userInfo = ref.read(userInfoProvider);
    num blockType = userInfo.buttonConfigList?.blockType ?? 0;
    //判斷審核中，不打後端，前端顯示
    if(blockType == 1){
      _refreshLikeCount(isAdd: true,postId: postId);
      return;
    }
    String? resultCodeCheck;
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    final WsPostAddLikeReq reqBody = WsPostAddLikeReq.create(articlesId: postId.toString(), type: '0');
    final WsPostAddLikeRes res = await ref.read(postLikeWsProvider).wsPostAddLike(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(currentContext, ResponseCode.map[errMsg]!)
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      _refreshLikeCount(isAdd: true,postId: postId);
    }
  }

  /// 取消按讚（20-2）
  Future<void> cancelLike({required num postId}) async {

    final UserInfoModel userInfo = ref.read(userInfoProvider);
    num blockType = userInfo.buttonConfigList?.blockType ?? 0;
    //判斷審核中，不打後端，前端顯示
    if(blockType == 1){
      _refreshLikeCount(isAdd: false,postId: postId);
      return;
    }
    String? resultCodeCheck;
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    final WsPostReturnLikeReq reqBody = WsPostReturnLikeReq.create(articlesId: postId.toString(), type: '0');
    final WsPostReturnLikeRes res = await ref.read(postLikeWsProvider).wsPostReturnLike(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(currentContext, ResponseCode.map[errMsg]!)
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      _refreshLikeCount(isAdd: false,postId: postId);
    }
  }

  /// 刷新按讚數
  void _refreshLikeCount({required bool isAdd ,required num postId}){
    WsActivitySearchInfoRes? searchInfoRecommend = ref.read(userUtilProvider).activitySearchInfoRecommend ?? WsActivitySearchInfoRes();
    WsActivitySearchInfoRes? searchInfoSubscribe = ref.read(userUtilProvider).activitySearchInfoSubscribe ?? WsActivitySearchInfoRes();
    WsActivitySearchInfoRes? searchInfoPersonal = ref.read(userUtilProvider).activitySearchInfoPersonal ?? WsActivitySearchInfoRes();
    WsActivitySearchInfoRes? searchInfoTopics = ref.read(userUtilProvider).activitySearchInfoTopics ?? WsActivitySearchInfoRes();
    WsActivitySearchInfoRes? searchInfoOthers = ref.read(userUtilProvider).activitySearchInfoOthers ?? WsActivitySearchInfoRes();

    _updateActivitySearchInfoLikeInfo(isAdd:isAdd,searchInfo: searchInfoRecommend,postId: postId, onAddLikeInfo: (searchInfo) => ref.read(userUtilProvider.notifier).loadActivityInfoRecommend(searchInfo));
    _updateActivitySearchInfoLikeInfo(isAdd:isAdd,searchInfo: searchInfoSubscribe,postId: postId, onAddLikeInfo: (searchInfo) => ref.read(userUtilProvider.notifier).loadActivityInfoSubscribe(searchInfo));
    _updateActivitySearchInfoLikeInfo(isAdd:isAdd,searchInfo: searchInfoPersonal,postId: postId, onAddLikeInfo: (searchInfo) => ref.read(userUtilProvider.notifier).loadActivityInfoPersonal(searchInfo));
    _updateActivitySearchInfoLikeInfo(isAdd:isAdd,searchInfo: searchInfoTopics,postId: postId, onAddLikeInfo: (searchInfo) => ref.read(userUtilProvider.notifier).loadActivityInfoTopics(searchInfo));
    _updateActivitySearchInfoLikeInfo(isAdd:isAdd,searchInfo: searchInfoOthers,postId: postId, onAddLikeInfo: (searchInfo) => ref.read(userUtilProvider.notifier).loadActivityInfoOthers(searchInfo));

  }
  /// 更新各動態貼文列表Like資訊
  void _updateActivitySearchInfoLikeInfo({
    bool isAdd = true,
    required WsActivitySearchInfoRes searchInfo,
    required num postId,
    required Function(WsActivitySearchInfoRes) onAddLikeInfo
  }) {
    List<dynamic> allLikeList = ref.read(userInfoProvider).activityAllLikePostIdList?? [];
    final List<ActivityPostInfo> list = searchInfo.list ?? [];
    final bool isContain = list.any((info) => info.id == postId);
    if(isContain == false) {
      return ;
    }
    final int index = list.indexWhere((info) => info.id == postId);
    final num likesCount = list[index].likesCount ?? 0;

    if(isAdd) {
      list[index].likesCount = likesCount + 1;
      searchInfo.list = list;
      searchInfo.likeList?.add(postId);
      allLikeList.add(postId);
    }
    if(isAdd == false) {
      list[index].likesCount = likesCount - 1;
      searchInfo.list = list;
      searchInfo.likeList?.removeWhere((info) => info == postId);
      allLikeList.removeWhere((info) => info == postId);
    }
    ref.read(userUtilProvider.notifier).loadActivityAllLikePostIdList(allLikeList);
    onAddLikeInfo(searchInfo);
  }

  /// 取得使用者資訊2-2
  Future<void> getMemberInfo({required String userName, required Function(WsMemberInfoRes) onConnectSuccess,
    required Function(String) onConnectFail}) async {
    String resultCodeCheck = '';
    final reqBody = WsMemberInfoReq.create(userName: userName);
    WsMemberInfoRes memberInfoRes = await ref.read(memberWsProvider).wsMemberInfo(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => onConnectFail.call(errMsg)
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      onConnectSuccess.call(memberInfoRes);
    }
  }
}