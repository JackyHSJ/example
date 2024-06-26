import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_req/account/ws_account_end_call_req.dart';
import 'package:frechat/models/ws_req/ws_base_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_end_call_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/call/calling_page_view_model.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';
import 'package:frechat/screens/strike_up_list/mate/strike_up_list_mate_view_model.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/system/util/svga_player_util.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/system/zego_call/zego_sdk_manager.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:marqueer/marqueer.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

class VoiceWaitingView extends ConsumerStatefulWidget {
  final bool? isAnswer;
  final ZegoCallData callData;
  final String? channel;
  final num roomId;
  final WsMemberInfoRes memberInfoRes;
  final SearchListInfo? searchListInfo;
  final CallingPageViewModel? viewModel;
  final bool isEnabledMicSwitch;
  final bool isEnabledVolumn;

  const VoiceWaitingView({
    Key? key,
    required this.isAnswer,
    required this.callData,
    required this.roomId,
    required this.memberInfoRes,
    required this.isEnabledMicSwitch,
    required this.isEnabledVolumn,
    this.searchListInfo,
    this.channel,
    this.viewModel,
  }) : super(key: key);

  @override
  ConsumerState<VoiceWaitingView> createState() => _CallState();
}

class _CallState extends ConsumerState<VoiceWaitingView> with TickerProviderStateMixin {
  bool micIsOn = true;
  bool volumnOn = false;
  String imagePath = 'assets/images/default_male_avatar.png';
  int? starCallTime;
  int? endCallTime;
  bool isStrikeUpMateMode = false;

