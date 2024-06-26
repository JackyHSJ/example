import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/account/ws_account_follow_and_fans_list_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_follow_and_fans_list_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

class ActivitySubscribeTabViewModel {

  WidgetRef ref;
  ViewChange setState;
  TabController tabController;
  ActivitySubscribeTabViewModel({
    required this.setState,
    required this.ref,
    required this.tabController,
  });

  late List<ActivityPostInfo> subscribePostlist = [];
  late num searchTime;

  init() {
    subscribePostlist = ref.read(userInfoProvider).activitySearchInfoSubscribe?.list ??[];
    searchTime =  DateTime.now().millisecondsSinceEpoch;

  }

  dispose() {}

  /// 切換動態牆頁面
  void switchTabPage({required int index}){
    tabController.animateTo(index);
  }

  Future<void> activityPostRefresh() async {
    searchTime =  DateTime.now().millisecondsSinceEpoch;
    await _reloadActivityPost(true);
  }

  Future<void> activityPostFetchMore() async {
    final List<ActivityPostInfo> postInfolist = ref.read(userInfoProvider).activitySearchInfoSubscribe?.list ?? [];
    ActivityPostInfo postInfo = postInfolist.last;
    searchTime = postInfo.createTime ?? DateTime.now().millisecondsSinceEpoch;
    // searchTime = 1709626109054;
    await _reloadActivityPost(false);
  }

  /// 更新動態牆貼文列表（關注動態）
  Future<void> _reloadActivityPost(bool isRefresh) async {
    await _loadActivityInfo(isRefresh:isRefresh,type: WsActivitySearchInfoType.subscribe, condition: '0');
  }

  /// 載入動態牆（19-1）
  Future<void> _loadActivityInfo({required bool isRefresh,required WsActivitySearchInfoType type, required String condition}) async {
    String? resultCodeCheck;
    num? userGender = await ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    userGender == 0 ? userGender = 1 : userGender = 0; // 取跟自己相反的 gender
    String typeString = WsActivitySearchInfoType.values.indexOf(type).toString();
    final WsActivitySearchInfoReq reqBody = WsActivitySearchInfoReq.create(type: typeString, condition: condition,gender: userGender,searchTime: searchTime);
    final WsActivitySearchInfoRes res = await ref.read(activityWsProvider).wsActivitySearchInfo(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg){
        }
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      res.type = type;
      _refreshActivityAllLikePostIdList(res.likeList??[]);
      /// 更新粉絲列表
      ///下拉刷新時，直接更新動態貼文列表
      ///載入更多時，則是新增至前一頁動態貼文列表中
      await _loadFallowList();
      if(!isRefresh){
        late List<ActivityPostInfo> nextPostList = res.list??[];
        subscribePostlist.addAll(nextPostList);
        res.list = subscribePostlist;
      }
      /// 更新關注動態貼文
      ref.read(userUtilProvider.notifier).loadActivityInfoSubscribe(res);
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

  /// 載入關注/粉絲列表（5-2）
  Future<void> _loadFallowList() async {
    String? resultCodeCheck;
    final WsAccountFollowAndFansListReq reqBody = WsAccountFollowAndFansListReq.create(
        type: 1
    );
    final WsAccountFollowAndFansListRes res = await ref.read(accountWsProvider).wsAccountFollowAndFansList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) {}
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadFollowList(res);
    }
  }
}