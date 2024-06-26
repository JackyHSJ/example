import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_req/account/ws_account_follow_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_follow_and_fans_list_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_follow_res.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_list_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/screens/user_info_view/user_info_view.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/system/util/dialog_util.dart';
import 'package:frechat/system/util/real_person_name_auth_util.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/system/util/tag_icon_util.dart';
import 'package:frechat/widgets/profile/cell/personal_friend_cell/personal_friend_cell_view_model.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/tag_text.dart';
import 'package:frechat/widgets/strike_up_list/buttons/original/strike_up_list_love_button.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../constant_value.dart';
import '../../../theme/original/app_colors.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

class PersonalFriendCell extends ConsumerStatefulWidget {

  final AccountListInfo model;
  final PersonalFreindType type;

  const PersonalFriendCell({
    super.key,
    required this.model,
    required this.type
  });

  @override
  ConsumerState<PersonalFriendCell> createState() => _PersonalFriendCellState();
}

class _PersonalFriendCellState extends ConsumerState<PersonalFriendCell> {

  late AppTheme _theme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;
  late PersonalFriendCellViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = PersonalFriendCellViewModel(setState: setState, ref: ref, context: context);
  }

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;

    return Row(
      children: [
        _buildFriendAvatar(),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNickNameAgeCer(),
              _buildTags(),
              _buildIntro()
            ],
          ),
        ),
        SizedBox(width: 10.w),
        _buildBtn()
      ],
    );
  }

  Widget _buildFriendAvatar() {
    final String avatarPath = widget.model.avatar ?? '';
    final num gender = widget.model.gender ?? 0;

    return InkWell(
      child: avatarPath.isNotEmpty
        ? AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatarPath, size: 64.w)
        : AvatarUtil.defaultAvatar(gender, size: 64.w),
      onTap: () async {
        Map map = await viewModel.getInfoAndGoUserInfoView(widget.model.userName ?? '', widget.model.roomId ?? 0);
        WsMemberInfoRes memberInfoRes = map['memberInfoRes'];
        WsNotificationSearchListRes notificationSearchListRes = map['notificationSearchListRes'];
        if(mounted && memberInfoRes!= null && notificationSearchListRes!= null ){
          BaseViewModel.pushPage(
              context,
              UserInfoView(
                memberInfo: memberInfoRes,
                searchListInfo: notificationSearchListRes.list![0],
                displayMode: DisplayMode.chatMessage,
              ));
        }
      }
    );
  }

  Widget _buildNickNameAgeCer() {
    final nickName = widget.model.nickName ?? '';
    final num age = widget.model.age ?? 0;
    final num gender = widget.model.gender ?? 0;
    final bool isRealNameAuth = widget.model.realNameAuth == 1 ? true : false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          _buildName(nickName),
          SizedBox(width: 4.w),
          IconTag.genderAge(gender: gender, age: age),
          SizedBox(width: 4.w),
          _buildRealNameAuth(isRealNameAuth)
        ],
      ),
    );
  }

  Widget _buildTags() {
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: _buildTag());
  }

  Widget _buildTag() {
    final num? height = widget.model.height;
    final num? weight = widget.model.weight;
    final String? occupation = widget.model.occupation;

    List<Widget> tagList = [];

    if (height != null) {
      tagList.add(TagText(text: '${height} cm',));
    }

    if (weight != null) {
      tagList.add(TagText(text: '${weight} kg',));
    }

    if (occupation != null) {
      tagList.add(TagText(text: '${occupation}',));
    }

    return Row(
      children: tagList
    );
  }

  Widget _buildIntro() {

    String selfIntroduction = widget.model.selfIntroduction ?? '';
    if (selfIntroduction.isEmpty) selfIntroduction = '这个用户还在火星，请呼喊他的名字';
    selfIntroduction = selfIntroduction.replaceAll("\n", " ");

    return Text(
      selfIntroduction.trim(),
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: _appColorTheme.friendSecondaryTextColor,
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
    );
  }

  Widget _buildBtn() {
    if (widget.type == PersonalFreindType.follow) {
      return _buildFollowBtn();
    } else {
      return _strikeUpButton(widget.model);
    }
  }

  Widget _buildFollowBtn() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
            color: (viewModel.isFollow) ? AppColors.textBlack : null,
            gradient: (viewModel.isFollow)
                ? null
                : AppColors.pinkLightGradientColors,
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius)),
        child: Text((viewModel.isFollow) ?'已关注' : '关注',
            style: const TextStyle(fontSize: 12, color: AppColors.textWhite)),
      ),
      onTap: () async {
        viewModel.followFunction( widget.model.id ?? 0);
      },
    );
  }

  Widget _buildName(String name) {
    return Text(
      name,
      style: TextStyle(
        color: _appColorTheme.friendPrimaryTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildRealNameAuth(bool result) {

    if (!result) return SizedBox();

    return ImgUtil.buildFromImgPath(_appImageTheme.iconTagRealName, size: 16.w);
  }

  // 搭訕/心動 按鈕
  Widget _strikeUpButton(AccountListInfo accountListInfo) {
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    final String myUserName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    final String postUserName = accountListInfo.userName ?? '';
    return Visibility(
      visible: myUserName != postUserName,
      child: Consumer(builder: (context, ref, _) {
        final bool isAlreadyStrikeUp = ref.watch(strikeUpProvider).isAlreadyStrikeUp(userName: accountListInfo.userName ?? '');
        return StrikeUpListLoveButton(
          isChat: isAlreadyStrikeUp,
          gender: gender,
          height: 28.h,
          width: 60.w,
          onStrikeUpPress: () async {
            viewModel.strikeUp(userName: accountListInfo.userName ?? '');
          },
          onChatPress: () async {
            viewModel.openChatRoom(userName: accountListInfo.userName ?? '');
          },
        );
      }),
    );
  }

}
