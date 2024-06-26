
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_hot_topic_list_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_block_group_res.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

class ActivityRecommendTabViewModel {

  WidgetRef ref;
  ViewChange setState;

  ActivityRecommendTabViewModel({
    required this.setState,
    required this.ref,
  });

  late List<ActivityPostInfo> recommendPostlist = [];
  int currentPage = 1;
  int totalPages = 1;

  init() {
    recommendPostlist = ref.read(userInfoProvider).activitySearchInfoRecommend?.list ??[];
    totalPages = ref.read(userInfoProvider).activitySearchInfoRecommend?.totalPages?.toInt() ?? 1;
    currentPage = 1;
  }

  dispose() {}

  /// 取得顯示 推薦動態貼文
  List<ActivityPostInfo> getAllActivityPostInfoList(){
    final List<ActivityPostInfo> userPostList = GlobalData.cacheUserPostActivityPostInfoList ?? [];
    final List<ActivityPostInfo> list = ref.watch(userInfoProvider).activitySearchInfoRecommend?.list ?? [];
    final List<ActivityPostInfo> allList = userPostList + list;
    final List<ChatBlockModel> blockList = ref.watch(chatBlockModelNotifierProvider);
    final List<String?> blockUserNameList = blockList?.map((blockUser) => blockUser.userName).toList() ?? [];
    allList.removeWhere((info) => blockUserNameList.contains(info.userName));
    return allList;
  }

  /// 取得顯示 熱門動態貼文
  List<ActivityPostInfo> getHotTopicsList(){
    final List<ActivityPostInfo> hotTopicsList = ref.watch(userInfoProvider).activitySearchInfoHotTopics?.list ?? [];
    final List<ChatBlockModel> blockList = ref.watch(chatBlockModelNotifierProvider);
    final List<String?> blockUserNameList = blockList?.map((blockUser) => blockUser.userName).toList() ?? [];
    hotTopicsList.removeWhere((info) => blockUserNameList.contains(info.userName));
    return hotTopicsList;
  }
  /// 取得顯示 熱門話題標籤
  List<HotTopicListInfo> getHotTopicListInfoList(){
    final List<ActivityPostInfo> hotTopicsList = ref.read(userInfoProvider).activitySearchInfoHotTopics?.list ?? [];
    List<HotTopicListInfo> hotTopicListInfoList = ref.watch(userInfoProvider).activitySearchInfoHotTopics?.hotTopicList?? [];
    print(hotTopicListInfoList.length);
    hotTopicListInfoList.sort((firstObj, secondObj) {
      int firstSeq = int.parse(firstObj.topicSeq ?? '0');
      int secondSeq = int.parse(secondObj.topicSeq ?? '0');
      return firstSeq.compareTo(secondSeq);
    });
    ///判斷熱門話題中是否有貼文，無貼文則不顯示此話題
    hotTopicListInfoList = hotTopicListInfoList.where((info) => hotTopicsList.any((post) => post.topicId == info.topicId)).toList();
    return hotTopicListInfoList;
  }


  /// 下拉刷新動態列表
  Future<void> activityPostRefresh() async {
    currentPage = 1;
    await _reloadActivityPost(true,WsActivitySearchInfoType.recommend);
    // await _reloadActivityPost(true,WsActivitySearchInfoType.hotTopics);
  }
  /// 上滑載入更多
  Future<void> activityPostFetchMore() async {
    // if(currentPage >= totalPages) return;
    currentPage ++;
    await _reloadActivityPost(false,WsActivitySearchInfoType.recommend);
  }

  /// 更新動態牆貼文列表（推薦動態/熱門動態）
  Future<void> _reloadActivityPost(bool isRefresh,WsActivitySearchInfoType type) async {
    await _loadActivityInfo(isRefresh:isRefresh,type: type, condition: '0');
  }

  /// 載入動態牆（19-1）
  Future<void> _loadActivityInfo({required bool isRefresh,required WsActivitySearchInfoType type, required String condition}) async {
    String resultCodeCheck = '';
    num? userGender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    num gmType = ref.read(userInfoProvider).buttonConfigList?.gmType ?? 0;
    userGender == 0 ? userGender = 1 : userGender = 0; // 取跟自己相反的 gender
    if(gmType == 1) userGender = null; // 超管狀態下，顯示男女貼文
    String typeString = WsActivitySearchInfoType.values.indexOf(type).toString();
    final WsActivitySearchInfoReq reqBody = WsActivitySearchInfoReq.create(type: typeString, condition: condition, gender: userGender, pageNumber: currentPage);
    final WsActivitySearchInfoRes res = await ref.read(activityWsProvider).wsActivitySearchInfo(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      res.type = type;
      _refreshActivityAllLikePostIdList(res.likeList??[]);
      /// 移除以黑單的人的貼文
      final List<ChatBlockModel> blockList = ref.read(chatBlockModelNotifierProvider);
      final List<String?> blockUserNameList = blockList?.map((blockUser) => blockUser.userName).toList() ?? [];
      res.list?.removeWhere((info) => blockUserNameList.contains(info.userName));

      /// 更新推薦動態貼文
      if(type == WsActivitySearchInfoType.recommend){
        ///下拉刷新時，直接更新動態貼文列表
        ///載入更多時，則是新增至前一頁動態貼文列表中
        if(!isRefresh){
          late List<ActivityPostInfo> nextPostList = res.list??[];
          recommendPostlist.addAll(nextPostList);
          res.list = recommendPostlist;
        }
        GlobalData.cacheUserPostActivityPostInfoList = [];
        ref.read(userUtilProvider.notifier).loadActivityInfoRecommend(res);
      }
      // /// 更新熱門動態貼文
      // if(type == WsActivitySearchInfoType.hotTopics){
      //   ref.read(userUtilProvider.notifier).loadActivityInfoHotTopics(res);
      // }
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