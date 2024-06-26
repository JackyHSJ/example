
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/screens/user_info_view/user_info_view.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

class UserInfoViewPostsViewModel {

  final WidgetRef ref;
  final ViewChange setState;
  final BuildContext context;

  UserInfoViewPostsViewModel({
    required this.ref,
    required this.setState,
    required this.context,
  });

  List<ActivityPostInfo> feedingList = [];
  DisplayMode? displayMode;
  String? userName;

  void fetchMore() {
    ActivityPostInfo? lastPostInfo = feedingList.last;
    getPersonalActivityPost(lastPostInfo?.createTime);
  }

  // 加載更多
  void getPersonalActivityPost(num? createTime) async {
    String? oppositeUserName;
    if (displayMode != DisplayMode.personalInfo) oppositeUserName = userName;
    String resultCodeCheck = '';
    final WsActivitySearchInfoReq reqBody = WsActivitySearchInfoReq.create(type: '3', condition: '0', userName: oppositeUserName, searchTime: createTime);
    final WsActivitySearchInfoRes res = await ref.read(activityWsProvider).wsActivitySearchInfo(
      reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      _refreshActivityAllLikePostIdList(res.likeList??[]);
      if (displayMode != DisplayMode.personalInfo) {
        // 看別人
        // 只取審核過的貼文 list
        final List<ActivityPostInfo> verifyActivityList = res.list?.where((item) => item.status != 0).toList() ?? [];
        List<ActivityPostInfo> tmpList = [];
        tmpList = [...feedingList, ...?verifyActivityList];
        res.list = tmpList;
        await ref.read(userUtilProvider.notifier).loadActivityInfoOthers(res); // 存進 provider
        feedingList = ref.read(userInfoProvider).activitySearchInfoOthers?.list ?? [];
        setState((){});
      } else {
        // 看自己
        List<ActivityPostInfo> tmpList = [];
        tmpList = [...feedingList, ...?res.list];
        res.list = tmpList;
        await ref.read(userUtilProvider.notifier).loadActivityInfoPersonal(res); // 存進 provider
        feedingList = ref.read(userInfoProvider).activitySearchInfoPersonal?.list ?? [];
        setState((){});
      }
    } else {
      if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
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
}