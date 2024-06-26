
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:frechat/screens/strike_up_list/mate/strike_up_list_mate_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/audioplayer_util.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/dialog/base_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/strike_up_list/dialogs/strike_up_list_mate_dialog.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import '../../../models/ws_res/member/ws_member_info_res.dart';
import '../../../system/providers.dart';
import '../../../system/zego_call/interal/zim/zim_service_defines.dart';
import '../../../widgets/shared/dialog/check_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audioplayers/audioplayers.dart';

class StrikeUpListMate extends ConsumerStatefulWidget {
  final ZegoCallType callType;
  const StrikeUpListMate({
    super.key,
    required this.callType,
  });

  @override
  ConsumerState<StrikeUpListMate> createState() => _StrikeUpListVideoMateState();
}

class _StrikeUpListVideoMateState extends ConsumerState<StrikeUpListMate> with TickerProviderStateMixin {
  ZegoCallType get callType => widget.callType;
  late StrikeUpListMateViewModel viewModel;
  String hint = '';

  double volume =0;
  int volumeStatus = 0; //0:正常 1:关闭
  late AppTheme _theme;
  late AppImageTheme _appImageTheme;

  @override
  void initState() {
    super.initState();
    viewModel = StrikeUpListMateViewModel(ref: ref, setState: setState, tickerProvider: this, callType: callType);
    _initListener();
    /// 設定使用者正在速配狀態
    ref.read(userUtilProvider.notifier).setDataToPrefs(isStrikeUpMateMode: true);

    AudioPlayerUtils.playAssetAudio('aac/audio.aac',true);
    volume = AudioPlayerUtils.player!.volume;
  }


  _initListener() {
    viewModel.init(context,
      onShowMateDialog: (mateMemberInfo) => _buildMateDialog(mateMemberInfo: mateMemberInfo),
      onShowErrorMateDialog: () => _buildErrorMateDialog(),
    );
  }

  @override
  void deactivate() {
    ref.read(userUtilProvider.notifier).setDataToPrefs(isStrikeUpMateMode: false);
    super.deactivate();
  }

  @override
  void dispose() {
    viewModel.dispose();
    AudioPlayerUtils.playerStop();
    AudioPlayerUtils.player?.setVolume(volume);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appImageTheme = _theme.getAppImageTheme;
    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      appBar: _buildAppBar(),
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          _buildBackGroundImage(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 112.h),
                child: _buildAnimations(),
              ),
              _buildDes(),
              _buildBottomBar()
            ],
          )
        ],
      ),
    );
  }

  _buildDes() {
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    final des = (gender == 0) ? '正在为您匹配有缘的小哥哥，请耐心等待' : '正在为您匹配有缘的小姐姐，请耐心等待';
    return Text(des, style: const TextStyle(
        color: AppColors.textWhite,
        fontSize: 14,
        fontWeight: FontWeight.w500
    ));
  }

  _buildMateDialog({required WsMemberInfoRes mateMemberInfo}) {
    BaseDialog(context).showTransparentDialog(
      isDialogCancel: false,
      widget: StrikeUpListMateDialog(viewModel: viewModel, mateMemberInfo: mateMemberInfo)
    );
  }

  _buildAppBar() {
    final title = callType == ZegoCallType.voice ? '语音速配' : '视频速配';
    return MainAppBar(
      theme: _theme,
      title: title,
      foregroundColor: AppColors.textWhite,
      actions: [_buildVoiceBtn()],
      leading: IconButton(
        onPressed: () => BaseViewModel.popPage(context),
        icon: const Icon(Icons.close),
      ),
    );
  }

  Future<void> _buildErrorMateDialog() async {
    StrikeUpListMateViewModel.stateController.sink.add(MateState.error);
    CheckDialog.show(context,
      appTheme: _theme,
      barrierDismissible: false,
      messageText: '暂无合适的配对人选\n是否为您重新配对？',
      messageTextAlign: TextAlign.center,
      showCancelButton: true,
      cancelButtonText: '放弃缘分',
      confirmButtonText: '重新配对',
      onCancelPress: () => BaseViewModel.popPage(context),
      onConfirmPress: () {
        StrikeUpListMateViewModel.streamSubscription.cancel();
        viewModel.initMate(context);
      }
    );
  }

  _buildVoiceBtn() {
    String volumePath = 'assets/images/icon_volume.png';
    if(volumeStatus == 1){
      volumePath = 'assets/images/icon_volume_quiet.png';
    }
    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(right: 16),
        child: Image(
            width: 24.w,
            height: 24.w,
            image: AssetImage(volumePath)
        ),
      ),onTap: (){
        if(volumeStatus == 0){
          AudioPlayerUtils.player?.setVolume(0);
          volumeStatus =1;
        }else{
          volumeStatus = 0;
          AudioPlayerUtils.player?.setVolume(volume);
        }
        setState(() {});
    });
  }

  ///背景底圖
  Widget _buildBackGroundImage() {
    final bool isVideo = widget.callType == ZegoCallType.video;

    return ImgUtil.buildFromImgPath(
        isVideo
            ? _appImageTheme.strikeUpVideoMateBackgroundImage
            : _appImageTheme.strikeUpVoiceMateBackgroundImage,
        width: UIDefine.getWidth(),
        height: UIDefine.getHeight(),
        fit: BoxFit.cover);
  }

  ///介面動畫
  Widget _buildAnimations() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImgUtil.buildFromImgPath(
            _appImageTheme.strikeUpMateSearchBackgroundImage,
            width:350.w,
            height: 350.w,
            fit: BoxFit.contain),
        _buildAnimate(
            offset: 180,
            imgPath: 'assets/video_dating/demo_dating1.png',
            animation: viewModel.animation1!
        ),
        _buildAnimate(
            offset: 125,
            imgPath: 'assets/video_dating/demo_dating2.png',
            animation: viewModel.animation2!
        ),
        _buildAnimate(
            offset: 80,
            imgPath: 'assets/video_dating/demo_dating3.png',
            animation: viewModel.animation3!
        ),
        _buildAvatar(),
      ],
    );
  }

  _buildAvatar() {
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    final String? avatarPath = ref.read(userInfoProvider).memberInfo?.avatarPath;

    return (avatarPath == null)
        ? AvatarUtil.defaultAvatar(gender ,size: 64.w)
        : AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatarPath, size: 64.w);
  }

  _buildAnimate({
    required double offset,
    required String imgPath,
    required Animation<double> animation
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            offset * math.cos(animation.value),
            offset * math.sin(animation.value),
          ),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imgPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  ///底部訊息欄
  Widget _buildBottomBar() {
    final bool isVideo = widget.callType == ZegoCallType.video;

    return Padding(
      padding: EdgeInsets.only(bottom:36),
      child:isVideo
          ? Image(image: AssetImage(_appImageTheme.strikeUpVideoMateImage))
          : Image(image: AssetImage(_appImageTheme.strikeUpVoiceMateImage)),

      // child: Stack(
      //   children: [
      //     isVideo
      //         ? Image(image: AssetImage(_appImageTheme.strikeUpVideoMateImage))
      //         :  Image(image: AssetImage(_appImageTheme.strikeUpVoiceMateImage)),
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(105, 19, 0, 0),
      //       child: Text(isVideo ? '视频速配加速中...' : '语音速配加速中...', style: const TextStyle(color: Colors.white, fontSize: 14)),
      //     ),
      //   ],
      // ),
    );
  }
}
