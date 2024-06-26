

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
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/date_format_util.dart';
import 'package:frechat/widgets/activity/activity_post_util.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:rich_text_controller/rich_text_controller.dart';


class ActivityPostDetailReplyListViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  ActivityPostDetailReplyListViewModel({
    required this.setState,
    required this.ref,
    required this.context
  });

  ActivityPostInfo? postInfo;
  // num replyType = 1;
  num replyCount = 0;
  List<ActivityReplyInfo> subReplyList = []; // 第二層留言列表
  bool isSubReplyListOpen = false; // 第二層留言是否被打開
  bool isSubReplyListLoading = false; // 第二層留言 loading
  num subReplyPage = 1;
  bool mainReplyDeleted = false; // 第一層留言已經被刪除

  // 取得第二層留言
  Future<void> getSubReplyList(num replyId) async {
    String resultCodeCheck = '';
    final WsActivitySearchReplyInfoReq reqBody = WsActivitySearchReplyInfoReq.create(
      type: '1',
      page: subReplyPage.toString(),
      feedReplyId: replyId, // 上一層的留言 id
    );

    final WsActivitySearchReplyInfoRes res = await ref.read(activityWsProvider).wsActivitySearchReplyInfo(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        subReplyList = res.list!;
        isSubReplyListLoading = false;
        isSubReplyListOpen = true;
      });
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }
  }

  // 刪除留言(只有自己才能刪除自己的留言)
  Future<void> deletePersonalReply(num feedReplyId, num type) async {

    // 審核中不要打後端(做假資料)
    final bool isBlock = ref.read(userInfoProvider).buttonConfigList?.blockType == 1 ? true : false;
    if (isBlock) {
      deleteBlockReply();
      return;
    }

    String resultCodeCheck = '';
    final WsActivityDeleteReplyReq reqBody = WsActivityDeleteReplyReq.create(id: feedReplyId);
    final WsActivityDeleteReplyRes res = await ref.read(activityWsProvider).wsActivityDeleteReply(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      if (context.mounted) {
        BaseViewModel.popPage(context);

        if (type == 0) {
          mainReplyDeleted = true;
          num deleteCount = replyCount + 1;
          updateReplyCountHandler(deleteCount);
        } else {
          subReplyList.removeWhere((item) => item.id == feedReplyId);
          replyCount = replyCount - 1;
          updateReplyCountHandler(1);
        }
        setState((){});
      }
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }
  }

  // 舉報別人的留言
  Future<void> reportOthersReply(num replyId, ReportListInfo reportListInfo, String reportText, num userId) async {
    String resultCodeCheck = '';
    String tId = await FcPrefs.getCommToken();
    final AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    final ReportUserReq req = ReportUserReq.create(
      tId: tId,
      type: 3,
      remark: reportText,
      reportSettingId: reportListInfo.id ?? 0,
      feedReplyId: replyId,
      userId: userId,
    );

    LoadingAnimation.showOverlayLoading(context);
    final ReportUserRes? res = await ref.read(commApiProvider).reportUser(req,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ActivityPostUtil.reportReplyConfirmDialog(theme,context); // 成功後跳出確認彈窗
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }
    LoadingAnimation.cancelOverlayLoading();
  }

  void deleteBlockReply() {
    mainReplyDeleted = true;
    num deleteCount = replyCount + 1;
    updateReplyCountHandler(deleteCount);
    BaseViewModel.popPage(context);
  }

  void updateReplyCountHandler(num deleteCount) {
    WsActivitySearchInfoRes? searchInfoRecommend = ref.read(userUtilProvider).activitySearchInfoRecommend ?? WsActivitySearchInfoRes();
    WsActivitySearchInfoRes? searchInfoSubscribe = ref.read(userUtilProvider).activitySearchInfoSubscribe ?? WsActivitySearchInfoRes();
    WsActivitySearchInfoRes? searchInfoPersonal = ref.read(userUtilProvider).activitySearchInfoPersonal ?? WsActivitySearchInfoRes();
    WsActivitySearchInfoRes? searchInfoTopics = ref.read(userUtilProvider).activitySearchInfoTopics ?? WsActivitySearchInfoRes();
    WsActivitySearchInfoRes? searchInfoOthers = ref.read(userUtilProvider).activitySearchInfoOthers ?? WsActivitySearchInfoRes();

    updateReplyCount(searchInfo: searchInfoRecommend,feedsId: postInfo?.id ?? 0, deleteCount: deleteCount, updatePostReplyCount: (searchInfo) => ref.read(userUtilProvider.notifier).loadActivityInfoRecommend(searchInfo));
    updateReplyCount(searchInfo: searchInfoSubscribe,feedsId: postInfo?.id ?? 0, deleteCount: deleteCount, updatePostReplyCount: (searchInfo) => ref.read(userUtilProvider.notifier).loadActivityInfoSubscribe(searchInfo));
    updateReplyCount(searchInfo: searchInfoPersonal,feedsId: postInfo?.id ?? 0, deleteCount: deleteCount, updatePostReplyCount: (searchInfo) => ref.read(userUtilProvider.notifier).loadActivityInfoPersonal(searchInfo));
    updateReplyCount(searchInfo: searchInfoTopics,feedsId: postInfo?.id ?? 0, deleteCount: deleteCount, updatePostReplyCount: (searchInfo) => ref.read(userUtilProvider.notifier).loadActivityInfoTopics(searchInfo));
    updateReplyCount(searchInfo: searchInfoOthers,feedsId: postInfo?.id ?? 0, deleteCount: deleteCount, updatePostReplyCount: (searchInfo) => ref.read(userUtilProvider.notifier).loadActivityInfoOthers(searchInfo));
  }

  void updateReplyCount({
    required WsActivitySearchInfoRes searchInfo,
    required num feedsId,
    required Function(WsActivitySearchInfoRes) updatePostReplyCount,
    required deleteCount
  }) {
    final List<ActivityPostInfo> activityPostInfoList = searchInfo.list ?? [];

    // 查詢這個 provider 有沒有存在這個 postId
    final bool isContain = activityPostInfoList.any((info) => info.id == feedsId);
    if (isContain == false) return; // 不存在 return

    // 找到這篇貼文的 index，並更新狀態
    final int index = activityPostInfoList.indexWhere((info) => info.id == feedsId);
    final num replyCount = activityPostInfoList[index].replyCount ?? 0;

    activityPostInfoList[index].replyCount = replyCount - deleteCount;
    searchInfo.list = activityPostInfoList;
    updatePostReplyCount(searchInfo);
  }

  /// 取得貼文時間
  String getPostTime( int postTime){
    // final int postTime = postInfo.createTime?.toInt() ?? 0;
    final DateTime currentDateTime = DateTime.now();
    final DateTime postDateTime = DateTime.fromMillisecondsSinceEpoch(postTime);
    Duration difference = currentDateTime.difference(postDateTime);
    if (difference.inMinutes < 1) {
      return '${difference.inSeconds}秒前';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 12) {
      return '${difference.inHours}小时前';
    } else if (difference.inHours < 24) {
      return DateFormatUtil.getDateWith12HourTimeFormat(postDateTime);
    } else if (difference.inHours < 48) {
      return '昨天 ${DateFormatUtil.getDateWith12HourTimeFormat(postDateTime)}';
    } else {
      return DateFormatUtil.getDateWith12HourFormat(postDateTime);
    }
  }
}