import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/profile/personal_cell_model.dart';
import 'package:frechat/screens/profile/edit/audio/personal_edit_audio.dart';
import 'package:frechat/screens/profile/edit/intro/personal_edit_intro.dart';
import 'package:frechat/screens/profile/edit/nick_name/personal_edit_nick_name.dart';
import 'package:frechat/screens/profile/edit/personal_edit_view_model.dart';
import 'package:frechat/screens/profile/edit/tag/personal_edit_tag.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/loading_dialog/loading_widget.dart';
import 'package:frechat/widgets/shared/divider.dart';
import 'package:frechat/widgets/shared/gradient_component.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import '../../../models/ws_res/member/ws_member_info_res.dart';
import '../../../widgets/profile/cell/personal_cell.dart';
import '../../../widgets/shared/dialog/check_dialog.dart';
import '../../../widgets/shared/list/main_list.dart';
import '../../../widgets/shared/main_scaffold.dart';
import '../../../widgets/shared/progress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PersonalEdit extends ConsumerStatefulWidget {
  const PersonalEdit({super.key});

  @override
  ConsumerState<PersonalEdit> createState() => _PersonalEditState();
}

class _PersonalEditState extends ConsumerState<PersonalEdit> {
  late PersonalEditViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  String processingPath = '';

  @override
  void initState() {
    viewModel = PersonalEditViewModel(ref: ref, setState: setState);
    viewModel.init();
    addCellList();
    super.initState();
    getProcessingImg();
  }

  void addCellList(){
    viewModel.cellList=[
      PersonalCellModel(title: '昵称', icon: 'assets/profile/profile_edit_nickname_icon.png', pushPage: PersonalEditNickName()),
      PersonalCellModel(
          title: '展示照片',
          icon: 'assets/profile/profile_edit_image_icon.png',
          hint: '上传本人相册+20金币',
          type: PersonalCellType.img,
          remark: ['1、拖拽相片可以更改排序，点击查看大图可删除相册', '2、照片涉黄或审核不通过将被删除，严重者冻结账号']),
      PersonalCellModel(title: '声音展示', icon: 'assets/profile/profile_edit_sound_icon.png', pushPage: PersonalEditAudio(), type: PersonalCellType.audio),
      PersonalCellModel(title: '年龄', icon: 'assets/profile/profile_edit_age_icon.png'),
      PersonalCellModel(title: '家乡', icon: 'assets/profile/profile_edit_home_icon.png'),
      // PersonalCellModel(title: '所在地', icon: 'assets/profile/profile_edit_current_home_icon.png', type: PersonalCellType.custom),
      PersonalCellModel(title: '身高', icon: 'assets/profile/profile_edit_tall_icon.png'),
      PersonalCellModel(title: '体重', icon: 'assets/profile/profile_edit_weight_icon.png'),
      PersonalCellModel(title: '职业', icon: 'assets/profile/profile_edit_job_icon.png'),
      PersonalCellModel(title: '年收入', icon: 'assets/profile/profile_edit_income_icon.png'),
      PersonalCellModel(title: '学历', icon: 'assets/profile/profile_edit_education_icon.png'),
      PersonalCellModel(title: '婚姻状态', icon: 'assets/profile/profile_edit_marriage_icon.png'),
      PersonalCellModel(title: '自我介绍', icon: 'assets/profile/profile_edit_intro_icon.png', type: PersonalCellType.intro, pushPage: PersonalEditIntro()),
      PersonalCellModel(
          title: '我的标签', icon: 'assets/profile/profile_edit_tag_icon.png', remark: ['我的个性标签'], type: PersonalCellType.tag, pushPage: PersonalEditTag()),
    ];
  }

