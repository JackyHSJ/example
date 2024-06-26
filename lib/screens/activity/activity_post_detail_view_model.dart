

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/req/report/report_user_req.dart';
import 'package:frechat/models/res/report_user_res.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_add_reply_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_delete_reply_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_reply_info_req.dart';
import 'package:frechat/models/ws_req/report/ws_report_search_type_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_add_reply_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_delete_reply_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_reply_info_res.dart';
import 'package:frechat/models/ws_res/report/ws_report_search_type_res.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/util/dialog_util.dart';
import 'package:frechat/system/util/real_person_name_auth_util.dart';
import 'package:frechat/widgets/activity/activity_post_util.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:zego_zpns/zego_zpns.dart';
import 'package:uuid/uuid.dart';


class ActivityPostDetailViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  ActivityPostDetailViewModel({
    required this.setState,
    required this.ref,
    required this.context
  });

  // 輸入框用的 textController
  late RichTextController richTextController;
  FocusNode focusNode = FocusNode(); // 焦點

  int replyPage = 1; // 分頁
  bool checkReply = false; // 檢查輸入框是否有文字，是否可以留言
  num? feedReplyId; // 留言用，第一層是帶貼文 id, 第二層是帶上一層留言 id
  int replyType = 0; // 0: 第一層, 1: 第二層
  bool isLoading = true; // 第一層留言 loading
  List<ActivityReplyInfo> replyList = []; // 第一層留言 list
  String? tagUserName;
  bool noMoreReply = false;

  void init(num feedsId) {
    feedsId = feedsId;

    richTextController = RichTextController(
      patternMatchMap: {
        RegExp(r"^@[^\s]+\s?"): updateRegexPattern()
      },
      onMatch: (List<String> matches) {
        print(matches);
      },
      regExpUnicode: true,
    );
    feedReplyId = feedsId;
    getMainReplyList(feedsId);
  }

  void dispose() {
    richTextController?.dispose();
  }

  void resetToInitState() {
    setState(() {
      richTextController.clear(); // 文字清空
      focusNode.unfocus(); // 鍵盤收起
      replyType = 0; // 回覆類型
      checkReply = false;
      tagUserName = null;
      replyPage = 1;
      noMoreReply = false;
    });
  }

  TextStyle updateRegexPattern() {
    return tagUserName == null
        ? const TextStyle()
        : TextStyle(
            fontWeight: FontWeight.w400,
            color: const Color(0xff54B5DF),
            fontSize: 14.sp,
    );
  }

  // 取得第一層留言
  Future<void> getMainReplyList(num feedsId) async {
    String resultCodeCheck = '';
    final reqBody = WsActivitySearchReplyInfoReq.create(
      type: '0',
      page: replyPage.toString(),
      feedReplyId: feedsId,
    );
    final WsActivitySearchReplyInfoRes res = await ref.read(activityWsProvider).wsActivitySearchReplyInfo(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      final List<ActivityReplyInfo> list = res.list ?? [];
      if (list.isEmpty) noMoreReply = true;
      if (replyPage == 1) {
        replyList.clear();
        replyList.addAll(list);
      } else {
        replyList.addAll(list);
      }
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }

    await Future.delayed(const Duration(milliseconds: 100));
    isLoading = false;
    setState(() {});
  }

  // 發出留言
  Future<void> sendReplyMessage(num feedsId, String postUserName, String personalUserName) async {


    // 女生需真人認證、實名認證
    bool permissionResult = permissionCheck();
    if (!permissionResult) {
      AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

      DialogUtil.popupRealPersonDialog(theme:theme,context: context, description: '您还未通过真人认证与实名认证，认证完毕后方可发布贴文');
      return;
    }

    // 驗證資料有無
    final String content = richTextController.text;
    final String trimContent = content.trim();
    if (trimContent.isEmpty) return;

    // 審核中不要打後端(做假資料)
    final bool isBlock = ref.read(userInfoProvider).buttonConfigList?.blockType == 1 ? true : false;
    if (isBlock) {
      blockReply();
      return;
    }

    // Send API
    String resultCodeCheck = '';
    LoadingAnimation.showOverlayLoading(context);
    final WsActivityAddReplyReq reqBody = WsActivityAddReplyReq.create(
      type: replyType, // 留言類型 0:动态留言 1:回复留言
      content: content, // 留言
      feedReplyId: feedReplyId, // 留言回復 ID
      freFeedId: feedsId, // 動態牆 ID
      userLocation: null,
      // feedUserName: postUserName,
      tagUserName: tagUserName,
    );

    final WsActivityAddReplyRes res = await ref.read(activityWsProvider).wsActivityAddReply(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      updateReplyCountHandler(feedsId); // 更新留言數
      resetToInitState(); // 重置狀態
      await getMainReplyList(feedsId); // 重新取得留言（待優化）
    } else {
      if (context.mounted) {
        resetToInitState(); // 重置狀態
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }
    LoadingAnimation.cancelOverlayLoading();
  }

  // 真人、實名檢查
  bool permissionCheck() {
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    final num realPersonAuth = ref.read(userInfoProvider).memberInfo?.realPersonAuth ?? 0;
    final num realNameAuth = ref.read(userInfoProvider).memberInfo?.realNameAuth ?? 0;
    String authResult = RealPersonNameAuthUtil.needBothAuth(gender, realPersonAuth, realNameAuth);
    return authResult == ResponseCode.CODE_SUCCESS ? true : false;
  }

  // 審核中跳假資料
  void blockReply() async {

    num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    String nickName = ref.read(userInfoProvider).memberInfo?.nickName ?? '';
    String avatarPath = ref.read(userInfoProvider).memberInfo?.avatarPath ?? '';
    num age = ref.read(userInfoProvider).memberInfo?.age ?? 0;
    String userName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    final now = DateTime.now();
    final timestampInMilliseconds = now.millisecondsSinceEpoch;


    ActivityReplyInfo fakeReply = ActivityReplyInfo(
      content: richTextController.text,
      replyCount: 0,
      gender: gender,
      nickName: nickName,
      avatar: avatarPath,
      createTime: DateTime.now().millisecondsSinceEpoch,
      age: age,
      userId: 0,
      userName: userName,
      id: timestampInMilliseconds,
    );

    replyList.insert(0, fakeReply);
    updateReplyCountHandler(feedReplyId!); // 更新留言數
    resetToInitState(); // 重置狀態
  }

  // 更新留言數 Handler
  void updateReplyCountHandler(num postId) {

    WsActivitySearchInfoRes? searchInfoRecommend = ref.read(userUtilProvider).activitySearchInfoRecommend ?? WsActivitySearchInfoRes();
    WsActivitySearchInfoRes? searchInfoSubscribe = ref.read(userUtilProvider).activitySearchInfoSubscribe ?? WsActivitySearchInfoRes();
    WsActivitySearchInfoRes? searchInfoPersonal = ref.read(userUtilProvider).activitySearchInfoPersonal ?? WsActivitySearchInfoRes();
    WsActivitySearchInfoRes? searchInfoTopics = ref.read(userUtilProvider).activitySearchInfoTopics ?? WsActivitySearchInfoRes();
    WsActivitySearchInfoRes? searchInfoOthers = ref.read(userUtilProvider).activitySearchInfoOthers ?? WsActivitySearchInfoRes();

    updateReplyCount(searchInfo: searchInfoRecommend, postId: postId ?? 0, updatePostReplyCount: (searchInfo) => ref.read(userUtilProvider.notifier).loadActivityInfoRecommend(searchInfo));
    updateReplyCount(searchInfo: searchInfoSubscribe, postId: postId ?? 0, updatePostReplyCount: (searchInfo) => ref.read(userUtilProvider.notifier).loadActivityInfoSubscribe(searchInfo));
    updateReplyCount(searchInfo: searchInfoPersonal, postId: postId ?? 0, updatePostReplyCount: (searchInfo) => ref.read(userUtilProvider.notifier).loadActivityInfoPersonal(searchInfo));
    updateReplyCount(searchInfo: searchInfoTopics, postId: postId ?? 0, updatePostReplyCount: (searchInfo) => ref.read(userUtilProvider.notifier).loadActivityInfoTopics(searchInfo));
    updateReplyCount(searchInfo: searchInfoOthers, postId: postId ?? 0, updatePostReplyCount: (searchInfo) => ref.read(userUtilProvider.notifier).loadActivityInfoOthers(searchInfo));

  }

  // 更新 Provider 裡的留言數
  void updateReplyCount({
    required WsActivitySearchInfoRes searchInfo,
    required num postId,
    required Function(WsActivitySearchInfoRes) updatePostReplyCount
  }) {
    final List<ActivityPostInfo> activityPostInfoList = searchInfo.list ?? [];

    // 查詢這個 provider 有沒有存在這個 postId
    final bool isContain = activityPostInfoList.any((info) => info.id == postId);
    if (isContain == false) return; // 不存在 return

    // 找到這篇貼文的 index，並更新狀態
    final int index = activityPostInfoList.indexWhere((info) => info.id == postId);
    final num replyCount = activityPostInfoList[index].replyCount ?? 0;

    activityPostInfoList[index].replyCount = replyCount + 1;
    searchInfo.list = activityPostInfoList;
    updatePostReplyCount(searchInfo);
  }
}