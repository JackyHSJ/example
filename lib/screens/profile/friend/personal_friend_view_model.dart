

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/account/ws_account_follow_and_fans_list_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_follow_and_fans_list_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

class PersonalFriendViewModel {
  PersonalFriendViewModel({required this.ref, required this.setState, required this.tickerProvider});
  ViewChange setState;
  WidgetRef ref;

  late TabController tabController;
  TickerProvider tickerProvider;
  List<Tab> tabList = [Tab(text: '关注',), Tab(text: '粉丝')];

  WsAccountFollowAndFansListRes followList = WsAccountFollowAndFansListRes(list: []);
  WsAccountFollowAndFansListRes fansList = WsAccountFollowAndFansListRes(list: []);
  num followCurrentPage = 1;
  num fansCurrentPage = 1;

  init(BuildContext context,int tabBarIndex) async {
    tabController = TabController(length: tabList.length, vsync: tickerProvider);
    tabController.animateTo(tabBarIndex);
    /// getInfo
    await _getFollowAndFans(type: 1, page: followCurrentPage,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    await _getFollowAndFans(type: 2, page: fansCurrentPage,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
  }

  dispose() {
    tabController.dispose();
  }

  /// 1:关注列表,2:粉丝列
  Future<void> _getFollowAndFans({
    required int type,
    required num page,
    Function(String)? onConnectFail
  }) async {
    String? resultCodeCheck;
    final reqBody = WsAccountFollowAndFansListReq.create(
      type: type,
      page: '$page'
    );
    final WsAccountFollowAndFansListRes res = await ref.read(accountWsProvider).wsAccountFollowAndFansList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => onConnectFail?.call(errMsg)
    );

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS && type == 1) {
      final List<AccountListInfo> list = res.list ?? [];
      followList.list?.addAll(list);
      final resultList =  followList.list?.where((info) => info.userName != null).toList();
      followList.list?.clear();
      followList.list?.addAll(resultList!);
      await ref.read(userUtilProvider.notifier).loadFollowList(res.copyWith(list: followList.list));
    }

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS && type == 2) {
      final List<AccountListInfo> list = res.list ?? [];
      fansList.list?.addAll(list);
      final resultList =  fansList.list?.where((info) => info.userName != null).toList();
      fansList.list?.clear();
      fansList.list?.addAll(resultList!);
      await ref.read(userUtilProvider.notifier).loadFansList(res.copyWith(list: fansList.list));
    }
  }

  fallowOnRefresh() {

  }

  fallowOnFetchMore(BuildContext context) {
    followCurrentPage++;
    _getFollowAndFans(type: 1, page: followCurrentPage,
      onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
  }

  fansOnRefresh() {

  }

  fansOnFetchMore(BuildContext context) {
    fansCurrentPage++;
    _getFollowAndFans(type: 2, page: fansCurrentPage,
      onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
  }
}