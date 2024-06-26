import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/member/ws_member_fate_online_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_fate_online_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_fate_recommend_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/task_manager/task_manager.dart';
class StrikeUpListOnlineTabViewModel {

  WidgetRef ref;
  ViewChange setState;

  StrikeUpListOnlineTabViewModel({
    required this.ref,
    required this.setState,
  });

  late TaskManager taskManager;
  // late List<FateListInfo> memberOnlineList = [];
  num currentPage = 1; // 頁數
  num currentOrderSeq = 1; // 排序
  num orderSeqMax = 4; // 排序最大值
  bool noMoreData = false; // 沒有更多資料
  num topListPage = 1;
  num totalPages = 1;

  init() {
    taskManager = TaskManager();
    refreshOnlineList();
  }

  dispose() {}

  // 在線-列表：刷新
  Future<void> refreshOnlineList() async {
    topListPage = 1;
    currentPage = 1;
    currentOrderSeq = 1;
    noMoreData = false;
    await _refreshOnlineList();
  }

  // 在線-列表：加載
  Future<void> fetchMoreOnlineList() async {
    currentPage++;
    await _fetchMoreOnlineList();
  }

  // 2-4 (Refresh)
  Future<void> _refreshOnlineList() async {
    String resultCodeCheck = '';
    final WsMemberFateOnlineReq reqBody = WsMemberFateOnlineReq.create(
      page: currentPage, orderSeq: currentOrderSeq,
      topListPage: topListPage,
      // totalPages: totalPages,
    );
    final WsMemberFateOnlineRes res = await ref.read(memberWsProvider).wsMemberFateOnline(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadStrikeUpListOnlineList(WsMemberFateOnlineRes()); // 清空在線列表
      final List<ChatBlockModel> blockList = ref.read(chatBlockModelNotifierProvider); // 讀取黑名單

      List<FateListInfo> tmpMemberOnlineList = [];
      List<FateListInfo> topList = res.topList ?? [];
      List<FateListInfo> list = res.list ?? [];
      num totalPages = res.totalPages ?? 0;

      if (topListPage < totalPages) topListPage++;

      currentOrderSeq = res.orderSeq ?? 1;
      currentPage = res.pageNumber ?? 1;

      // 過濾黑名單用戶
      topList = _filterBlockUser(blockList: blockList, list: topList);
      list = _filterBlockUser(blockList: blockList, list: list);

      // topList, list 加進列表
      tmpMemberOnlineList = [...topList, ...list];

      List<FateListInfo> originalList = ref.read(userInfoProvider).strikeUpListOnlineList?.list ?? [];
      tmpMemberOnlineList = [...originalList, ...tmpMemberOnlineList];

      // 移除重複的用戶 id
      tmpMemberOnlineList = _removeDuplicates(tmpMemberOnlineList);

      res.list = tmpMemberOnlineList;
      ref.read(userUtilProvider.notifier).loadStrikeUpListOnlineList(res);

      if (tmpMemberOnlineList.length < 10){
        _fetchMoreOnlineList();
      }

    } else {
      final BuildContext currentContext = BaseViewModel.getGlobalContext();
      if (currentContext.mounted) BaseViewModel.showToast(currentContext, ResponseCode.map[resultCodeCheck]!);
    }
  }

  // 2-4 (Fetch More)
  Future<void> _fetchMoreOnlineList() async {

    // 沒有資料將不再 fetch
    if (noMoreData) return;

    String resultCodeCheck = '';
    final WsMemberFateOnlineReq reqBody = WsMemberFateOnlineReq.create(
      page: currentPage, orderSeq: currentOrderSeq,
      topListPage: topListPage,
      // totalPages: totalPages,
    );
    final WsMemberFateOnlineRes res = await ref.read(memberWsProvider).wsMemberFateOnline(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {

      final List<ChatBlockModel> blockList = ref.read(chatBlockModelNotifierProvider); // 讀取黑名單

      List<FateListInfo> tmpMemberOnlineList = [];
      List<FateListInfo> list = res.list ?? [];
      List<FateListInfo> topList = res.topList ?? [];
      num totalPages = res.totalPages ?? 0;

      if (topListPage < totalPages) topListPage++;
      currentOrderSeq = res.orderSeq ?? 1;
      currentPage = res.pageNumber ?? 1;

      // 過濾黑名單用戶
      topList = _filterBlockUser(blockList: blockList, list: topList);
      list = _filterBlockUser(blockList: blockList, list: list);

      // topList, list 加進列表
      tmpMemberOnlineList = [...topList, ...list];

      List<FateListInfo> originalList = ref.read(userInfoProvider).strikeUpListOnlineList?.list ?? [];
      tmpMemberOnlineList = [...originalList, ...tmpMemberOnlineList]; // 原始列表 + 新的列表

      // 移除重複的用戶 id
      tmpMemberOnlineList = _removeDuplicates(tmpMemberOnlineList);

      res.list = tmpMemberOnlineList;
      ref.read(userUtilProvider.notifier).loadStrikeUpListOnlineList(res);

      if (currentOrderSeq > orderSeqMax) {
        setState(() => noMoreData = true);
        return;
      }

      if (tmpMemberOnlineList.isEmpty) {
        updatePage();
        return;
      }

      setState(() {});
    } else {
      final BuildContext currentContext = BaseViewModel.getGlobalContext();
      if (currentContext.mounted) BaseViewModel.showToast(currentContext, ResponseCode.map[resultCodeCheck]!);
    }
  }

  // 更新排序
  void updatePage() {
    if (currentOrderSeq >= orderSeqMax) {
      setState(() => noMoreData = true);
      return;
    }
    _fetchMoreOnlineList();
  }

  // 過濾黑名單
  List<FateListInfo> _filterBlockUser({required List<ChatBlockModel> blockList, required List<FateListInfo> list}) {
    list.removeWhere((info) {
      final bool isContain = blockList.any((blockInfo) => info.userName == blockInfo.userName);
      return isContain;
    });
    return list;
  }

  List<FateListInfo> _removeDuplicates(List<FateListInfo> items) {
    List<FateListInfo> uniqueItems = []; // uniqueList
    var uniqueIDs = items
        .map((e) => e.id)
        .toSet(); //list if UniqueID to remove duplicates
    uniqueIDs.forEach((e) {
      uniqueItems.add(items.firstWhere((i) => i.id == e));
    }); // populate uniqueItems with equivalent original Batch items
    return uniqueItems;//send back the unique items list
  }
}
