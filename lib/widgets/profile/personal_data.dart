import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/account/ws_account_follow_and_fans_list_req.dart';
import 'package:frechat/models/ws_req/visitor/ws_visitor_list_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_follow_and_fans_list_res.dart';
import 'package:frechat/models/ws_res/visitor/ws_visitor_list_res.dart';
import 'package:frechat/screens/profile/deposit/personal_deposit.dart';
import 'package:frechat/screens/profile/friend/personal_friend.dart';
import 'package:frechat/screens/profile/visitor/personal_visitor.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import '../theme/original/app_colors.dart';
import 'package:focus_detector/focus_detector.dart';

class PersonalData extends ConsumerStatefulWidget {

  const PersonalData({
    super.key
  });

  @override
  ConsumerState<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends ConsumerState<PersonalData> {

  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;

    return FocusDetector(
      onFocusGained: () async {
        await _getFollowAndFans(type: 1);
        await _getFollowAndFans(type: 2);
        _getVisitor();
      },
      child: Consumer(builder: (context, ref, _){
        final num follow = ref.watch(userInfoProvider).followList?.fullListSize ?? 0;
        final num fans = ref.watch(userInfoProvider).fansList?.fullListSize ?? 0;
        final num visitorCount = ref.watch(userInfoProvider).visitorList?.fullListSize ?? 0;
        final bool isGirl = ref.read(userInfoProvider).memberInfo?.gender == 0;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: _buildDataCell('关注', follow, true, 0)),
              SizedBox(width: WidgetValue.horizontalPadding,),
              Expanded(child: _buildDataCell('粉丝', fans, true, 1)),
              ///访客
              (isGirl) ? SizedBox(width: WidgetValue.horizontalPadding,) : SizedBox(),
              (isGirl) ? Expanded(child: _buildDataCell('访客', visitorCount, false, null)) : SizedBox(),
            ],
          ),
        );
      })
    );
  }

  Widget _buildDataCell(String title, num data, bool isTab, int? tabBarIndex) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius)
        ),
        child: Column(
          children: [
            Text('$data', style: TextStyle(color: _appColorTheme.personalProfilePrimaryTextColor, fontWeight: FontWeight.w800, fontSize: 18)),
            Text(title, style: TextStyle(color: _appColorTheme.personalProfilePrimaryTextColor, fontWeight: FontWeight.w400, fontSize: 14)),
          ],
        ),
      ),
      onTap: (){
        if(isTab){
          BaseViewModel.pushPage(context, PersonalFriend(tabBarIndex: tabBarIndex));
        }else{
          BaseViewModel.pushPage(context, PersonalVisitor());
        }
      },
    );
  }

  /// 1:关注列表,2:粉丝列
  Future<void> _getFollowAndFans({
    required int type,
  }) async {
    String? resultCodeCheck;
    final WsAccountFollowAndFansListReq reqBody = WsAccountFollowAndFansListReq.create(type: type);
    final res = await ref.read(accountWsProvider).wsAccountFollowAndFansList(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      if(type == 1) {
        ref.read(userUtilProvider.notifier).loadFollowList(res);
      }
      if(type == 2) {
        ref.read(userUtilProvider.notifier).loadFansList(res);
      }
    }
  }

  /// 訪客
  Future<void> _getVisitor({
    String page = '1'
  }) async {
    final bool isBoy = ref.read(userInfoProvider).memberInfo?.gender == 1;
    if(isBoy) {
      return;
    }
    String? resultCodeCheck;
    final WsVisitorListReq reqBody = WsVisitorListReq.create(page: page);
    final WsVisitorListRes res = await ref.read(visitorWsProvider).wsVisitorList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadVisitorList(res);
    }
  }
}