  CallingPageViewModel? get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    isStrikeUpMateMode = ref.read(userInfoProvider).isStrikeUpMateMode ?? false;
    starCallTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    ref.read(chatUserModelNotifierProvider.notifier).loadDataFromSql();
    num? gender = ref.read(userInfoProvider).memberInfo!.gender;
    if (gender == 1) {
      imagePath = 'assets/images/default_female_avatar.png';
    }
    SvgaPlayerUtil.init(this);
  }

  //整理時間格式
  String _formatTime(int time) {
    int minutes = (time ~/ 60) % 60;
    int seconds = time % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // 设置状态栏透明
        statusBarIconBrightness: Brightness.dark, // 设置状态栏图标为暗色
      ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: (widget.memberInfoRes.avatarPath != null)
                  ? NetworkImage(HttpSetting.baseImagePath +
                  widget.memberInfoRes.avatarPath!)
                  : AssetImage(imagePath)
              as ImageProvider, // 使用 as ImageProvider 将 AssetImage 转换为 ImageProvider
              colorFilter: ColorFilter.mode(
                  const Color(0xFF000000).withOpacity(0.5), BlendMode.srcATop),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (widget.isAnswer!)

                  ///語音通話時跑馬燈不能手動滑動
                      ? Stack(
                    children: [
                      marquee(),
                      Container(
                        margin: EdgeInsets.only(
                            right: 16.w,
                            left: 16.w,
                            top: MediaQuery.of(context).padding.top),
                        width: MediaQuery.of(context).size.width,
                        height: 32.h,
                        color: Colors.transparent,
                      )
                    ],
                  )
                      : SizedBox(
                    height: 32.h,
                  ),
                  (widget.isAnswer!)
                      ? zoomOutIcon()
                      : Container(
                    height: 36.h,
                  ),
                  // timeTextWidget(),
                  personalInformationWidget(),
                  (widget.isAnswer!) ? timeTextWidget() : loadingWidget(),
                  Expanded(child: functionRowWidget())
                ],
              ),
              SVGAImage(SvgaPlayerUtil.animationController!),
            ],
          ),
        ),
      ),
    );
  }

  //跑馬燈
  Widget marquee() {
    return Container(
      margin: EdgeInsets.only(
          right: 16.w, left: 16.w, top: MediaQuery.of(context).padding.top),
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
                margin: EdgeInsets.only(left: 4.h),
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
    );
  }

  //縮放Icon
  Widget zoomOutIcon() {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.only(top: 12.h, left: 16.w),
          child: Image(
            width: 36.w,
            height: 36.h,
            image: const AssetImage('assets/images/icon_zoomout.png'),
          ),
        ),
        onTap: () {
          if (widget.memberInfoRes.avatarPath == null) {
            String imagePath = 'assets/images/default_male_avatar.png';
            num? gender = ref.read(userInfoProvider).memberInfo!.gender;
            if (gender == 1) {
              imagePath = 'assets/images/default_female_avatar.png';
            }
            Widget widget = Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(WidgetValue.btnRadius / 2),
                image: DecorationImage(
                  image: ExactAssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            );
            viewModel?.enterPiPMode(context, pipWidget: widget);
          } else {
            viewModel?.enterPiPMode(
              context,
              pipWidget: CachedNetworkImageUtil.load(
                  HttpSetting.baseImagePath + widget.memberInfoRes.avatarPath!,
                  radius: WidgetValue.btnRadius / 2),
            );
          }
        });
  }

  //時間
  Widget timeTextWidget() {
    return Consumer(builder: (context, ref, _) {
      final num time = ref.watch(userInfoProvider).callTimer ?? 0;
      return Container(
        margin: EdgeInsets.only(
          top: 235.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (widget.isAnswer!) ? _formatTime(time.toInt()) : "",
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

  //通話對象資訊
  Widget personalInformationWidget() {
    return Container(
      margin: EdgeInsets.only(top: 28.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              avatarWidget(),
              ageLabelWidget(),
              nameTextWidget(),
              detialInformationWidget()
            ],
          )
        ],
      ),
    );
  }

  Widget costInformation() {
    List<String> memberInfoCosts =
    (widget.memberInfoRes!.charmCharge ?? '').split('|');
    String textCharge = memberInfoCosts[1];
    String coin = ref.read(userInfoProvider).memberPointCoin!.coins.toString();
    return Center(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
              margin: EdgeInsets.only(
                  left: (widget.isAnswer!) ? 79.w : 131.w,
                  top: (widget.isAnswer!) ? 10.h : 42.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  costInformationContent('通话费率', '$textCharge/分钟'),
                  costInformationContent('金币馀额', coin),
                ],
              )),
        ),
      ),
    );
  }

  Widget costInformationContent(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 10.sp)),
        ImgUtil.buildFromImgPath('assets/images/icon_star.png', size: 16.w),
        Text(subtitle,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 10.sp)),
      ],
    );
  }

  // 頭像
  Widget avatarWidget() {
    final String avatarPath = widget.memberInfoRes.avatarPath ?? '';
    final num gender =
    ref.read(userInfoProvider).memberInfo!.gender == 1 ? 0 : 1;

    return Container(
      width: 120.w,
      height: 120.h,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: (avatarPath != '')
          ? AvatarUtil.userAvatar(
        HttpSetting.baseImagePath + widget.memberInfoRes.avatarPath!,
        size: 64.w,
      )
          : AvatarUtil.defaultAvatar(gender, size: 64.w),
    );
  }

  //年齡label
  Widget ageLabelWidget() {
    final num gender = widget.memberInfoRes.gender ?? 0;
    final num age = widget.memberInfoRes.age ?? 0;
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      child: IconTag.genderAge(gender: gender, age: age),
    );
  }

  // 名稱
  Widget nameTextWidget() {
    // 從 chatUserModel 獲取資料
    final List<ChatUserModel> chatUserModelList = ref.watch(chatUserModelNotifierProvider);
    // final ChatUserModel currentChatUserModel = chatUserModelList.firstWhere((info) {
    //   return info.userName == widget.memberInfoRes.userName;
    // });
    final ChatUserModel? currentChatUserModel = chatUserModelList?.firstWhere((info) => info.userName == widget.memberInfoRes.userName, orElse: () => ChatUserModel());

    SearchListInfo? updateSearchListInfo;
    if(currentChatUserModel!.userName != null){
      updateSearchListInfo = ConvertUtil.transferChatUserModelToSearchListInfo(currentChatUserModel!);
    }


    final String nickName = widget.memberInfoRes.nickName ?? '';
    final String userName = widget.memberInfoRes.userName ?? '';
    final String remarkName = updateSearchListInfo?.remark ?? '';
    final String displayName =
    ConvertUtil.displayName(userName, nickName, remarkName);

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [AppColors.mainYellow, AppColors.mainOrange],
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
      margin: EdgeInsets.only(top: 96.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                '语音聊天拨打中',
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

  //功能列(掛電話、禁音、擴音)
  Widget functionRowWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: WidgetValue.btnBottomPadding * 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Visibility(
            visible: widget.isEnabledMicSwitch,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: micWidget(onTap: () => switchMic()),
          ),
          cancelCallWidget(onTap: () => cancelCall()),
          Visibility(
            visible: widget.isEnabledVolumn,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: volumnWidget(onTap: () => switchVolumn()),
          ),
        ],
      ),
    );
  }

  //麥克風圖示(開啟或關閉)
  Widget micWidget({required Function() onTap}) {
    String imagePath = 'assets/images/icon_mic_voice_disable.png';
    Color color = AppColors.mainWhite.withOpacity(0.5);
    if (!micIsOn) {
      color = AppColors.mainWhite;
      imagePath = 'assets/images/icon_mic_voice_able.png';
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
      },
    );
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
      },
    );
  }

  //開起關閉方法
  void switchVolumn() {
    setState(() {
      volumnOn = !volumnOn;
      ref.read(expressServiceProvider).setAudioOutputToSpeaker(volumnOn);
    });
  }

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

  _showMataDialog() {
    if (isStrikeUpMateMode) {
      StrikeUpListMateViewModel.stateController.sink.add(MateState.close);
    }
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

  //結束通話(3-97)
  Future<WsAccountEndCallRes> _wsAccountEndCall(
      BuildContext context, String channel, num roomID) async {
    final reqBody = WsAccountEndCallReq.create(
      channel: channel,
      roomId: roomID,
    );
    final commToken = await FcPrefs.getCommToken();
    String? resultCodeCheck;
    final WsBaseReq msg = WsParamsReq.accountEndCall
      ..tId = commToken
      ..msg = reqBody;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountEndCall.f,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) =>
            BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));
    return (res.resultMap == null)
        ? WsAccountEndCallRes()
        : WsAccountEndCallRes.fromJson(res.resultMap);
  }
}
