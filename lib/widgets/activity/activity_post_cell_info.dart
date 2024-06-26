import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';
import 'package:frechat/screens/user_info_view/user_info_view.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/system/util/dialog_util.dart';
import 'package:frechat/system/util/real_person_name_auth_util.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/widgets/activity/cell/activity_post_cell_view_model.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/strike_up_list/buttons/original/strike_up_list_love_button.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ActivityPostCellInfo extends ConsumerStatefulWidget {
  const ActivityPostCellInfo({super.key, required this.postInfo, required this.viewModel});
  final ActivityPostInfo postInfo;
  final ActivityPostCellViewModel viewModel;
  @override
  ConsumerState<ActivityPostCellInfo> createState() => _ActivityPostCellInfoState();
}

class _ActivityPostCellInfoState extends ConsumerState<ActivityPostCellInfo> {
  ActivityPostInfo get postInfo => widget.postInfo;
  ActivityPostCellViewModel get viewModel => widget.viewModel;

  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    return SizedBox(
      height: WidgetValue.bigIcon,
      child: Row(
        children: [
          _avatarWidget(),
          _titleText(),
          _strikeUpButton()
        ],
      ),
    );
  }

  ///頭貼
  Widget _avatarWidget() {
    final String avatar = postInfo.avatar ?? '';
    final num gender = postInfo.gender ?? 0;
    final String userName =  postInfo.userName ?? '';
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        child: avatar == ''
            ? AvatarUtil.defaultAvatar(gender ,size: 32.w)
            : AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatar, size: 32.w),
      ),
      onTap: (){
        final bool isAlreadyStrikeUp = ref.read(strikeUpProvider).isAlreadyStrikeUp(userName: postInfo.userName ?? '');
        DisplayMode displayMode = DisplayMode.strikeUp;
        if(isAlreadyStrikeUp){
          displayMode = DisplayMode.strikeUp;
        }
        viewModel.getMemberInfo(userName: userName, onConnectSuccess: (res){
          if(context.mounted){
            BaseViewModel.pushPage(context, UserInfoView(memberInfo: res, searchListInfo: null, displayMode: displayMode)).then((value) => setState(() {}));
          }
        }, onConnectFail: (msg){

        });
      },
    );
  }
  ///標題
  Widget _titleText() {
    return Expanded(
      child: Row(
        children: [
          _postNameText(),
          SizedBox(width: WidgetValue.separateHeight),
          _genderTag(),
          SizedBox(width: WidgetValue.separateHeight),
          _certificationTag(),
          SizedBox(width: WidgetValue.separateHeight),
          _locationTag(fontSize: 12.sp, tagColor: AppColors.btnLightGrey, textColor: AppColors.btnDeepGrey),
          // _buildTag(title: 'VIP', tagColor: AppColors.mainYellow),
        ],
      ),
    );
  }
  ///標題 - 名字
  Widget _postNameText() {
    final String? name = (postInfo.nickName == null || postInfo.nickName == '') ? postInfo.userName : postInfo.nickName;
    return Text(ConvertUtil.truncateString('$name', 7), style:_appTextTheme.activityPostTitleTextStyle);
  }
  ///標題 - 性別標籤
  Widget _genderTag() {
    final num gender = postInfo.gender ?? 0;
    final num age = postInfo.age ?? 0;
    return IconTag.genderAge(gender: gender, age: age);
  }
  ///標題 - 認證標籤
  Widget _certificationTag() {
   return ImgUtil.buildFromImgPath('assets/images/icon_activity_realpeople.png', size: 16.w, fit: BoxFit.fitWidth);
  }
  ///標題 - 地區標籤
  Widget _locationTag({Color? textColor, double fontSize = 14, Color tagColor = Colors.transparent}) {
    String locationString = postInfo.userLocation ?? '';
    return Visibility(
      visible: locationString.isNotEmpty,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration:_appBoxDecorationTheme.tagTextBoxDecoration,
        child: Text(
          locationString,
          style:_appTextTheme.activityPostTagTextStyle,
        ),
      ),
    );
  }
  ///搭訕/心動 按鈕
  Widget _strikeUpButton() {
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    final String myUserName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    final String postUserName = postInfo.userName ?? '';
    return Visibility(
      visible: myUserName != postUserName,
      child: Consumer(builder: (context, ref, _) {
        final bool isAlreadyStrikeUp = ref.watch(strikeUpProvider).isAlreadyStrikeUp(userName: postInfo.userName ?? '');
        return StrikeUpListLoveButton(
          isChat: isAlreadyStrikeUp,
          gender: gender,
          height: 28.h,
          width: 60.w,
          onStrikeUpPress: () async {
            final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
            final num realPersonAuth = ref.read(userInfoProvider).memberInfo!.realPersonAuth ?? 0;
            final num realNameAuth = ref.read(userInfoProvider).memberInfo!.realNameAuth ?? 0;
            String authResult = await RealPersonNameAuthUtil.needBothAuth(gender, realPersonAuth, realNameAuth);
            /// 判斷是否有真人與實名認證
            if (authResult != ResponseCode.CODE_SUCCESS) {
              _showRealPersonDialog();
              return;
            }
            viewModel.strikeUp(userName: postInfo.userName ?? '',onFail: (msg){
              if(msg ==  ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH){
                _showRechargeDialog();
              }
              if(msg == ResponseCode.CODE_REAL_PERSON_VERIFICATION_UNDER_REVIEW || msg == ResponseCode.CODE_REAL_NAME_UNDER_REVIEW){
                _showRealPersonDialog();
                BaseViewModel.showToast(context, '${ResponseCode.map[msg]}');
              }
            });
          },
          onChatPress: () async {
            SearchListInfo? searchListInfo= await viewModel.openChatRoom(userName: postInfo.userName ?? '');
            if (searchListInfo != null && context.mounted) {
              BaseViewModel.pushPage(context,ChatRoom(unRead: 0, searchListInfo: searchListInfo));
            }
          },
        );
      }),
    );
  }

  /// 真人認證彈窗
  void _showRealPersonDialog(){
    final currentContext = BaseViewModel.getGlobalContext();
    final AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    DialogUtil.popupRealPersonDialog(theme:theme,context: currentContext, description: '您还未通过真人认证与实名认证，认证完毕后方可传送心动 / 搭讪');
  }

  /// 充值彈窗
  void _showRechargeDialog() {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    // 充值次數
    final num rechargeCounts =  ref.read(userInfoProvider).memberPointCoin?.depositCount ?? 0;
    // 如果充值次數為 0
    if (rechargeCounts == 0) {
      RechargeUtil.showFirstTimeRechargeDialog('余额不足，请先充值'); // 開啟首充彈窗
    } else {
      RechargeUtil.showRechargeBottomSheet(theme: theme); // 開啟充值彈窗
    }
  }

}