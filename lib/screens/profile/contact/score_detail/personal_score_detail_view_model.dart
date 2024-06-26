import 'package:frechat/models/ws_req/detail/ws_detail_search_list_coin_req.dart';
import 'package:frechat/models/ws_res/contact/ws_contact_search_friend_benefit_res.dart';
import 'package:frechat/models/ws_req/contact/ws_contact_search_friend_benefit_req.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/detail/ws_detail_search_list_coin_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:flutter/cupertino.dart';

import '../../../../system/util/date_format_util.dart';

class PersonalScoreDetailViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  PersonalScoreDetailViewModel({
    required this.ref,
    required this.setState,
    required this.context
  });

  List<ContactFriendListInfo> contactList = []; // 列表
  DateTime startTime =  DateTime.now().subtract(const Duration(days: 6)); // 開始時間, 預設 7 天前（含今天）
  DateTime endTime = DateTime.now(); // 結束時間
  int currentPage = 1; // 分頁


  init() {
    getContactFriendBenefitList();
  }

  // 查詢列表先回到預設狀態
  void resetToInitState(){
    currentPage = 1;
    contactList = [];
  }

  void refreshHandler() {
    resetToInitState();
    getContactFriendBenefitList();
  }

  void fetchMoreHandler() {
    currentPage++;
    getContactFriendBenefitList();
  }

  bool selectHandler(DateTime selectStart, DateTime selectEnd, int active) {

    // 今日日期
    DateTime todayDate =  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    // 開始時間, 結束時間
    DateTime startDate = DateTime(selectStart.year, selectStart.month, selectStart.day);
    DateTime endDate = DateTime(selectEnd.year, selectEnd.month, selectEnd.day);

    // 計算與今日的日期差距
    int startDateDifference = startDate.difference(todayDate).inDays;
    int endDateDifference = endDate.difference(todayDate).inDays;

    // 如果 startTime 或 endTime 超過 62 天前 -> false
    if (startDateDifference <= -62 || endDateDifference <= -62) {
      BaseViewModel.showToast(context, '计算区间不可超过 62 天');
      return false;
    }

    // 計算結束時間與開始時間的差距
    int startAndEndRangeDifference = endDate.difference(startDate).inDays;

    if (endDate.isBefore(startDate)) {
      if (active == 0) {
        startTime = selectStart;
        endTime = selectStart;
      } else {
        startTime = selectEnd;
        endTime = selectEnd;
      }
      setState(() {});
      return true;
    }

    // 時間間隔不能超過 31 天
    if (startAndEndRangeDifference.abs() >= 31) {
      BaseViewModel.showToast(context, '查询区间上限为1个月，请重新选择');
      return false;
    }

    return true;
  }

  Future<void> getContactFriendBenefitList() async {

    String resultCodeCheck = '';

    // YYYY-MM-DD 00:00:00
    final String startTimeFormatted = DateFormatUtil.getDateWithFirstSecondFormat(startTime);

    // YYYY-MM-DD 23:59:59
    final String endTimeFormatted = DateFormatUtil.getDateWithLastSecondFormat(endTime);

    // page
    final int page = currentPage;

    final WsContactSearchFriendBenefitReq reqBody = WsContactSearchFriendBenefitReq.create(
        page: page, size: 20, startTime: startTimeFormatted, endTime: endTimeFormatted
    );

    final WsContactSearchFriendBenefitRes res = await ref.read(contactWsProvider).wsContactSearchFriendBenefit(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );


    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      if (contactList.isEmpty) {
        contactList = res.list!;
      } else {
        contactList.addAll(res.list!);
      }
    } else if (resultCodeCheck == ResponseCode.CODE_CAN_NOT_FOUND_DATA){
      contactList = [];
    } else if (resultCodeCheck == ResponseCode.CODE_DATE_RANGE_NOT_EXCEED_62DAYS) {
      contactList = [];
    } else if (resultCodeCheck == ResponseCode.CODE_SEARCH_RANGE_NOT_EXCEED_31DAYS) {
      contactList = [];
    } else {
      if (context.mounted) BaseViewModel.showToast(context, resultCodeCheck);
      contactList = [];
    }
    setState(() {});
  }
}