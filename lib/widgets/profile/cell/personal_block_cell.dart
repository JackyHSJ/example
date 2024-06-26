
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/profile/setting/block/personal_setting_block.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/extension/chat_user_model.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../models/ws_res/notification/ws_notification_block_group_res.dart';
import '../../../screens/profile/setting/block/personal_setting_block_view_model.dart';
import '../../constant_value.dart';
import '../../theme/original/app_colors.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

class PersonalBlockCell extends ConsumerStatefulWidget {
  PersonalBlockCell({super.key, required this.viewModel, required this.model});
  PersonalSettingBlockViewModel viewModel;
  BlockListInfo model;

  @override
  ConsumerState<PersonalBlockCell> createState() => _PersonalBlockCellState();
}

class _PersonalBlockCellState extends ConsumerState<PersonalBlockCell> {
  BlockListInfo get model => widget.model;

  late AppTheme _theme;
  late AppColorTheme _appColorTheme;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;

    return Row(
      children: [
        _buildUserImg(),
        SizedBox(width: WidgetValue.horizontalPadding),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNickNameAndGender(),
            SizedBox(height: WidgetValue.separateHeight,),
            _buildDes()
          ],
        )),
        SizedBox(width: WidgetValue.horizontalPadding),
        _buildRemoveBtn()
      ],
    );
  }

  _buildUserImg() {
    return (model.filePath == null)
        ? AvatarUtil.defaultAvatar(model.gender ?? 0 ,size: 64.w)
        : AvatarUtil.userAvatar(HttpSetting.baseImagePath + model.filePath!, size: 64.w);
  }

  _buildNickNameAndGender() {
    final String nickName = model.nickName ?? model.userName ?? '';
    final num gender = model.gender ?? 0;
    final num age = model.age ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Text(nickName, style: TextStyle(fontWeight: FontWeight.w700, color: _appColorTheme.blockCellTitleTextColor, fontSize: 14),),
          const SizedBox(width: 2),
          IconTag.genderAge(gender: gender, age: age)
        ],
      ),
    );
  }

  _buildDes() {
    String selfIntroduction = model?.selfIntroduction ?? '';
    if (selfIntroduction.isEmpty) selfIntroduction = '沒有介紹';
    selfIntroduction = selfIntroduction.replaceAll("\n", " ");
    return Text(
      selfIntroduction.trim(),
      style: TextStyle(color: _appColorTheme.blockCellDesTextColor, fontWeight: FontWeight.w400, fontSize: 12),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  _buildRemoveBtn() {
    return InkWell(
      onTap: () {
        // 通話中不可發起新通話
        final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
        if (isPipMode) {
          BaseViewModel.showToast(context, '您正在通话中，无法将他人移出黑名单');
          return;
        }

        widget.viewModel.unlockBlockMember(context,  friendId: model.friendId ?? 0,
          onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding, horizontal: WidgetValue.horizontalPadding),
        decoration: BoxDecoration(
            color: AppColors.textBlack,
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius)
        ),
        child: Row(
          children: [
            ImgUtil.buildFromImgPath('assets/profile/profile_block_icon_4.png', size: WidgetValue.smallIcon),
            const Text('移出', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w800, fontSize: 16))
          ],
        ),
      ),
    );
  }
}