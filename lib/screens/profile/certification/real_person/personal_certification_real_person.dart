import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/screens/profile/certification/real_person/personal_certification_real_person_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

import '../../../../widgets/shared/buttons/common_button.dart';
import '../../../../widgets/theme/app_linear_gradient_theme.dart';

class PersonalCertificationRealPerson extends ConsumerStatefulWidget {
  const PersonalCertificationRealPerson({super.key});

  @override
  ConsumerState<PersonalCertificationRealPerson> createState() =>
      _PersonalCertificationRealPersonState();
}

class _PersonalCertificationRealPersonState extends ConsumerState<PersonalCertificationRealPerson> {
    
  late PersonalCertificationRealPersonViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme appColorTheme;
  late AppTextTheme appTextTheme;
  late AppLinearGradientTheme appLinearGradientTheme;
  late AppImageTheme appImageTheme;
  late AppBoxDecorationTheme appBoxDecorationTheme;


  @override
  void initState() {
    viewModel = PersonalCertificationRealPersonViewModel(setState: setState, ref: ref);
    viewModel.init();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    WsMemberInfoRes? memberInfo = ref.read(userInfoProvider).memberInfo;
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = _theme.getAppColorTheme;
    appImageTheme = _theme.getAppImageTheme;
    appTextTheme = _theme.getAppTextTheme;
    appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    appBoxDecorationTheme  = _theme.getAppBoxDecorationTheme;
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();

    if (memberInfo != null) {
      final String? avatarPath = memberInfo.avatarPath;
      final num? avatarAuth = memberInfo.avatarAuth;
      final num gender = memberInfo.gender ?? 0;

      return MainScaffold(
        isFullScreen: true,
        needSingleScroll: false,
        padding: EdgeInsets.only(
          top: paddingHeight,
          bottom: WidgetValue.bottomPadding,
          left: WidgetValue.horizontalPadding,
          right: WidgetValue.horizontalPadding,
        ),
        // appBar: MainAppBar(title: '真人认证'),
        appBar: MainAppBar(
          theme: _theme,
          backgroundColor: appColorTheme.appBarBackgroundColor,
          title: '真人认证',
          leading: IconButton(
            icon: ImgUtil.buildFromImgPath(appImageTheme.iconBack, size: 24.w),
            onPressed: () => BaseViewModel.popPage(context),
          ),
        ),
        backgroundColor: appColorTheme.appBarBackgroundColor,
        child:SingleChildScrollView(
          child:  Column(
            children: [
              const SizedBox(height: 8),
              _buildTitleIcon(),
              const SizedBox(height: 12),
              _buildStep1View(avatarPath, avatarAuth, gender),
              const SizedBox(height: 20),
              _buildStep2View(avatarAuth),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  //Step 1 view.
  Widget _buildStep1View(String? avatarPath, num? avatarAuth, num gender) {
    CertificationType certificationType =
        CertificationModel.getType(authNum: avatarAuth);

    bool showErrorHint = certificationType == CertificationType.fail;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: appBoxDecorationTheme.certificationStepBoxDecoration,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(avatarPath, avatarAuth, gender),
            SizedBox(
              height: WidgetValue.verticalPadding,
            ),
            Text(
              'Step1 上传头像',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: WidgetValue.verticalPadding,
            ),
            Text(
              '请上传本人露脸照片\n非本人头像不能通过验证哦',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Visibility(visible: showErrorHint, child: _buildFailedHint()),
            SizedBox(height: 20),
            _buildUploadAvatarBtn(avatarAuth),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2View(num? avatarAuth) {
    //審核中/審核失敗/未審核 蓋層圖
    CertificationType certificationType =
        CertificationModel.getType(authNum: avatarAuth);

    Widget hintDesc;
    bool enableScanFaceBtn = false;
    if (certificationType == CertificationType.done) {
      hintDesc = Text(
        '头像审核成功！请点击进行刷脸认证',
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.grey.shade600),
        textAlign: TextAlign.center,
      );
      enableScanFaceBtn = true;
    } else {
      hintDesc = Text(
        '头像审核开通后\n即可点击刷脸验证进行真人验证',
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.grey.shade600),
        textAlign: TextAlign.center,
      );
      enableScanFaceBtn = false;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: appBoxDecorationTheme.certificationStepBoxDecoration,
      child: Center(
        child: Column(
          children: [
            Text(
              'Step2 刷脸认证',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: WidgetValue.verticalPadding,
            ),
            hintDesc,
            SizedBox(
              height: WidgetValue.verticalPadding,
            ),
            _buildScanFaceBtn(enableScanFaceBtn),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleIcon() {
    return ImgUtil.buildFromImgPath(appImageTheme.iconPersonalCertificationPersonal, size: 72);
  }

  Widget _buildAvatar(String? avatarPath, num? avatarAuth, num gender) {
    //avatarAuth:
    //頭像認證 0:未認證 1:已認證 2:認證中 3:認證失敗 4:已認證重新送審中
    //目前後端的邏輯是 2 跟 4 的狀態是無法重複送審，送了等於沒送，因此這邊我要直接把2,4的點擊擋掉

    //頭像圖
    Widget userImage;
    if (avatarPath == null) {
      userImage = AvatarUtil.defaultAvatar(gender, size: 120.w);
    } else {
      userImage = AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatarPath, size: 120.w);
    }

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

    return  Stack(
      fit: StackFit.loose,
      alignment: Alignment.center,
      children: [userImage, authStatus],
    );
  }

  Widget _buildUserImg(String avatarPath) {
    return CachedNetworkImageUtil.load(HttpSetting.baseImagePath + avatarPath,
        size: WidgetValue.userBigImg);
  }

  Widget _buildFailedHint() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImgUtil.buildFromImgPath(appImageTheme.iconProfileRealPersonAuthError, size: 20),
        SizedBox(width: WidgetValue.separateHeight),
        Flexible(
          child: Text(
            '审核失败！请重新上传头像',
            style: TextStyle(
              color: appColorTheme.realPersonAuthHintError,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadAvatarBtn(num? avatarAuth) {
    // avatarAuth
    // 0:未認證 1:已認證 2:認證中 3:認證失敗 4:

    //這邊根據不同的驗證狀態會長得不一樣
    CertificationType certificationType =
        CertificationModel.getType(authNum: avatarAuth);

    switch (certificationType) {
      case CertificationType.not:
        return _uploadButton(
          text: '上传头像',
          onTap: () => viewModel.changeUserImg(context, onShowFrequentlyDialog: () => _buildFrequentlyDialog()),
        );
      case CertificationType.done:
        return _editButton(
          text: '更换头像',
          onTap: () => viewModel.changeUserImg(context, onShowFrequentlyDialog: () => _buildFrequentlyDialog()),
        );
      case CertificationType.processing:
        return _verifyButton(text: '审核中',);
      case CertificationType.fail:
        return _uploadButton(
          text: '重新上传',
          onTap: () => viewModel.changeUserImg(context, onShowFrequentlyDialog: () => _buildFrequentlyDialog()),
        );
      case CertificationType.resend:
        return _verifyButton(text: '审核中',);
      default:
        return _uploadButton(
          text: '上传头像',
          onTap: () => viewModel.changeUserImg(context, onShowFrequentlyDialog: () => _buildFrequentlyDialog()),
        );
    }
  }

  Widget _buildScanFaceBtn(bool enable) {
    if (enable) {
      return _uploadButton(
        text: '刷脸认证',
        onTap: () {
          viewModel.takePicFrontCamera(context, onShowFrequentlyDialog: () => _buildFrequentlyDialog());
        },
      );
    } else {
      return _disableButton(
        text: '刷脸认证',);
    }
  }

  Future<void> _buildFrequentlyDialog() async {
    await CheckDialog.show(context,
        appTheme: _theme,
        titleText: '操作过于频繁',
        messageText: '请稍候 5 秒',
        confirmButtonText: '确认');
  }

  Widget _uploadButton({required String text, required Function() onTap}) {
    return CommonButton(
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.circle,
        isEnabledTapLimitTimer: false,
        padding: EdgeInsets.symmetric(horizontal: 10),
        text: text,
        textStyle: appTextTheme.buttonPrimaryTextStyle,
        colorBegin: appLinearGradientTheme.buttonPrimaryColor.colors[0],
        colorEnd: appLinearGradientTheme.buttonPrimaryColor.colors[1],
        onTap: () {
          onTap();
        });
  }

  Widget _editButton({required String text, required Function() onTap}) {
    return CommonButton(
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.circle,
        isEnabledTapLimitTimer: false,
        padding: EdgeInsets.symmetric(horizontal: 16),
        text: text,
        textStyle: appTextTheme.buttonSecondaryTextStyle,
        colorBegin: appLinearGradientTheme.buttonSecondaryColor.colors[0],
        colorEnd: appLinearGradientTheme.buttonSecondaryColor.colors[1],
        // broder: Border.all(width: 2, color: AppColors.mainPink),
        onTap: () {
          onTap();
        });
  }

  Widget _verifyButton({required String text}){
    return CommonButton(
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.circle,
        isEnabledTapLimitTimer: false,
        padding: EdgeInsets.symmetric(horizontal: 10),
        text: text,
        textStyle: const TextStyle(color: AppColors.textWhite, fontSize: 14),
        colorBegin: Colors.grey.shade700,
        colorEnd: Colors.grey.shade700,
        onTap: () {});
  }

  Widget _disableButton({required String text}){

    return CommonButton(
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.circle,
        isEnabledTapLimitTimer: false,
        padding: EdgeInsets.symmetric(horizontal: 10),
        text: text,
        textStyle: appTextTheme.buttonDisableTextStyle,
        colorBegin: appLinearGradientTheme.buttonDisableColor.colors[0],
        colorEnd: appLinearGradientTheme.buttonDisableColor.colors[1],
        onTap: () {});
  }
}
