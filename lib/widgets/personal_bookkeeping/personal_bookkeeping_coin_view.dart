
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frechat/models/ws_req/detail/ws_detail_search_list_coin_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_gift_detail_res.dart';
import 'package:frechat/models/ws_res/detail/ws_detail_search_list_coin_res.dart';
import 'package:frechat/system/constant/enum.dart';

import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/util/date_format_util.dart';

import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/picker.dart';
import 'package:frechat/widgets/personal_bookkeeping/personal_bookkeeping_coin_income_list_item.dart';
import 'package:frechat/widgets/personal_bookkeeping/personal_bookkeeping_empty_hint.dart';
import 'package:frechat/widgets/strike_up_list/top_bottom_pull_loader.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

// import 'package:frechat/widgets/personal_bookkeeping/personal_bookkeeping_month_picker.dart';
// import 'package:frechat/widgets/shared/dialog/check_dialog.dart';

// 金幣列表
class PersonalBookkeepingCoinView extends ConsumerStatefulWidget {

  List<GiftListInfo> giftListInfo;

  PersonalBookkeepingCoinView({super.key, required this.giftListInfo});

  @override
  ConsumerState<PersonalBookkeepingCoinView> createState() => _PersonalBookkeepingCoinViewState();
}

class _PersonalBookkeepingCoinViewState extends ConsumerState<PersonalBookkeepingCoinView> with AfterLayoutMixin {

  List<DetailListInfo> searchList = [];
  DateTime startTime =  DateTime.now().subtract(const Duration(days: 6)); // 開始時間, 預設 7 天前（含今天）
  DateTime endTime = DateTime.now(); // 結束時間
  int currentPage = 1;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;

  @override
  void initState() {
    super.initState();
    getDetailSearchListCoinList();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    // refreshHandler();
  }

  // 查詢列表先回到預設狀態
  void resetToInitState(){
    currentPage = 1;
    searchList = [];
  }

  void refreshHandler() {
    resetToInitState();
    getDetailSearchListCoinList();
  }

  void fetchMoreHandler() {
    currentPage++;
    getDetailSearchListCoinList();
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

  // 查詢收支明細-金幣(7-1)
  Future<void> getDetailSearchListCoinList() async {
    String resultCodeCheck = '';

    // YYYY-MM-DD 00:00:00
    final String startTimeFormatted = DateFormatUtil.getDateWithFirstSecondFormat(startTime);

    // YYYY-MM-DD 23:59:59
    final String endTimeFormatted = DateFormatUtil.getDateWithLastSecondFormat(endTime);

    // currentPage
    final String page = currentPage.toString();

    final WsDetailSearchListCoinReq reqBody = WsDetailSearchListCoinReq.create(
        page: page, size: 20, startTime: startTimeFormatted, endTime: endTimeFormatted
    );

    final WsDetailSearchListCoinRes res = await ref.read(detailWsProvider).wsDetailSearchListCoin(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      if (searchList.isEmpty) {
        searchList = res.list!;
      } else {
        searchList.addAll(res.list!);
      }
    } else if (resultCodeCheck == ResponseCode.CODE_CAN_NOT_FOUND_DATA){
      resetToInitState();
    } else if (resultCodeCheck == ResponseCode.CODE_DATE_RANGE_NOT_EXCEED_62DAYS) {
      resetToInitState();
    } else if (resultCodeCheck == ResponseCode.CODE_SEARCH_RANGE_NOT_EXCEED_31DAYS) {
      resetToInitState();
    } else {
      if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      resetToInitState();
    }

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;

    return Column(
      children: [
        _buildTimePicker(),
        Expanded(child: TopBottomPullLoader(
          onRefresh: refreshHandler,
          onFetchMore: fetchMoreHandler,
          child: _buildListView())
        ),
      ],
    );
  }

  Widget _buildListView() {
    if (searchList.isNotEmpty) {
      return ListView.builder(
        itemCount: searchList.length,
        itemBuilder: (context, index) {
          if (index < searchList.length) {
            return PersonalBookkeepingCoinIncomeListItem(detailListInfo: searchList[index],giftListInfo: widget.giftListInfo,);
          } else {
            return const SizedBox();
          }
        },
      );
    } else {
      return Center(
        child: PersonalBookkeepingEmptyHint(
          onResetSearchPressed: () {
            startTime =  DateTime.now().subtract(const Duration(days: 6)); // 開始時間, 預設 7 天前（含今天）
            endTime = DateTime.now(); // 結束時間
            resetToInitState();
            refreshHandler();
          },
        ),
      );
    }
  }

  Widget _buildTimePicker() {
    final startTimeFormat = DateFormatUtil.getDateWith24HourFormat(startTime); // YYYY-MM-DD
    final endTimeFormat = DateFormatUtil.getDateWith24HourFormat(endTime); // YYYY-MM-DD

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: WidgetValue.separateHeight),
          child: Text('日期筛选', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _appColorTheme.pickerTextColor)),
        ),
        Row(
          children: [
            InkWell(
              onTap: () => Picker.showDatePicker(context,
                  initialDateTime: startTime,
                  appTheme: _theme,
                  onSelect: (date){
                    final bool result = selectHandler(date, endTime, 0);
                    if (result) {
                      startTime = date;
                      BaseViewModel.popPage(context);
                      resetToInitState();
                      getDetailSearchListCoinList();
                    }
                  },
                  onCancel: () => BaseViewModel.popPage(context)
              ),
              child: Row(
                children: [
                  Text(startTimeFormat, style: TextStyle(fontSize: 16, letterSpacing: -1, color: _appColorTheme.pickerTextColor)),
                  SizedBox(width: WidgetValue.separateHeight),
                  ImgUtil.buildFromImgPath('assets/profile/profile_date_picker_icon.png', size: WidgetValue.smallIcon),
                ],
              ),
            ),
            Text(' ~ ', style: TextStyle(color: _appColorTheme.pickerTextColor)),
            InkWell(
              onTap: () => Picker.showDatePicker(context,
                  initialDateTime: endTime,
                  appTheme: _theme,
                  onSelect: (date){
                    final bool result = selectHandler(startTime, date, 1);
                    if (result) {
                      endTime = date;
                      BaseViewModel.popPage(context);
                      resetToInitState();
                      getDetailSearchListCoinList();
                    }
                  },
                  onCancel: () => BaseViewModel.popPage(context)
              ),
              child: Row(
                children: [
                  Text(endTimeFormat, style: TextStyle(fontSize: 16, letterSpacing: -1, color: _appColorTheme.pickerTextColor)),
                  SizedBox(width: WidgetValue.separateHeight),
                  ImgUtil.buildFromImgPath('assets/profile/profile_date_picker_icon.png', size: WidgetValue.smallIcon),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