  Future<void> getProcessingImg() async {
    WsMemberInfoRes? memberInfo = ref.read(userInfoProvider).memberInfo;
    num? avatarAuth = memberInfo!.avatarAuth;
    CertificationType certificationType = CertificationModel.getType(authNum: avatarAuth);
    if(certificationType == CertificationType.processing || certificationType == CertificationType.resend){
      final directory = await getApplicationDocumentsDirectory();
      String targetPath = '';
      targetPath = path.join(directory.path, 'avatar');
      final imagesPath = path.join(targetPath, 'images');
      processingPath = path.join(imagesPath,'avatar_${ref.read(userInfoProvider).userName!}.png');
    }
  }

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    
    return MainScaffold(
      isFullScreen: true,
      padding: EdgeInsets.only(top: paddingHeight, bottom: UIDefine.getNavigationBarHeight()),
      appBar: _buildMainAppBar('编辑资料', [_buildBtn(context)], context),
      backgroundColor: _appColorTheme.baseBackgroundColor,
      child: Column(
        children: [
          Offstage(
            offstage: false,
            child: _buildFinishRate(),
          ),
          _contentWidget(context)

        ],
      ),
    );
  }

  _buildBtn(BuildContext context) {
    return InkWell(
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(right: 16.w),
        child: Text('保存', style: _appTextTheme.appbarActionTextStyle),
      ),
      onTap: () async{
        Loading.show(context, '保存中...');
        await viewModel.editMemberInfo(
            onConnectFail: (errMsg) {
              if (mounted) Loading.hide(context);
              //做特例網開一面: 暱稱審核中就當作保存成功離開頁面 (之後還有其他可能性應該也需要這樣)
              if (errMsg == ResponseCode.CODE_NICKNAME_UNDER_REVIEW) {
                BaseViewModel.popPage(context);
              } else if (errMsg == ResponseCode.CODE_CONTENT_VIOLATES_REGULATIONS) {
                BaseViewModel.popPage(context);
                BaseViewModel.showToast(context, '您的发言内容不恰当，请注意我们的用户协议');
              } else {
                BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
              }
            },
            onConnectSuccess: (succMsg) {
              if (mounted) {
                Loading.hide(context);
              }
              BaseViewModel.popPage(context);
              BaseViewModel.showToast(context, '个人资料保存成功');
            });
      },
    );

  }

  _buildFinishRate() {
    final percent = (viewModel.processPercent * 100).toInt();
    return Container(
      width: UIDefine.getWidth(),
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildHint('完善资料 + ${viewModel.getMissionVal(0)} ${viewModel.getMissionLabel(0)}'),
          const SizedBox(height: 4),
          Text('资料完善度', style:_appTextTheme.labelPrimaryTextStyle),
          const SizedBox(height: 8),
          ProgressIndicatorWidget(beginPercent: viewModel.processPercent),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: MainGradient(
                    linearGradient: _appLinearGradientTheme.vipTextColor).text(
                    title: '$percent%',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center),

            // child: Text('$percent%', style:_appTextTheme.labelPrimaryTextStyle),
          ),
          const SizedBox(height: 8)
        ],
      ),
    );
  }

  Widget _contentWidget(BuildContext context){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: _appBoxDecorationTheme.personalEditBoxDecoration,
      child: Column(
        children: [
          _buildUserImage(context),
          _divider(),
          _buildCell(),
        ],
      ),
      
    );
  }
  
  
  _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      child: MainDivider(color: _appColorTheme.dividerColor, weight: 1.h),
    );
  }

  _buildUserImage(BuildContext context) {
    WsMemberInfoRes wm = ref.read(userInfoProvider).memberInfo!;

    // 頭像認證 0:未認證 1:已認證 2:認證中 3:認證失敗 4:已認證重新送審中
    //
    // ii.後端頭像邏輯
    // 1 已認證、 所有人可以看到原圖
    // 2 已認證過但重新送審中 其他人看到原圖，自己看到送審圖
    // 3 首次認證失敗，自己看到送審圖，其他人看到預設頭貼
    num? avatarAuth = wm.avatarAuth;
    
    //avatarAuth:
    //頭像認證 0:未認證 1:已認證 2:認證中 3:認證失敗 4:已認證重新送審中
    //目前後端的邏輯是 2 跟 4 的狀態是無法重複送審，送了等於沒送，因此這邊我要直接把2,4的點擊擋掉
    CertificationType certificationType = CertificationModel.getType(authNum: avatarAuth);

    //頭像圖
    Widget userImage;
    if (viewModel.selectAvatar == null) {
      userImage = _buildSettingUserImg(certificationType);
    } else {
      userImage = Image.file(File(viewModel.selectAvatar!.path));
    }

    //審核中/審核失敗/未審核 蓋層圖
    Widget authStatus;
    if (certificationType == CertificationType.processing || certificationType == CertificationType.resend) {
      authStatus = SizedBox(width: 63, height: 24, child: Image.asset('assets/strike_up_list/under_review.png'));
    } else if (certificationType == CertificationType.fail) {
      authStatus = Container(color: Colors.white.withOpacity(0.75), child: Image.asset('assets/strike_up_list/review_failed.png'));
    } else if (certificationType == CertificationType.not) {
      authStatus = const SizedBox();
    }else if(certificationType == CertificationType.reject){
      authStatus = Container(color: Colors.white.withOpacity(0.75), child: Image.asset('assets/strike_up_list/reject.png'));
    } else {
      //這是過審的意思 CertificationType.done
      authStatus = const SizedBox();
    }
    if(viewModel.isNewAvatar){
      authStatus = const SizedBox();
    }

    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(WidgetValue.userBigImg),
      ),
      child: InkWell(
        onTap: () {
          if (certificationType != CertificationType.processing && certificationType != CertificationType.resend) {
            viewModel.selectImage(context, onShowFrequentlyDialog: () => _buildFrequentlyDialog());
          } else {
            BaseViewModel.showToast(context, '您的头像尚在审核中，请再等等');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: [userImage, authStatus],
          ),
        ),
      ),
    );
  }

  Future<void> _buildFrequentlyDialog() async {
    await CheckDialog.show(context,
        appTheme: _theme,
        titleText: '操作过于频繁',
        messageText: '请稍候 5 秒',
        confirmButtonText: '确认');
  }

  _buildSettingUserImg(CertificationType certificationType) {
    final String? avatarPath = ref.read(userInfoProvider).memberInfo?.avatarPath;
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;

    return (avatarPath == null) ?
    (certificationType == CertificationType.processing || certificationType == CertificationType.resend)
        ? processingAvatarImg()
        : AvatarUtil.defaultAvatar(gender, size: 120.w)
        : AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatarPath, size: 120.w);
  }

  Widget processingAvatarImg(){
    return AvatarUtil.localAvatar(processingPath, size: 120.w);
  }

  // Widget _Info() {
  //   String imagePath = 'assets/images/default_male_avatar.png';
  //   num? gender = ref.read(userInfoProvider).memberInfo!.gender;
  //   if (gender == 0) {
  //     imagePath = 'assets/images/default_female_avatar.png';
  //   }
  //   return Container(
  //       margin: const EdgeInsets.only(top: 10),
  //       width: WidgetValue.userBigImg,
  //       height: WidgetValue.userBigImg,
  //       child: CircleAvatar(
  //         backgroundImage: AssetImage(imagePath),
  //       ));
  // }

  _buildCell() {
    viewModel.cellList[1].hint = '上传本人相册 + ${viewModel.getMissionVal(2)} ${viewModel.getMissionLabel(2)}';
    print(viewModel.cellList);
    return Consumer(builder: (context, ref, _) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
        child: CustomList.separatedList(
            separator: MainDivider(color: _appColorTheme.dividerColor, weight: 1.h),
            physics: const NeverScrollableScrollPhysics(),
            childrenNum: viewModel.cellList.length,
            children: (context, index) {
              return PersonalCell(
                  viewModel: viewModel,
                  model: viewModel.cellList[index],
                  onReturnMsg: (msg) {
                    dynamic resultMsg = msg;
                    String? resultHint;
                    List<String>? resultRemark;

                    viewModel.hasChanged = true;

                    switch (index) {
                      case 0:
                        viewModel.selectNickName = msg;
                      case 2:
                        // http://redmine.zyg.com.tw/issues/1415
                        // resultMsg = basename(msg);
                        resultMsg = '已录制';
                        viewModel.selectAudio = File(msg);
                        break;
                      case 11:
                        resultMsg = '';
                        resultHint = null;
                        resultRemark = [msg];
                        viewModel.selectSelfIntroduction = msg;
                        break;
                      case 12:
                        resultMsg = '';
                        resultRemark = msg as List<String>?;
                        viewModel.selectTag = msg;
                        PersonalEditTag.chooseList = msg;
                        break;
                      default:
                        break;
                    }
                    viewModel.cellList[index]
                      ..des = resultMsg
                      ..remark = resultRemark
                      ..hint = resultHint;
                  });
            }),
      );
    });
  }

  _buildHint(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      decoration: _appBoxDecorationTheme.hintPillsBoxDecoration,
      child: Text(title, style: TextStyle(color: _appColorTheme.hintPillsTextColor, fontSize: 10.sp)),
    );
  }

  // Future _buildCheckDialog(BuildContext context) async {
  //   await CheckDialog.show(context,
  //     titleText: '放弃修改',
  //     messageText: '返回上一页将放弃本次修改，是否确认返回',
  //     showCancelButton: true,
  //     cancelButtonText: '继续编辑',
  //     confirmButtonText: '确认返回',
  //     onConfirmPress: () {
  //       PersonalEditTag.chooseList = [];
  //       Navigator.pop(context);
  //     }
  //   );
  // }

  ///因為只有這邊需要返回判斷所以單獨做
  ///by Benson
  _buildMainAppBar(String title, List<Widget>? action, BuildContext context) {
    return AppBar(
      backgroundColor: _appColorTheme.appBarBackgroundColor, // 設定 AppBar 為透明
      elevation: 0, // 移除 AppBar 的陰影
      leading: IconButton(
        icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
        onPressed: () => BaseViewModel.popPage(context),
      ),
      centerTitle: true,
      title: Text(title, style: _appTextTheme.appbarTextStyle),
      actions: action,
    );
  }

  // ///比對資料是否異動過
  // ///by Neo
  // bool _checkEdit() {
  //   //by Neo 這還沒做完，這個應該沒有正確的檢查到結果，personal_cell 得支援 onChanged 之類的東西
  //   return viewModel.hasChanged;
  // }
}
