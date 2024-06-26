import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/account/ws_account_call_package_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_gift_detail_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/call/call.dart';
import 'package:frechat/screens/call/calling_page_view_model.dart';
import 'package:frechat/screens/call/small_video_view/small_video_view.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/util/audioplayer_util.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/screens/gift_and_bag/gift_and_bag.dart';
import 'package:frechat/screens/strike_up_list/mate/strike_up_list_mate_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/svga_player_util.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/model/zego_user_model.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/widgets/banner_view/dismissible_banner_view_icon.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/bottom_sheet/profile_setting_beauty/beauty_bottom_sheet.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:marqueer/marqueer.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

//接聽畫面
class CallingPage extends ConsumerStatefulWidget {
  const CallingPage({
    super.key,
    this.zegoCallUserState,
    this.callData,
    this.otherUserInfo,
    this.token,
    this.channel,
    this.roomID,
    this.memberInfoRes,
    this.searchListInfo,
  });

  final ZegoCallUserState? zegoCallUserState;
  final ZegoCallData? callData;
  final ZegoUserInfo? otherUserInfo;
  final String? token;
  final String? channel;
  final num? roomID;
  final WsMemberInfoRes? memberInfoRes;
  final SearchListInfo? searchListInfo;

  @override
  ConsumerState<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends ConsumerState<CallingPage> with TickerProviderStateMixin {
  late ChatRoomViewModel chatRoomViewModel;
  late CallingPageViewModel viewModel;
  ZegoCallUserState get zegoCallUserState => widget.zegoCallUserState ?? ZegoCallUserState.received;
  late AppTheme _theme;
  late AppColorTheme appColorTheme;
  late AppTextTheme appTextTheme;
  late AppLinearGradientTheme appLinearGradientTheme;

  @override
  void initState() {
    super.initState();
    AudioPlayerUtils.playerStop();
    SvgaPlayerUtil.init(this);

    chatRoomViewModel = ChatRoomViewModel(ref: ref, setState: setState, context: context, tickerProvider: this);
    viewModel = CallingPageViewModel(
        setState: setState,
        ref: ref,
        channel: widget.channel ?? '',
        roomID: widget.roomID ?? 0,
        callData: widget.callData!,
        searchListInfo: widget.searchListInfo ?? SearchListInfo(),
        chatRoomViewModel: chatRoomViewModel,
        token: widget.token,
        otherUserInfo: widget.otherUserInfo!,
        memberInfoRes: widget.memberInfoRes ?? WsMemberInfoRes(),
        tickerProvider: this
    );
    viewModel.init(context, zegoCallUserState: zegoCallUserState);
  }

  @override
  void deactivate() {
    viewModel.deactivate();
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    if (PipUtil.pipStatus != PipStatus.init) {
      return;
    }

    viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appTextTheme = _theme.getAppTextTheme;
    appColorTheme = _theme.getAppColorTheme;
    appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Stack(
          children: [
            (widget.callData?.callType == ZegoCallType.video)
                ? videoView()
                : voiceView(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: UIDefine.getHeight() / 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: (widget.callData?.callType == ZegoCallType.video)
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.end,
          children: [
            //每日顯示可關閉 Banner Icon (不确定位置對不對，可能需要喬位置?)
            //如果位置不對，可以換到其他地方
            (widget.callData?.callType == ZegoCallType.video)
                ? _buildDailyDismissibleBannerIcon()
                : Container(),
            giftBoxWidget(),
          ],
        ),
      ),
    );
  }

  //顯示可關閉 Banner Icon
  Widget _buildDailyDismissibleBannerIcon() {
    WsMemberInfoRes? memberInfo = ref.read(userUtilProvider).memberInfo;
    if (memberInfo != null) {
      return const DismissibleBannerViewIcon(
        locatedPageFilter: 4,
        dismissible: false,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget voiceView() {
    return Call(
      isAnswer: true,
      callData: widget.callData!,
      channel: widget.channel,
      roomId: widget.roomID ?? 0,
      memberInfoRes: widget.memberInfoRes ?? WsMemberInfoRes(),
      searchListInfo: widget.searchListInfo,
      viewModel: viewModel,
      isEnabledMicSwitch: false,
      isEnabledVolumn: true,
    );
  }

  Widget videoView() {
    return Stack(
      children: [
        largeVideoView(),
        SafeArea(child: marquee()),
        SafeArea(child: headLineWidgets()),
        SmallVideoView(isCameraOpen: viewModel.isCameraOpen),
        SVGAImage(SvgaPlayerUtil.animationController!),
        timeWidget(),
        functionRowWidget(),
        showBeautySheet(),
      ],
    );
  }

  // 跑馬燈
  Widget marquee() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          height: 32.h,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Marqueer(
            pps: 30,
            child: Row(
              children: [
                Image(
                  width: 16.w,
                  height: 16.h,
                  image: const AssetImage('assets/images/icon_trumpet.png'),
                ),
                Container(
                    margin: EdgeInsets.only(left: 4.w),
                    child: Text(
                      '欢迎使用${AppConfig.appName}交友APP！在这里，你可以认识新朋友、扩展社交圈子',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                      ),
                    )),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          width: MediaQuery.of(context).size.width,
          height: 32.h,
          color: Colors.transparent,
        )
      ],
    );
  }

  // 禮物盒
  Widget giftBoxWidget() {
    return GestureDetector(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ImgUtil.buildFromImgPath('assets/images/icon_gift_box.png',
              size: 60.w),
          Container(
            width: 40.w,
            height: 20.h,
            alignment: const Alignment(0, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                gradient: const LinearGradient(
                  colors: [AppColors.mainYellow, AppColors.mainOrange],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )),
            child: Text(
              "送礼物",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 8.sp,
                  color: Colors.white),
            ),
          ),
        ],
      ),
      onTap: () => _showBottomSheet(),
    );
  }

  Future<void> _showBottomSheet() async {
    await showModalBottomSheet<dynamic>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 455.h,
          child: SafeArea(
            child: GiftAndBag(
              onTapSendGift: (result) {
                chatRoomViewModel.sendGiftMessage(searchListInfo: widget.searchListInfo!, unRead: 0, giftListInfo: result);
              },
            ),
          ),
        );
      },
    );
  }

  Widget timeWidget() {
    return Positioned(
        top: 550.h,
        child: Container(
          width: UIDefine.getWidth(),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [timeTextWidget1()]),
        ));
  }

  //時間
  Widget timeTextWidget1() {
    return Consumer(builder: (context, ref, _) {
      final num time = ref.watch(userInfoProvider).callTimer ?? 0;
      return Container(
        margin: EdgeInsets.only(
          top: 22.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(time.toInt()),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(255, 255, 255, 1),
              ),
            )
          ],
        ),
      );
    });
  }

  //整理時間格式
  String _formatTime(int time) {
    int minutes = (time ~/ 60) % 60;
    int seconds = time % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  Widget functionRowWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: WidgetValue.btnBottomPadding * 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          cameraWidget(onTap: () => swtichCamera()),
          cancelCallWidget(onTap: () => viewModel.cancelCall(context)),
          iconBeautyWidget(onTap: () => swtichBeauty()),
        ],
      ),
    );
  }

  // 畫面縮小 / 美顏 / 鏡頭切換
  Widget headLineWidgets() {
    return Container(
        margin: EdgeInsets.only(top: 44.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildZoomOutBtn(),
            _buildBeautyToggleBtn(),
            _buildCameraToggleBtn(),
          ],
        ));
  }

  // 畫面縮小按鈕
  _buildZoomOutBtn() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: InkWell(
          onTap: () =>
              viewModel.enterPiPMode(context, pipWidget: largeVideoView()),
          child: SizedBox(
            width: 36,
            height: 36,
            child: Center(
              child: Image.asset('assets/images/icon_zoomout.png',
                  width: 24, height: 24),
            ),
          ),
        ),
      ),
    );
  }

  // 開啟 / 關閉美顏功能按鈕
  _buildBeautyToggleBtn() {
    return viewModel.isBeautyOpen
        ? InkWell(
            onTap: () {
              _buildBeautyDialog(
                  title: '是否关闭美颜功能？',
                  subTitle: '关闭美颜功能将展示最真实的您',
                  confirmBtn: '关闭',
                  onTap: () {
                    viewModel.closeBeauty(context);
                  });
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99.0),
                  gradient: appLinearGradientTheme.callingPageBeautyButtonLinearGradient),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Text('已开启美颜功能',
                    style: appTextTheme.callingPageBeautyButtonTextStyle),
              ),
            ))
        : ClipRRect(
            borderRadius: BorderRadius.circular(99.0),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: InkWell(
                    onTap: () {
                      viewModel.openBeauty(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99.0),
                          gradient: null),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6.0),
                        child: Text('已关闭美颜功能',
                            style: TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                height: 1.16667)),
                      ),
                    ))),
          );
  }

  // 鏡頭切換按鈕
  _buildCameraToggleBtn() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: InkWell(
          onTap: () {
            viewModel.isFacingCamera = !viewModel.isFacingCamera;
            ref
                .read(expressServiceProvider)
                .useFrontFacingCamera(viewModel.isFacingCamera);
          },
          child: SizedBox(
            width: 36,
            height: 36,
            child: Center(
              child: Image.asset('assets/images/icon_camera_video.png',
                  width: 24, height: 24),
            ),
          ),
        ),
      ),
    );
  }

  // 美顏編輯
  Widget showBeautySheet() {
    return viewModel.isBeautyEditing
        ? Align(
            alignment: Alignment.bottomCenter,
            child: BeautyBottomSheet(callBackFunction: () {
              setState(() {
                viewModel.isBeautyEditing = false;
              });
            }))
        : const SizedBox();
  }

  // 美顏彈窗
  _buildBeautyDialog({
    required String title,
    required String subTitle,
    required String confirmBtn,
    required Function() onTap,
  }) {
    showDialog(
      context: BaseViewModel.getGlobalContext(),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          backgroundColor: appColorTheme.dialogBackgroundColor,
          content: SizedBox(
              width: 343,
              height: 154,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: appTextTheme.dialogTitleTextStyle),
                    Text(
                      subTitle,
                      style: appTextTheme.dialogContentTextStyle),
                    _buildBeautyDialogBtn(confirmBtn: confirmBtn, onTap: onTap),
                  ],
                ),
              )),
        );
      },
    );
  }

  // 美顏彈窗右邊按鈕
  _buildBeautyDialogBtn(
      {required String confirmBtn, required Function() onTap}) {
    return Row(
      children: [
        Expanded(
          child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: appLinearGradientTheme.buttonSecondaryColor,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child:  Center(
                  child: Text('取消', style: appTextTheme.dialogCancelButtonTextStyle),
                ),
              )),
        ),
        const SizedBox(width: 7),
        Expanded(
            child: Container(
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: appLinearGradientTheme.buttonPrimaryColor,
                ),
                child: InkWell(
                  onTap: () => onTap(),
                  child: Center(
                      child: Text(confirmBtn,
                          style: appTextTheme.dialogConfirmButtonTextStyle)),
                ))),
      ],
    );
  }

  _buildIconAndTitle(
      {required String imagePath,
      required String title,
      required bool isOn,
      required Function() onTap}) {
    Color color = AppColors.mainWhite;
    if (!isOn) {
      color = AppColors.mainWhite.withOpacity(0.5);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CommonButton(
          btnType: CommonButtonType.icon,
          cornerType: CommonButtonCornerType.circle,
          isEnabledTapLimitTimer: false,
          width: 48.w,
          height: 48.w,
          padding: EdgeInsets.all(12.w),
          iconWidget: Image(
            image: AssetImage(imagePath),
          ),
          colorBegin: color,
          colorEnd: color,
          onTap: () {
            onTap.call();
          },
        ),
        SizedBox(
          height: WidgetValue.separateHeight,
        ),
        Text(title,
            style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 12,
                fontWeight: FontWeight.w600))
      ],
    );
  }

  //麥克風圖示(開啟或關閉)
  Widget micWidget({required Function() onTap}) {
    String imagePath = 'assets/images/icon_mic_video_able.png';
    if (!viewModel.micIsOn) {
      imagePath = 'assets/images/icon_mic_voice_disable.png';
    }
    return _buildIconAndTitle(
        imagePath: imagePath,
        title: '关闭麦克风',
        isOn: viewModel.micIsOn,
        onTap: () => onTap.call());
  }

  //開起關閉方法
  void switchMic() {
    setState(() {
      viewModel.micIsOn = !viewModel.micIsOn;
      ref.read(expressServiceProvider).turnMicrophoneOn(viewModel.micIsOn);
    });
  }

  //擴音圖示(開啟或關閉)
  Widget volumnWidget({required Function() onTap}) {
    String imagePath = 'assets/images/icon_volume_voice_able.png';
    if (!viewModel.volumeOn) {
      imagePath = 'assets/images/icon_volume_voice_disable.png';
    }
    return _buildIconAndTitle(
        imagePath: imagePath,
        title: '扩音',
        isOn: viewModel.volumeOn,
        onTap: () => onTap.call());
  }

  // 美顏 sheet 開關方法
  // void showBeautyOptionSheet(BuildContext context) {
  //   showModalBottomSheet(context: context,
  //       backgroundColor: Colors.transparent,
  //       barrierColor: Colors.transparent,
  //       builder: (context) {
  //         return const BeautyBottomSheet();
  //       });
  // }

  //擴音開起關閉方法
  void switchVolumn() {
    setState(() {
      viewModel.volumeOn = !viewModel.volumeOn;
      ref
          .read(expressServiceProvider)
          .setAudioOutputToSpeaker(viewModel.volumeOn);
    });
  }

  //相機開起關閉方法
  void swtichCamera() {
    setState(() {
      viewModel.isCameraOpen = !viewModel.isCameraOpen;
      ref.read(expressServiceProvider).turnCameraOn(viewModel.isCameraOpen);
    });
  }

  //美顏開起關閉方法
  void swtichBeauty() {
    setState(() {
      viewModel.isBeautyEditing = true;
      viewModel.openBeauty(context);
    });
  }

  // 美顏 Icon (開啟或關閉)
  Widget iconBeautyWidget({required Function() onTap}) {
    String imagePath = 'assets/images/icon_makeup_able.png';
    if (!viewModel.isBeautyEditing) {
      imagePath = 'assets/images/icon_makeup_disable.png';
    }
    return _buildIconAndTitle(
        imagePath: imagePath,
        title: '美颜',
        isOn: viewModel.isBeautyEditing,
        onTap: () => onTap.call());
  }

  // 相機 Icon (開啟或關閉)
  Widget cameraWidget({required Function() onTap}) {
    String imagePath = 'assets/images/icon_camera_video_able.png';
    if (!viewModel.isCameraOpen) {
      imagePath = 'assets/images/icon_camera_disable.png';
    }
    return _buildIconAndTitle(
        imagePath: imagePath,
        title: '关闭镜头',
        isOn: viewModel.isCameraOpen,
        onTap: () => onTap.call());
  }

  Widget largeVideoView() {
    final manager = ref.read(zegoSDKManagerProvider);
    return ValueListenableBuilder<Widget?>(
        valueListenable:
            manager.getVideoViewNotifier(widget.otherUserInfo?.userID),
        builder: (context, view, _) {
          if (view != null) {
            return view;
          } else {
            return Container(
              padding: const EdgeInsets.all(0),
              color: Colors.white,
            );
          }
        });
  }

  //結束通話按鈕
  Widget cancelCallWidget({required Function() onTap}) {
    String imagePath = 'assets/images/icon_cancel_phone.png';
    return CommonButton(
      btnType: CommonButtonType.icon,
      cornerType: CommonButtonCornerType.circle,
      isEnabledTapLimitTimer: false,
      width: 74.w,
      height: 74.w,
      padding: EdgeInsets.all(12.w),
      iconWidget: Image(
        image: AssetImage(imagePath),
      ),
      colorBegin: AppColors.mainCrimson,
      colorEnd: AppColors.mainCrimson,
      onTap: () {
        onTap.call();
      },
    );
  }

  /// 目前沒用到，因為目前速配結束後直接跳轉到聊天室
  /// 功能：速配模式下，掛電話或視訊後，快速發起下一個配對。
  closeMataDialog() {
    final bool isStrikeUpMateMode =
        ref.read(userInfoProvider).isStrikeUpMateMode ?? false;
    if (isStrikeUpMateMode) {
      StrikeUpListMateViewModel.stateController.sink.add(MateState.close);
    }
  }
}
