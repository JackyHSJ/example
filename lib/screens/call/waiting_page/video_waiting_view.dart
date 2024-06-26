import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_req/account/ws_account_end_call_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/system/zego_call/zego_sdk_manager.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

//視訊等待畫面
class VideoWaitingView extends ConsumerStatefulWidget {
  final bool? isAnswer;
  final ZegoCallData callData;
  final WsMemberInfoRes memberInfoRes;
  final SearchListInfo? searchListInfo;
  final String? channel;
  final num roomId;
  final bool isEnabledMicSwitch;
  final bool isEnabledCamSwitch;
  final bool isEnabledVolumn;


  const VideoWaitingView({
    Key? key,
    required this.isAnswer,
    required this.callData,
    required this.memberInfoRes,
    required this.roomId,
    required this.isEnabledMicSwitch,
    required this.isEnabledCamSwitch,
    required this.isEnabledVolumn,
    this.searchListInfo,
    this.channel,
  }) : super(key: key);

  @override
  ConsumerState<VideoWaitingView> createState() => _VideoState();
}

class _VideoState extends ConsumerState<VideoWaitingView> {
  bool micIsOn = true;
  bool volumnOn = false;
  bool isFacingCamera = true;
  bool isCameraOpen = true;
  bool isBeautifyOpen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manager = ref.read(zegoSDKManagerProvider);
    return Scaffold(
        body: Stack(
      children: [
          ValueListenableBuilder<Widget?>(
            valueListenable: manager.getVideoViewNotifier(null),
            builder: (context, view, _) {
              if (view != null) {
                return Container(
                  width: UIDefine.getWidth(),
                  height: UIDefine.getHeight(),
                  child: view,
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(0),
                  color: Colors.white,
                );
              }
            }),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: personalInformationWidget()),
            loadingWidget(),
            functionRowWidget(),
          ],
        ),
      ],
    ));
  }

  Widget costInformation(){
    List<String> memberInfoCosts = (widget.memberInfoRes!.charmCharge ?? '').split('|');
    String textCharge = memberInfoCosts[1];
    String coin = ref.read(userInfoProvider).memberPointCoin!.coins.toString();
    return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
              width: 120.w,
              height: 46.h,
              margin: EdgeInsets.only(top: 86.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
              ),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  costInformationContent('通话费率','$textCharge/分钟'),
                  costInformationContent('金币馀额',coin),
                ],
              )
          ),
        ),
    );
  }
  Widget costInformationContent(String title,String subtitle){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 10.sp
            )),
        ImgUtil.buildFromImgPath('assets/images/icon_star.png', size: 16.w),
        Text(subtitle,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 10.sp
            )),
      ],
    );
  }

  //通話對象資訊
  Widget personalInformationWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        avatarWidget(),
        ageLabelWidget(),
        nameTextWidget(),
        detialInformationWidget()
      ],
    );
  }

  //頭像
  Widget avatarWidget() {
    final avatar = widget.memberInfoRes.avatarPath;
    final num gender = widget.memberInfoRes.gender ?? 0;
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: (avatar == null)
        ? AvatarUtil.defaultAvatar(gender ,size: 64.w)
        : AvatarUtil.userAvatar(HttpSetting.baseImagePath + widget.memberInfoRes.avatarPath!, size: 64.w),
    );
  }

  //年齡label
  Widget ageLabelWidget() {
    String image = 'assets/images/icon_female.png';
    if (widget.memberInfoRes.gender == 1) {
      image = 'assets/images/icon_male.png';
    }
    return Container(
      width: 36.w,
      margin: EdgeInsets.only(top: 12.h),
      // padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 1.h, bottom: 1.h),
      decoration: BoxDecoration(
        color: (widget.memberInfoRes.gender == 0) ? const Color.fromRGBO(253, 115, 165, 1) : const Color.fromRGBO(51, 138, 243, 1),
        borderRadius: const BorderRadius.all(Radius.circular(48.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            width: 12.w,
            height: 12.h,
            color: const Color.fromRGBO(255, 255, 255, 1),
            image: AssetImage(image),
          ),
          SizedBox(
            width: 2.w,
          ),
          Text(
            "${widget.memberInfoRes.age}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
              color: const Color.fromRGBO(255, 255, 255, 1),
            ),
          )
        ],
      ),
    );
  }

  //名稱
  Widget nameTextWidget() {
    // 從 chatUserModel 獲取資料
    final List<ChatUserModel> chatUserModelList = ref.watch(chatUserModelNotifierProvider);
    final ChatUserModel currentChatUserModel = chatUserModelList.firstWhere((info) {
      return info.userName == widget.memberInfoRes.userName;
    });
    SearchListInfo? updateSearchListInfo = ConvertUtil.transferChatUserModelToSearchListInfo(currentChatUserModel);

    final String nickName = widget.memberInfoRes.nickName ?? '';
    final String userName = widget.memberInfoRes.userName ?? '';
    final String remarkName = updateSearchListInfo?.remark ?? '';
    final String displayName = ConvertUtil.displayName(userName, nickName, remarkName);

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [
              AppColors.mainYellow,
              AppColors.mainOrange
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ).createShader(bounds);
        },
        child: Text(
          displayName,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  //整理詳細資訊listWidget
  List<Widget> tidyInformation() {
    List<String> listString = [];
    if (widget.memberInfoRes.hometown != null) {
      listString.add(widget.memberInfoRes.hometown!);
    }
    if (widget.memberInfoRes.height != null) {
      listString.add("${widget.memberInfoRes.height}cm");
    }
    if (widget.memberInfoRes.weight != null) {
      listString.add("${widget.memberInfoRes.weight}kg");
    }
    List<Widget> listWidget = [];
    for (int i = 0; i < listString.length; i++) {
      listWidget.add(detialContentLabelWidget(listString[i]));
      if (listString[i] != listString.last) {
        listWidget.add(SizedBox(
          width: 4.w,
        ));
      }
    }
    return listWidget;
  }

  //詳細資訊
  Widget detialInformationWidget() {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: tidyInformation(),
      ),
    );
  }

  //詳細資訊label背景
  Widget detialContentLabelWidget(String content) {
    return Container(
      padding: EdgeInsets.only(top: 1.h, bottom: 1.h, right: 6.w, left: 6.w),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }

  //撥號中Loading圖示
  Widget loadingWidget() {
    return Container(
      margin: EdgeInsets.only(top: WidgetValue.btnBottomPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                '视频聊天拨打中',
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              ),
              Container(
                // margin: EdgeInsets.only(top: ),
                child: LoadingAnimationWidget.prograssiveDots(
                  color: Colors.white,
                  size: 36,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  //功能列(掛電話、禁音、掛電話、擴音、美顏)
  Widget functionRowWidget() {

    return Container(
      padding: EdgeInsets.symmetric(vertical: WidgetValue.btnBottomPadding),
      margin: EdgeInsets.only(top: (widget.isAnswer!) ? 110.h : 130.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Visibility(
            visible: widget.isEnabledMicSwitch,
            child: micWidget(onTap: () => switchMic()),
          ),
          Visibility(
            visible: widget.isEnabledCamSwitch,
            child:cameraWidget(onTap: ()=> swtichCamera()),
          ),
          cancelCallWidget(onTap: () => cancelCall()),
          Visibility(
            visible: widget.isEnabledCamSwitch,
            child: makeUpWidget(onTap:()=>switchMakeUp()),
          ),
          Visibility(
            visible: widget.isEnabledVolumn,
            child:volumnWidget(onTap: ()=> switchVolumn()),
          ),
        ],
      ),
    );
  }

  //麥克風圖示(開啟或關閉)
  Widget micWidget({required Function() onTap}) {
    String imagePath = 'assets/images/icon_mic_video_able.png';
    Color color = AppColors.mainWhite.withOpacity(0.5);
    if (!micIsOn) {
      color = AppColors.mainWhite;
      imagePath = 'assets/images/icon_mic_voice_disable.png';
    }
    return CommonButton(
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
      },);
  }

  //開起關閉方法
  void switchMic() {
    setState(() {
      micIsOn = !micIsOn;
      ref.read(expressServiceProvider).turnMicrophoneOn(micIsOn);
    });
  }

  //擴音圖示(開啟或關閉)
  Widget volumnWidget({required Function() onTap}) {
    String imagePath = 'assets/images/icon_volume_voice_able.png';
    Color color = AppColors.mainWhite;
    if (!volumnOn) {
      color = AppColors.mainWhite.withOpacity(0.5);
      imagePath = 'assets/images/icon_volume_voice_disable.png';
    }
    return CommonButton(
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
      },);
  }

  //擴音開起關閉方法
  void switchVolumn() {
    setState(() {
      volumnOn = !volumnOn;
      ref.read(expressServiceProvider).setAudioOutputToSpeaker(volumnOn);
    });
  }

  //相機圖示(開啟或關閉)
  Widget cameraWidget({required Function() onTap}) {
    String imagePath = 'assets/images/icon_camera_video_able.png';
    Color color = AppColors.mainWhite;
    if (!isCameraOpen) {
      color = AppColors.mainWhite.withOpacity(0.5);
      imagePath = 'assets/images/icon_camera_disable.png';
    }
    return CommonButton(
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
      },);
  }

  //相機開起關閉方法
  void swtichCamera() {
    setState(() {
      isCameraOpen = !isCameraOpen;
      // ZEGOSDKManager.instance.expressService.turnMicrophoneOn(micIsOn);
    });
  }


  //美顏圖示(開啟或關閉)
  Widget makeUpWidget({required Function() onTap}) {
    String imagePath = 'assets/images/icon_makeup_able.png';
    Color color = AppColors.mainWhite;
    if (!isBeautifyOpen) {
      color = AppColors.mainWhite.withOpacity(0.5);
      imagePath = 'assets/images/icon_makeup_disable.png';
    }
    return CommonButton(
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
      },);
  }

  //美顏開起關閉方法
  void switchMakeUp() {
    setState(() {
      isBeautifyOpen = !isBeautifyOpen;
      // ZEGOSDKManager.instance.expressService.setAudioOutputToSpeaker(volumnOn);
    });
  }
  //結束通話按鈕
  Widget cancelCallWidget({required Function() onTap}){
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
      colorBegin:AppColors.mainCrimson ,
      colorEnd: AppColors.mainCrimson,
      onTap: () {
        onTap.call();
      },);
  }

  //結束通話
  Future<void> cancelCall() async {
    ref.read(callAuthenticationManagerProvider).cancelInvitedCall(
        context,
        callData: widget.callData,
        channel: widget.channel,
        roomId: widget.roomId
    );
  }

  Future<void> _wsAccountEndCall(BuildContext context, {
    required String channel, required num roomID
  }) async {
    final reqBody = WsAccountEndCallReq.create(
      channel: channel,
      roomId: roomID,
    );
    ref.read(accountWsProvider).wsAccountEndCall(reqBody,
        onConnectSuccess: (succMsg) => BaseViewModel.showToast(context, '通話結束'),
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
  }
}
