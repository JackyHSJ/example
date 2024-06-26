
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_block_group_res.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

class ActivityTopicsViewModel {

  WidgetRef ref;
  ViewChange setState;

  ActivityTopicsViewModel({
    required this.setState,
    required this.ref,
  });

  late List<ActivityPostInfo> topiscPostlist = [];
  late num searchTime;
  num topicId = 0;

  init(num id) {
    topicId = id;
    searchTime = DateTime.now().millisecondsSinceEpoch;
    _reloadActivityPost(true);
  }


  dispose() {}

  /// 下拉刷新動態列表
  Future<void> activityPostRefresh() async {
    searchTime =  DateTime.now().millisecondsSinceEpoch;
    await _reloadActivityPost(true);
  }
  /// 上滑載入更多
  Future<void> activityPostFetchMore() async {
    final List<ActivityPostInfo> postInfolist = ref.read(userInfoProvider).activitySearchInfoTopics?.list ?? [];
    ActivityPostInfo postInfo = postInfolist.last;
    searchTime = postInfo.createTime ?? DateTime.now().millisecondsSinceEpoch;
    await _reloadActivityPost(false);
  }

  /// 更新動態牆貼文列表（話題動態）
  Future<void> _reloadActivityPost(bool isRefresh) async {
    await _loadActivityInfo(isRefresh:isRefresh,type:WsActivitySearchInfoType.topics, condition: '0',topicId: topicId.toString());
  }

  /// 載入動態牆（19-1）
  Future<void> _loadActivityInfo({required bool isRefresh,required WsActivitySearchInfoType type, required String condition,required String topicId}) async {
    String? resultCodeCheck;
    num? userGender = await ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    userGender == 0 ? userGender = 1 : userGender = 0; // 取跟自己相反的 gender
    String typeString = WsActivitySearchInfoType.values.indexOf(type).toString();
    final WsActivitySearchInfoReq reqBody = WsActivitySearchInfoReq.create(type: typeString, condition: condition,gender: userGender,topicId: topicId,searchTime: searchTime);
    final WsActivitySearchInfoRes res = await ref.read(activityWsProvider).wsActivitySearchInfo(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg){}
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      res.type = type;
      _refreshActivityAllLikePostIdList(res.likeList??[]);
      ///移除以黑單的人的貼文
      final List<ChatBlockModel> blockList = ref.read(chatBlockModelNotifierProvider);
      final List<String?> blockUserNameList = blockList?.map((blockUser) => blockUser.userName).toList() ?? [];
      res.list?.removeWhere((info) => blockUserNameList.contains(info.userName));
      if(!isRefresh){
        late List<ActivityPostInfo> nextPostList = res.list??[];
        topiscPostlist.addAll(nextPostList);
        res.list = topiscPostlist;
      }else{
        topiscPostlist = res.list ??[];
      }
      ref.read(userUtilProvider.notifier).loadActivityInfoTopics(res);
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