

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_req/account/ws_account_follow_and_fans_list_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_follow_and_fans_list_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/real_person_name_auth_util.dart';

class ActivityBrowserViewModel {

  WidgetRef ref;
  ViewChange setState;
  TickerProvider tickerProvider;

  ActivityBrowserViewModel({
    required this.setState,
    required this.ref,
    required this.tickerProvider
  });

  late TabController tabController;
  // late PageController pageController;
  List<Tab> tabList = [];

  init() {
    tabList = [
      // _fitTab(text: '同城'),
      _fitTab(text: '推荐'),
      _fitTab(text: '关注')
    ];
    tabController = TabController(length: tabList.length, vsync: tickerProvider);
  }

  dispose() {
    tabController.dispose();
  }

  _fitTab({
    required String text
  }) {
    return Tab(
      child: FittedBox(
        child: Text(text),
      ),
    );
  }

  void onTapPostButton(BuildContext context, {
    Function()? onShowRealPersonDialog,
    Function()? onPushToAddPostPage,
  }) async {
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    final num realPersonAuth = ref.read(userInfoProvider).memberInfo!.realPersonAuth ?? 0;
    final num realNameAuth = ref.read(userInfoProvider).memberInfo!.realNameAuth ?? 0;
    String authResult = await RealPersonNameAuthUtil.needBothAuth(gender, realPersonAuth, realNameAuth);
    /// 判斷是否有真人與實名認證
    if (authResult != ResponseCode.CODE_SUCCESS) {
      onShowRealPersonDialog?.call();
      return;
    }
    /// 判斷是否超過發文限制時間（1小時）
    final int getLastPostTime = await FcPrefs.getLastPostTime();
    if (getLastPostTime!=0) {
      DateTime lastPostTime = DateTime.fromMillisecondsSinceEpoch(getLastPostTime);
      DateTime currentTime = DateTime.now();
      Duration difference = currentTime.difference(lastPostTime);
      if (difference.inHours < 1) {
        if(context.mounted) BaseViewModel.showToast(context, '一小时内只能发一篇文，请稍候再试');
        return;
      }
    }

    if (context.mounted) onPushToAddPostPage?.call();

  }
}