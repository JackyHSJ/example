import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/screens/profile/edit/personal_edit.dart';
import 'package:frechat/screens/user_info_view/user_info_view.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import '../theme/original/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_screenutil/src/size_extension.dart';

class PersonalInfo extends ConsumerStatefulWidget {
  PersonalInfo({super.key});

  @override
  ConsumerState<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends ConsumerState<PersonalInfo> {
  String processingPath = '';
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;

  @override
  void initState() {
    super.initState();
    getProcessingImg();
  }

  Future<void> getProcessingImg() async {
    final WsMemberInfoRes? memberInfo = ref.read(userInfoProvider).memberInfo;
    final num avatarAuth = memberInfo?.avatarAuth ?? 0;
    final CertificationType certificationType =
        CertificationModel.getType(authNum: avatarAuth);
    if (certificationType == CertificationType.processing ||
        certificationType == CertificationType.resend) {
      final directory = await getApplicationDocumentsDirectory();
      String targetPath = '';
      targetPath = path.join(directory.path, 'avatar');
      final imagesPath = path.join(targetPath, 'images');
      processingPath = path.join(
          imagesPath, 'avatar_${ref.read(userInfoProvider).userName!}.png');
    }
  }

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;

    return Consumer(builder: (context, ref, _) {
      final WsMemberInfoRes? memberInfo = ref.watch(userInfoProvider).memberInfo;
      return Row(
        children: [
          _buildUserImg(),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildName(memberInfo),
                const SizedBox(height: 5),
                _buildSubInfo(memberInfo)
              ],
            ),
          ),
          _buildEditBtn()
        ],
      );
    });
  }

  Widget _buildUserImg() {
    WsMemberInfoRes? memberInfo = ref.read(userInfoProvider).memberInfo;
    if (memberInfo != null) {
      num? avatarAuth = memberInfo.avatarAuth;

      //avatarAuth:
      //頭像認證 0:未認證 1:已認證 2:認證中 3:認證失敗 4:已認證重新送審中
      //目前後端的邏輯是 2 跟 4 的狀態是無法重複送審，送了等於沒送，因此這邊我要直接把2,4的點擊擋掉

      //審核中/審核失敗/未審核 蓋層圖
      CertificationType certificationType =
          CertificationModel.getType(authNum: avatarAuth);
      Widget authStatus;
      if (certificationType == CertificationType.processing ||
          certificationType == CertificationType.resend) {
        authStatus = SizedBox(
            width: 63,
            height: 24,
            child: Image.asset('assets/strike_up_list/under_review.png'));
      } else if (certificationType == CertificationType.fail) {
        authStatus = Container(
            color: Colors.white.withOpacity(0.75),
            child: Image.asset('assets/strike_up_list/review_failed.png'));
      } else if (certificationType == CertificationType.not) {
        authStatus = const SizedBox();
      } else {
        //這是過審的意思 CertificationType.done
        authStatus = const SizedBox();
      }

      return SizedBox(
        width: 64.w,
        height: 64.w,
        child: GestureDetector(
          onTap: () {
            BaseViewModel.pushPage(
                context,
                UserInfoView(
                  memberInfo: ref.read(userInfoProvider).memberInfo,
                  displayMode: DisplayMode.personalInfo,
                ));
          },
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Stack(
              fit: StackFit.loose,
              alignment: Alignment.center,
              children: [
                _buildSettingUserImg(memberInfo, certificationType),
                authStatus
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  _buildSettingUserImg(
      WsMemberInfoRes memberInfo, CertificationType certificationType) {
    final String? avatarPath =
        ref.read(userInfoProvider).memberInfo?.avatarPath;
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;

    return (avatarPath == null)
        ? (certificationType == CertificationType.processing ||
                certificationType == CertificationType.resend)
            ? processingAvatarImg()
            : AvatarUtil.defaultAvatar(gender, size: 64.w)
        : AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatarPath,
            size: 64.w);
  }

  Widget processingAvatarImg() {
    return AvatarUtil.localAvatar(processingPath, size: 64.w);
  }

  _buildName(WsMemberInfoRes? memberInfo) {
    final String userName = memberInfo?.userName ?? '';
    final String nickName = memberInfo?.nickName ?? '';
    final String displayName = ConvertUtil.displayName(userName, nickName, '');
    return FittedBox(
      child: Row(
        children: [
          Text(
            displayName,
            style: TextStyle(
              color: _appColorTheme.personalProfilePrimaryTextColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          SizedBox(width: 5.w),
          _buildGender(memberInfo?.gender ?? 1, memberInfo?.age ?? 0),
          SizedBox(width: 5.w),
          _buildRealPersonAuth()
        ],
      ),
    );
  }

  _buildSubInfo(WsMemberInfoRes? memberInfo) {

    String userName = memberInfo?.userName ?? '';
    return GestureDetector(
      onTap: () {
        BaseViewModel.copyText(context, copyText: memberInfo?.userName ?? '');
      },
      child: Row(
        children: [
          Text('${AppConfig.appName}号 $userName',
            style: TextStyle(
              color: _appColorTheme.personalProfileSecondaryTextColor,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(width: 4.w),
          ImgUtil.buildFromImgPath(_appImageTheme.iconCopy, size: 16.w),
        ],
      ),
    );
  }

  _buildGender(num gender, num age) {
    return IconTag.genderAge(gender: gender, age: age);
  }

  _buildRealPersonAuth() {
    final bool isRealPersonAuth =  ref.read(userInfoProvider).memberInfo?.realPersonAuth == 1;
    if (isRealPersonAuth) {
      return ImgUtil.buildFromImgPath('assets/profile/profile_certification_certi_icon.png', size: 16.w);
    }else{
      return SizedBox();
    }
  }

  _buildEditBtn() {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppBoxDecorationTheme appBoxDecorationTheme = theme.getAppBoxDecorationTheme;
    final AppImageTheme appImageTheme = theme.getAppImageTheme;

    return InkWell(
      onTap: () => BaseViewModel.pushPage(context, const PersonalEdit()),
      child: Container(
        decoration: appBoxDecorationTheme.personalProfileEditBoxDecoration,
        padding: EdgeInsets.all(WidgetValue.btnHorizontalPadding),
        child: Row(
          children: [
            ImgUtil.buildFromImgPath(appImageTheme.iconPersonalProfileEdit, size: 14.w),
            SizedBox(width: 2.w),
            const Text(
              '编辑资料',
              style: TextStyle(
                color: AppColors.textWhite,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            SizedBox(width: 6.w),
          ],
        ),
      ),
    );
  }
}
