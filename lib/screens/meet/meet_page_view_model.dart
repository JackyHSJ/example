

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/member/ws_member_fate_recommend_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_fate_recommend_res.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/timer.dart';

class MeetPageViewModel {
  MeetPageViewModel({
    required this.ref,
    required this.setState
  });

  WidgetRef ref;
  ViewChange setState;

  num currentPage = 2;
  num currentTopListPage = 1;
  num currentOrderSeq = 1;
  Timer? _recommendListTimer;

  void init() {
  }

  void dispose() {

  }

  Future<WsMemberFateRecommendRes?> _getRecommendList() async {
    final WsMemberFateRecommendRes? memberFateRecommend = ref.read(userInfoProvider).meetCardRecommendList;
    final num orderSeq = memberFateRecommend?.orderSeq ?? 0;
    /// orderSeq type = 5 結束載入更多
    if(orderSeq == 5) {
      return null;
    }

    _checkAndAddPage(memberFateRecommend);

    String? resultCodeCheck;
    final WsMemberFateRecommendReq reqBody = WsMemberFateRecommendReq.create(
      page: currentPage, orderSeq: currentOrderSeq,
      topListPage: currentTopListPage,
      // totalPages: totalPages,
    );

    final WsMemberFateRecommendRes res = await ref.read(memberWsProvider).wsMemberFateRecommend(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      /// list為空, 則orderSeq + 1
      if(res.list?.isEmpty == true) {
        _addOrderSeqAndResend();
      }

      memberFateRecommend?.list?.insertAll(0, res.list ?? []);
      ref.read(userUtilProvider.notifier).loadMeetCardRecommendList(memberFateRecommend ?? WsMemberFateRecommendRes());
      return res;
    }

    return null;
  }

  _addOrderSeqAndResend() {
    currentOrderSeq++;
    currentPage = 0;
    _getRecommendList();
  }

  _checkAndAddPage(WsMemberFateRecommendRes? memberFateRecommend) {
    currentPage++;
    final num totalPages = memberFateRecommend?.totalPages ?? 0;
    if(currentTopListPage < totalPages) {
      currentTopListPage++;
    }
  }

  void removeTopRecommend(List<FateListInfo> list) {
    list.removeLast();
    _checkAndLoadMoreRecommendList(list);

    if(list.isEmpty) setState((){});
  }

  /// 當數量少於10筆則重新取得數據
  Future<void> _checkAndLoadMoreRecommendList(List<FateListInfo> list) async {
    print('${list.length}');
    if(list.length < 10) {
      _initRecommendListTimer();
    }
  }

  _initRecommendListTimer() {
    if(_recommendListTimer != null) {
      return ;
    }
    _recommendListTimer = TimerUtil.periodic(timerType: TimerType.seconds, timerNum: 5, timerCallback: (timer) => _onTimerCallBack());
    _onTimerCallBack();
  }

  _onTimerCallBack() async {
    final WsMemberFateRecommendRes? res = await _getRecommendList();
    if(res == null) {
      return ;
    }
    _disposeRecommendListTimer();
  }

  _disposeRecommendListTimer() {
    if(_recommendListTimer == null) {
      return ;
    }

    _recommendListTimer?.cancel();
    _recommendListTimer = null;
  }
}