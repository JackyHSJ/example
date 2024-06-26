import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_gift_detail_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_official_message_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/screens/profile/certification/real_person/personal_certification_real_person.dart';
import 'package:frechat/screens/profile/edit/personal_edit.dart';
import 'package:frechat/screens/profile/greet/personal_greet.dart';
import 'package:frechat/screens/user_info_view/user_info_view.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_audio_model.dart';
import 'package:frechat/system/database/model/chat_gift_model.dart';
import 'package:frechat/system/database/model/chat_image_model.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/extension/duration.dart';
import 'package:frechat/system/extension/json.dart';
import 'package:frechat/system/provider/chat_Gift_model_provider.dart';
import 'package:frechat/system/provider/chat_audio_model_provider.dart';
import 'package:frechat/system/provider/chat_image_model_provider.dart';
import 'package:frechat/system/provider/chat_message_model_provider.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/audio_util.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/model/review_audio_res.dart';
import 'package:frechat/widgets/shared/aspect_ratio_image.dart';
import 'package:frechat/widgets/shared/bottom_sheet/common_bottom_sheet.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:intl/intl.dart';

import '../../system/providers.dart';


enum ChatMessageStatus {
  sending,//傳送中
  complete,//傳送完成
  fail,//傳送失敗
  reviewFail,//審核失敗
}

enum ChatMessageType {
  none,
  text,
  gift,
  audio,
  image,
  strikup,
}

enum ChatMessageTextType {
  none,
  common,
  gift,
  call,
  system,
}


// 發送消息泡泡框
class ChatMessage extends ConsumerStatefulWidget {
  final ZIMMessage? zimMessage;
  final String avatar;
  final WsMemberInfoRes? memberInfo;
  final SearchListInfo? searchListInfo;
  final XFile? xfile;
  final bool isMe;
  final ChatRoomViewModel viewModel;
  final int index;
  final bool showTimeDistinction;
  final ValueNotifier<int?> currentAudioIndexNotifier;
  final ValueNotifier<String> currentAudioUrlNotifier;
  final List<ChatMessageModel> chatMessageModelList;
  final ChatMessageStatus chatMessageStatus;


  const ChatMessage({
    this.zimMessage,
    this.avatar = '',
    this.memberInfo,
    this.searchListInfo,
    this.xfile,
    required this.isMe,
    required this.viewModel,
    required this.index,
    required this.showTimeDistinction,
    required this.currentAudioIndexNotifier,
    required this.currentAudioUrlNotifier,
    required this.chatMessageModelList,
    required this.chatMessageStatus,
    super.key,
  });

  @override
  ConsumerState<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends ConsumerState<ChatMessage>{


  SearchListInfo? get _searchListInfo => widget.searchListInfo;

  Duration? time;
  bool getVoiceTimeLoading = false;
  // List<int> myReplyIndexList = [];
  String pointsHint = '';
  Map? officialMessageInfoMap;
  bool showFemalePoints = false;//是否显示女方通话收益
  bool contentEmptyShow = true;
  late AppTheme _appTheme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  bool convertMiao = false;
  bool showFemaleReplyPoints = false;

  String _chatContent = '';



  Future<void> initVoiceTime() async {
    ChatMessageType type = _getChatMessageType();
    if(type == ChatMessageType.audio) {
      return;
    }

    ZIMTextMessage? zimTextMessage = widget.zimMessage as ZIMTextMessage?;
    final jsonObj = json.decode(zimTextMessage?.message ?? '');
    final ReviewAudioRes reviewAudioRes = ReviewAudioRes.fromJson(jsonObj['content']['message']);

    num audioTime =  reviewAudioRes.audioTime ??0;
    if(audioTime != 0 ){
      time = Duration(milliseconds: audioTime.toInt());
    }else{
      time = await AudioUtils.getAudioTime(
          audioUrl: reviewAudioRes.download_url ?? '',
          addBaseImagePath: false
      );
    }

    getVoiceTimeLoading = false;
    setState(() {});
  }
  ///判断女用户是否显示回复收益
  void judgeFemaleNeedShowRelpyPoints(){
    if(widget.zimMessage!.senderUserID != ref.read(userInfoProvider).memberInfo!.userName){
      ///对方来电则直接显示回复收益
      if(widget.zimMessage!.type == ZIMMessageType.text){
        ZIMTextMessage? zimTextMessage = widget.zimMessage as ZIMTextMessage?;
        Map<String, dynamic> messageDataMap = {};
        ///礼物收益直接显示回复收益
        if(zimTextMessage!.message.toString().isNotEmpty && zimTextMessage!.message.contains('[礼物]')){
          showFemaleReplyPoints = true;
          final Map<String, dynamic> jsonObj = json.decode(widget.zimMessage!.extendedData);
          double points = jsonObj['points'].toDouble();
          pointsHint = '+$points';
          return;
        }
        if(zimTextMessage!.message.toString().isNotEmpty && zimTextMessage!.message.contains('chatType')){
          messageDataMap = json.decode(zimTextMessage!.message) as Map<String, dynamic>;
          showFemaleReplyPoints = true;
          final Map<String, dynamic> jsonObj = json.decode(widget.zimMessage!.extendedData);
          int incomeflag = jsonObj['incomeflag'];
          double points = jsonObj['points'].toDouble();
          pointsHint = '+$points';
          return;
          // if(incomeflag == 1){
          //   pointsHint = '+$points';
          // }else{
          //   pointsHint ='+0';
          // }
        }else{
          ///若不是还是需要判断是否需要显示(可能是纯文字或礼物讯息)
          if(needShowPointsHint()){
            showFemaleReplyPoints = true;
            howManyCoinFemaleGet();
          }else{
            if(widget.chatMessageModelList.length != 1){
              int myRelpyIndex = 0;
              for (int i= widget.chatMessageModelList.length -1; i>=0; i--) {
                if(needShowPointsHint()){
                  myRelpyIndex = i;
                  break;
                }
              }
              if(widget.index < myRelpyIndex){
                showFemaleReplyPoints = true;
                howManyCoinFemaleGet();
              }
            }
          }
        }
      }else{
        if(needShowPointsHint()){
          showFemaleReplyPoints = true;
          howManyCoinFemaleGet();
        }else{
          if(widget.chatMessageModelList.length != 1){
            int myRelpyIndex = 0;
            for (int i= widget.chatMessageModelList.length -1; i>=0; i--) {
              if(needShowPointsHint()){
                myRelpyIndex = i;
                break;
              }
            }
            if(widget.index < myRelpyIndex){
              showFemaleReplyPoints = true;
              howManyCoinFemaleGet();
            }
          }
        }
      }
    }
  }

  ///判断是否需要显示积分提示(需要区分女生自己回复消息状态)
  bool needShowPointsHint(){
    bool needShow = false;
    List<ChatMessageModel> chatMessageModelList = widget.chatMessageModelList;
    int myIndex = widget.index;
    int firstIndex = myIndex+1;
    if(chatMessageModelList.length > 1 ){
      for(int i = firstIndex; i < chatMessageModelList.length;i++){
        num sentStatus = chatMessageModelList[i].sendStatus ?? 0;
        if(chatMessageModelList[i].senderName == ref.read(userInfoProvider).memberInfo!.userName && sentStatus == 1){
          needShow = true;
          break;
        }
      }
    }
    return needShow;
  }

  /// 取得女方收益
  void howManyCoinFemaleGet(){
    final Map<String, dynamic> jsonObj = json.decode(widget.zimMessage!.extendedData);
    int incomeflag = jsonObj['incomeflag'];
    DateTime expireTime = DateTime.fromMillisecondsSinceEpoch(jsonObj['expireTime'] ?? 0);
    DateTime halfTime = DateTime.fromMillisecondsSinceEpoch(jsonObj['halfTime'] ?? 0);
    double points = jsonObj['points'].toDouble();
    ChatMessageModel? chatMessageModel;
    int showCoinMessageIndex = widget.index! +1;
    String myUserName = ref.read(userInfoProvider).memberInfo!.userName??'';
    ///找出回复的消息
    for(int i = showCoinMessageIndex; i <= widget.chatMessageModelList.length; i++){
      num sentStatus = widget.chatMessageModelList[i].sendStatus ?? 0;
      if(widget.chatMessageModelList[i].senderName == myUserName  && sentStatus == 1){
        chatMessageModel = widget.chatMessageModelList[i];
        print(chatMessageModel.content);
        break;
      }
    }
    num? timeStamp = chatMessageModel!.timeStamp;
    DateTime replyMessageTime = DateTime.fromMillisecondsSinceEpoch( timeStamp!.toInt());
    if(incomeflag == 1){
      ///判断是否是在正常时间内回复
      if(replyMessageTime.isBefore(halfTime)){
        pointsHint = '+$points';
        ///判断是否在半衰期时间内回复
      }else if(replyMessageTime.isBefore(expireTime)){
        int halfDuration = jsonObj['halfDuration']??0;
        pointsHint= '您未在$halfDuration分钟内回复信息，仅得+${points/2}';
      }else{
        pointsHint ='您未在时限内回复信息，未获得积分';
      }
    }else{
      pointsHint ='+0';
    }

  }

  /// 取得訊息類型
  ChatMessageType _getChatMessageType(){
    try {
      final ZIMMessageType? type = widget.zimMessage?.type;
      if(type == ZIMMessageType.image){
        return ChatMessageType.image;
      }else{
        final ZIMTextMessage zimTextMsg = widget.zimMessage as ZIMTextMessage;
        if(zimTextMsg.message.contains('[礼物]')) {
          return ChatMessageType.gift;
        }
        final Map<String, dynamic> jsonObj = json.decode(zimTextMsg.message);
        if(jsonObj['type'] == 9) {
          return ChatMessageType.audio;
        }
        if(jsonObj['type'] == 0) {
          return ChatMessageType.text;
        }
        if(jsonObj['type'] == 3) {
          return ChatMessageType.strikup;
        }

        return ChatMessageType.none;
      }
    } catch (e) {
      return ChatMessageType.none;
    }

  }
  /// 取得文字訊息類型
  ChatMessageTextType _getChatMessageTextType(){

    ZIMTextMessage? zimTextMessage = widget.zimMessage as ZIMTextMessage?;
    Map<String, dynamic> messageDataMap = {};
    Map<String, dynamic> extendedDataMap = {};
    if (zimTextMessage!.message.toString().isNotEmpty && !zimTextMessage!.message.contains('[礼物]')) {
      messageDataMap = json.decode(zimTextMessage!.message) as Map<String, dynamic>;
    }
    extendedDataMap = json.decode(zimTextMessage!.extendedData) as Map<String, dynamic>;
    try {
      if (extendedDataMap['giftUrl'] != null) {
        return ChatMessageTextType.gift;
      } else if (messageDataMap['content'].toString().contains('chatType')) {
        return ChatMessageTextType.call;
      } else {
        if (widget.searchListInfo !=null && widget.searchListInfo?.userName == 'java_system') {
          return ChatMessageTextType.system;
        } else {
          return ChatMessageTextType.common;
        }
      }
    } on FormatException {
      debugPrint('The info.extendedData is not valid JSON');
      return ChatMessageTextType.none;
    }

  }
  /// 取得傳送禮物
  GiftListInfo _getGiftListInfo(){
    String? messageUuid = widget.chatMessageModelList[widget.index].messageUuid;
    final notifier = ref.read(chatGiftModelNotifierProvider);
    ChatGiftModel model = notifier.firstWhere((info) => info.messageUuid == messageUuid);
    return GiftListInfo(
        giftImageUrl: model.giftImageUrl,
        svgaFileId: model.svgaFileId,
        svgaUrl: model.svgaUrl,
        giftId: model.giftId,
        giftSendAmount: model.giftSendAmount,
        giftName:model.giftName,
        coins: model.coins,
        categoryName:model.giftCategoryName);

  }
  /// 取得傳送圖片
  String _getImagePath(){
    String? messageUuid = widget.chatMessageModelList[widget.index].messageUuid;
    final notifier = ref.read(chatImageModelNotifierProvider);
    ChatImageModel model = notifier.firstWhere((info) => info.messageUuid == messageUuid);
    return model.imagePath??'';
  }

  /// 取得傳送錄音黨
  ChatAudioModel _getChatAudioModel(){
    String? messageUuid = widget.chatMessageModelList[widget.index].messageUuid;
    final notifier = ref.read(chatAudioModelNotifierProvider);
    ChatAudioModel model = notifier.firstWhere((info) => info.messageUuid == messageUuid);
    return model;
  }
  //timeStamp轉換
  String transferTimeStamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    String formattedTime =
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime beginningOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = beginningOfWeek.add(const Duration(days: 6));

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      // 同一天
      return '今天';
    } else if (dateTime.isAfter(beginningOfWeek) &&
        dateTime.isBefore(endOfWeek)) {
      // 同一週
      List<String> weekdays = ['一', '二', '三', '四', '五', '六', '日'];
      return '星期${weekdays[dateTime.weekday - 1]}';
    } else {
      // 不同週
      return '${dateTime.month}/${dateTime.day}';
    }
  }

  String getCallTime(String time) {
    // 找到通话时长的索引
    int callDurationIndex = time.indexOf('通话时长');
    // 截取通话时长后面的部分
    String callDuration = time.substring(callDurationIndex + 4);
    return callDuration;
  }

  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  String getCallingTypeRecentlyMessage(String? caller,String duration, num? type,num? chatType){
    final String userName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    String msg = '';
    switch(type){
      case 0:
        if(chatType == 1 || chatType == 7){
          msg = '语音通话:$duration';
        }else{
          msg = '视频通话:$duration';
        }
        break;
      case 1:
        String typeString = "";
        if(chatType == 1 || chatType == 7){
          typeString = '语音通话';
        }else{
          typeString = '视频通话';
        }
        if(caller == userName){
          msg = '$typeString已取消';
        }else{
          msg = '未接听$typeString';
        }
        break;
      case 2:
        if(chatType == 1 || chatType == 7){
          msg = '语音通话已拒绝';

        }else{
          msg = '视频通话已拒绝';
        }
        break;
      default:
        break;
    }
    return msg;
  }

  String getCallingTypeIconString( num? type,num? chatType) {
    String icon = '';
    switch(type){
      case 0:
        if(chatType == 1 || chatType == 7){

          icon = widget.isMe ? _appImageTheme.iconCallPersonal : _appImageTheme.iconCallOpposite;
          // icon = 'assets/images/icon_calltime.png';
        }else{
          icon = widget.isMe ? _appImageTheme.iconVideoPersonal : _appImageTheme.iconVideoOpposite;
          // icon = 'assets/images/icon_videotime.png';
        }
        break;
      case 1:
        if(chatType == 1 || chatType == 7){
          icon = widget.isMe ? _appImageTheme.iconCallCancelPersonal : _appImageTheme.iconCallCancelOpposite;
          // icon = 'assets/images/icon_cancel_call.png';
        }else{
          icon = widget.isMe ? _appImageTheme.iconVideoCancelPersonal : _appImageTheme.iconVideoCancelOpposite;

          // icon =  'assets/images/icon_cancel_viedo.png';
        }
        break;
      case 2:
        if(chatType == 1 || chatType == 7){
          icon = widget.isMe ? _appImageTheme.iconCallCancelPersonal : _appImageTheme.iconCallCancelOpposite;
          // icon = 'assets/images/icon_cancel_call.png';
        }else{
          icon = widget.isMe ? _appImageTheme.iconVideoCancelPersonal : _appImageTheme.iconVideoCancelOpposite;
          // icon =  'assets/images/icon_cancel_viedo.png';
        }
        break;
      default:
        break;
    }

    return icon;
  }

  String formatMilliseconds(int milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds);
    int seconds = duration.inSeconds % 60;
    int minutes = duration.inMinutes % 60;
    int hours = duration.inHours;

    String hoursStr = (hours > 0) ? '${hours.toString().padLeft(2, '0')}:' : '';
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr$minutesStr:$secondsStr';
  }

  //預覽圖片
  void _onTapPreviewImage(Image currentImage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreen(
          image: currentImage,
        ),
      ), //
    );
  }

  ///重新傳送
  void _onTapResendButton(){
    CommonBottomSheet.show(BaseViewModel.getGlobalContext(),
      actions: [
        CommonBottomSheetAction(
          title: '重传',
          titleStyle:  _appTextTheme.commonButtonCancelTextStyle,
          onTap: () {
            BaseViewModel.popPage(BaseViewModel.getGlobalContext());
            _resendMessage();

          },
        ),
      ],
    );
  }

  void _resendMessage(){
    ChatMessageType type = _getChatMessageType();
    String? messageUuid = widget.chatMessageModelList[widget.index].messageUuid;
    print('重新傳送uuID $messageUuid');
    switch(type){
      case ChatMessageType.text:
        widget.viewModel.sendTextMessage(messageUUId:messageUuid,searchListInfo: _searchListInfo,message: _chatContent,contentType: 0,isStrikeUp: false);
        break;
      case ChatMessageType.strikup:
        widget.viewModel.sendTextMessage(messageUUId:messageUuid,searchListInfo: _searchListInfo,message: _chatContent,contentType: 3,isStrikeUp: false);
        break;
      case ChatMessageType.gift:
        widget.viewModel.sendGiftMessage(messageUUId:messageUuid,searchListInfo: _searchListInfo,isStrikeUp: false,unRead: 0,giftListInfo: _getGiftListInfo());
        break;
      case ChatMessageType.image:
        widget.viewModel.sendImageMessage(messageUUId:messageUuid,searchListInfo: _searchListInfo,isStrikeUp: false,unRead: 0,imgUrl: _getImagePath(),isLocalImage: true);

        break;
      case ChatMessageType.audio:
        ChatAudioModel model = _getChatAudioModel();
        widget.viewModel.sendVoiceMessage(messageUUId:messageUuid,searchListInfo: _searchListInfo,isStrikeUp: false,unRead: 0,audioUrl: model.audioPath,audioTime: model.timeStamp,isLocalFile: true);

        break;
      default:
        break;
    }


  }


  @override
  void initState() {
    super.initState();
    // allChatMessageModelList = ref.read(chatMessageModelNotifierProvider);
    // initVoiceTime();
    // getZimMessageListIsMeIndex();
    if(ref.read(userInfoProvider).memberInfo?.gender == 0 && widget.zimMessage!.type == ZIMMessageType.text && widget.isMe){
      ZIMTextMessage? zimTextMessage = widget.zimMessage as ZIMTextMessage?;
      Map<String, dynamic> messageDataMap = {};
      ///是否显示女生自己发起通话的获取金币收益
      if (zimTextMessage!.message.toString().isNotEmpty && !zimTextMessage!.message.contains('[礼物]')) {
        messageDataMap = json.decode(zimTextMessage!.message) as Map<String, dynamic>;
        if(messageDataMap['content'].toString().contains('chatType') && widget.isMe){
          showFemalePoints = true;
          Map officialMessageInfoMap = json.decode(messageDataMap['content']);
          if(officialMessageInfoMap['chatType'] == null){
            officialMessageInfoMap = officialMessageInfoMap['content']['message'];
          }
          pointsHint = '+${officialMessageInfoMap['points']}';
          showFemalePoints = true;
        }
      }
    }
  }

  @override
  dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool showGetCoin = false;
    _appTheme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _appTheme.getAppColorTheme;
    _appImageTheme =_appTheme.getAppImageTheme;
    _appTextTheme = _appTheme.getAppTextTheme;
    _appLinearGradientTheme = _appTheme.getAppLinearGradientTheme;
    if(ref.read(userInfoProvider).memberInfo!.gender == 0){
      judgeFemaleNeedShowRelpyPoints();
    }
    return (!contentEmptyShow && !widget.isMe)
        ? Container()
        : Column(
            children: [
              _timeDistinctionText(),
              (widget.isMe) ? _mySideMessage() : _oppoSideMessage(),
              (widget.isMe) ? _failReviewHint() : Container(),
              (showFemalePoints)
                  ? Padding(
                      padding: EdgeInsets.only(right: 60.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image(
                            width: 24.w,
                            height: 24.w,
                            image: const AssetImage('assets/images/icon_points.png'),
                          ),
                          Text(pointsHint,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 8.sp,
                                  color: AppColors.textFormBlack))
                        ],
                      ))
                  : Container(),
              (showFemaleReplyPoints) ? pointsRow() : Container(),
              SizedBox(height: 10),
              // (showGetCoin && !widget.isMe) ? (widget.searchListInfo!.userName == 'java_system')?Container():pointsRow() : Container()
            ],
          );
  }

  /// 時間區間
  Widget _timeDistinctionText(){
    return Visibility(
      visible: widget.showTimeDistinction,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Text(
          formatDateTime(DateTime.fromMillisecondsSinceEpoch(widget.zimMessage!.timestamp)),
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10.sp, color: AppColors.mainGrey),
        ),
      ),
    );
  }

  /// 自己的訊息
  Widget _mySideMessage(){
    return Container(
      margin: EdgeInsets.only(right: 8.w, top: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // _sendStatusWidget(),
          _mySideMessageStatusWidget(),
          _messageContentWidget(),
          _mySideAvatarWidget()
        ],
      ),
    );
  }

  /// 對方的訊息
  Widget _oppoSideMessage(){
    return  Container(
      margin: EdgeInsets.only(top: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _oppoSideAvatarWidget(),
          _messageContentWidget(),
          _oppoSideMessageStatusWidget(),
          // Container(margin: EdgeInsets.only(left: 4.w), child: timeAndReadWidget(),),
        ],
      ),
    );
  }

  /// 頭像 - 自己的頭像
  Widget _mySideAvatarWidget(){
    String? path  = ref.read(userInfoProvider).memberInfo?.avatarPath;
    Widget avatarWidget = AvatarUtil.defaultAvatar(ref.read(userInfoProvider).memberInfo!.gender!, size: 32.w);
    if(path != null){
      avatarWidget = AvatarUtil.userAvatar(HttpSetting.baseImagePath + path, size: 32.w);
    }
    return (widget.isMe)?Padding(padding: EdgeInsets.only(left: 8.w),child: avatarWidget):Container();
  }

  /// 頭像 - 對方的頭像
  Widget _oppoSideAvatarWidget() {
    final bool avatarIsEmpty = (widget.memberInfo?.avatarPath == null || widget.memberInfo?.avatarPath == '');
    final num avatarAuth = widget.memberInfo?.avatarAuth ?? 0;
    final CertificationType avatarType = CertificationModel.getType(authNum: avatarAuth);
    final num gender = widget.memberInfo?.gender ?? 0; // 對方性別
    final num myGender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    return (widget.searchListInfo!.userName == 'java_system')
            ? Container(
                margin: EdgeInsets.only(left: 8.w, right: 8.w),
                width: 32.w,
                height: 32.h,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: (widget.avatar.isNotEmpty)
                    ? AvatarUtil.localAvatar(_appImageTheme.javaSystemIcon, size: 32.w)
                    : AvatarUtil.defaultAvatar(gender == 1 ? 0 : 1, size: 32.w)
              )
            : GestureDetector(
                child: (avatarIsEmpty == false && avatarType == CertificationType.done)
                  ? Padding(padding: EdgeInsets.only(left: 8.w, right: 8.w),child: AvatarUtil.userAvatar(HttpSetting.baseImagePath + widget.avatar, size: 32.w))
                  : Padding(padding: EdgeInsets.only(left: 8.w, right: 8.w),child: AvatarUtil.defaultAvatar(myGender == 0 ? 1 : 0, size: 32.w)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserInfoView(
                        searchListInfo: widget.searchListInfo,
                        //forProfile: false,
                        displayMode: DisplayMode.chatMessage,
                      ),
                    ),
                  );
                },
              );
  }

  /// 訊息狀態 - 自己的訊息狀態（時間/傳送狀態/已讀狀態）
  Widget _mySideMessageStatusWidget(){

    List<Widget> child = [];
    bool isRead = widget.zimMessage!.receiptStatus == ZIMMessageReceiptStatus.done;
    ChatMessageStatus status = widget.chatMessageStatus;
    switch(status){
      case ChatMessageStatus.complete:
        child.add(_timeStampWidget(isRead:isRead));
        break;
      case ChatMessageStatus.sending:
        child.add(ImgUtil.buildFromImgPath(_appImageTheme.iconChatMessageSending,size: 13));
        break ;
      case ChatMessageStatus.fail:
        child.add(_messageStatusResendButton());
        break;
      case ChatMessageStatus.reviewFail:
        child.add(ImgUtil.buildFromImgPath(_appImageTheme.iconChatMessageReviewWarning,size: 20));
        break;
      default:
        break;
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: child,
      ),
    );
  }

  /// 訊息狀態 - 對方的訊息狀態（時間）
  Widget _oppoSideMessageStatusWidget(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: _timeStampWidget(isRead: false),
    );
  }

  /// 訊息狀態 - 訊息重傳按鈕
  Widget _messageStatusResendButton(){
    return GestureDetector(
      child: ImgUtil.buildFromImgPath(_appImageTheme.iconChatMessageResend,size: 20),
      onTap: () {
        if(mounted){
          _onTapResendButton();
        }
      }
    );
  }

  /// 訊息狀態 - 發送時間
  Widget _timeStampWidget({required bool isRead}){

    return Column(
      children: [
        Visibility(
            visible: isRead,
            child: Text('已读', style: TextStyle(fontSize: 10.sp, color: Colors.grey,))),
        Text(
          transferTimeStamp(widget.zimMessage!.timestamp),
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  /// 訊息內容
  Widget _messageContentWidget(){
    ChatMessageType type = _getChatMessageType();
    switch (type) {
      case ChatMessageType.text || ChatMessageType.strikup || ChatMessageType.gift:
        return _textMessageWidget();
      case ChatMessageType.image:
        return _imageMessageWidget();
      case ChatMessageType.audio:
        return _audioMessageWidget();
      case ChatMessageType.none:
        return Container();
      default:
        return Container();
    }
  }

  /// 訊息內容 - 文字訊息
  Widget _textMessageWidget() {

    try {

      ZIMTextMessage? zimTextMessage = widget.zimMessage as ZIMTextMessage?;
      Map<String, dynamic> messageDataMap = {};
      Map<String, dynamic> extendedDataMap = {};
      if (zimTextMessage!.message.toString().isNotEmpty && !zimTextMessage!.message.contains('[礼物]')) {
        messageDataMap = json.decode(zimTextMessage!.message) as Map<String, dynamic>;
      }
      extendedDataMap = json.decode(zimTextMessage!.extendedData) as Map<String, dynamic>;
      ChatMessageTextType  textType = _getChatMessageTextType();
      switch(textType){
        case ChatMessageTextType.common:
          messageDataMap = json.decode(zimTextMessage.message);
          return _commonTextMessageWidget(messageDataMap['content']);

        case ChatMessageTextType.gift:
          return _giftTextMessageWidget(extendedDataMap['giftUrl'], extendedDataMap['giftName'], extendedDataMap['giftSendAmount']);

        case ChatMessageTextType.call:
          officialMessageInfoMap = json.decode(messageDataMap['content']);
          return _callTimeTextMessageWidget(officialMessageInfoMap!);

        case ChatMessageTextType.system:
          final contentMap = json.tryDecode(messageDataMap['content']);
          return _systemTextMessageWidget(contentMap);
        default:
          return Container();
      }

    } on FormatException {
      debugPrint('The info.extendedData is not valid JSON');
      contentEmptyShow = false;
      setState(() {});
      return Container();
    }


  }

  /// 訊息內容 - 文字訊息 - 文字內容
  Widget _commonTextMessageWidget(String content) {

    if(content.isEmpty){
      contentEmptyShow = false;
      setState(() {});
      return Container();
    }


      _chatContent = content;
    // if(Platform.isIOS && convertMiao == false){
    //   newContent =  replaceTextWithMiao(content);
    // }
    // newContent = newContent.replaceAll("\n", " ");

    return GestureDetector(
      child: Container(
        constraints: BoxConstraints(maxWidth: 240.w, // 在这里指定最大宽度
        ),
        padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
        decoration: BoxDecoration(
          color: widget.isMe ? _appColorTheme.myBubbleBackgroundColor : _appColorTheme.otherSideBubbleBackgroundColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          margin: EdgeInsets.only(left: 12.w, right: 12.w),
          child: Text(
              _chatContent,
              overflow: TextOverflow.clip,
              style: (widget.isMe)?_appTextTheme.myBubbleMessageTextStyle:_appTextTheme.otherSideBubbleMessageTextStyle
          ),
        ),
      ),
      onLongPress: (){
        // if(Platform.isIOS){
        //   setState(() {
        //     convertMiao = true;
        //   });
        // }
      },
    );
  }


  /// 訊息內容 - 文字訊息 - -送出禮物框
  Widget _giftTextMessageWidget(String imagePath, String giftName, num giftSendAmount) {
    _chatContent = '[礼物]';
    return Column(
      children: [
        CachedNetworkImageUtil.load(
          HttpSetting.baseImagePath + imagePath,
          radius: 12,
          fit: BoxFit.contain,
          size: 100
        ),
        SizedBox(height: 4.h),
        Container(
            constraints: BoxConstraints(
              maxWidth: 240.w, // 在这里指定最大宽度
            ),
            // padding: EdgeInsets.only(top: 6.h, bottom: 6.h, left: 12.w, right: 12.w),
            padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
            decoration: BoxDecoration(
              color: widget.isMe
                  ? _appColorTheme.myBubbleBackgroundColor : _appColorTheme.otherSideBubbleBackgroundColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 12.w),
                  child: Text(
                    (widget.isMe) ? '送出礼物' : '收到礼物',
                    overflow: TextOverflow.clip,
                    style: (widget.isMe)?_appTextTheme.myBubbleMessageTextStyle:_appTextTheme.otherSideBubbleMessageTextStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.w, right: 12.w),
                  child: Text(
                    '${giftName}x$giftSendAmount',
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      color: (widget.isMe)
                          ? Colors.white
                          : const Color.fromRGBO(235, 94, 143, 1),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  /// 訊息內容 - 文字訊息 - -通話時間
  Widget _callTimeTextMessageWidget(Map officialMessageInfoMap) {
    String content = '';
    String icon = '';
    if(officialMessageInfoMap['chatType'] == null){
      officialMessageInfoMap = officialMessageInfoMap['content']['message'];
    }
    content  = getCallingTypeRecentlyMessage(officialMessageInfoMap['caller'], formatDuration(officialMessageInfoMap['duration']), officialMessageInfoMap['type'], officialMessageInfoMap['chatType']);
    icon  = getCallingTypeIconString(officialMessageInfoMap['type'], officialMessageInfoMap['chatType']);
    return Container(
      // padding: EdgeInsets.only(top: 6.h, bottom: 6.h, left: 12.w, right: 12.w),
      padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
      decoration: BoxDecoration(
        color: widget.isMe ?  _appColorTheme.myBubbleBackgroundColor : _appColorTheme.otherSideBubbleBackgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImgUtil.buildFromImgPath(icon, size: 24),
            // Image(
            //   width: 24.w,
            //   height: 24.w,
            //   color: Colors.cyan,
            //   // color: widget.isMe
            //   //     ? Colors.white
            //   //     : AppColors.textFormBlack,
            //   image: AssetImage(icon),
            // ),
            Container(
              margin: EdgeInsets.only(left: 4.w, right: 8.w),
              child: Text(content,
                  style: (widget.isMe)?_appTextTheme.myBubbleMessageTextStyle:_appTextTheme.otherSideBubbleMessageTextStyle),
            )
          ],
        ),
      ),
    );
  }

  /// 訊息內容 - 文字訊息 - 官方訊息
  Widget _systemTextMessageWidget(Map contentMap) {
    final messageMap = contentMap['content'];
    String content = '';
    String title ='';
    bool isShowGoSetting = false;
    Widget? targetWidget;

    if(contentMap['type'] == 3){
      // 任務紅包
      int gender = ref.read(userInfoProvider).memberInfo?.gender?.toInt() ?? 0;
      final List<String> titles = messageMap['message'].split('-')[gender].split('/');
      final String title = '${titles[0]}已完成';
      content = title;
    }else if(contentMap['type'] == 5){
      // 魅力等級
      final messages = messageMap['message'].split('\\n');
      final formattedMessage = messages.join('\n');
      content = formattedMessage;
    }else if(contentMap['type'] != 4){
      content = messageMap['message'];
    }else{
      // type:審核類型 1:頭像 2:真人 3:相册 4:招呼語(照片、語音、文字) 7:暱稱 10:聲音展示; status:1=通過,2=未通過, 3=駁回
      String reviewContent = messageMap['type'];
      int reviewContentStatus = messageMap['status'];
      String subTitle ='';
      switch(reviewContent){
        case '1':
          title = '头像审核';
          targetWidget = const PersonalEdit();
          break;
        case '2':
          title = '真人审核';
          targetWidget = const PersonalCertificationRealPerson();
          break;
        case '3':
          title = '相册审核';
          targetWidget = const PersonalEdit();
          break;
        case '4':
          title = '招呼语审核';
          targetWidget = const PersonalGreet();
          break;
        case '7':
          title = '暱称审核';
          targetWidget = const PersonalEdit();
          break;
        case "10":
          title = '声音展示审核';
          targetWidget = const PersonalEdit();
          break;
        case "11":
          title = '动态审核';
          // targetWidget = const PersonalEdit();
          break;
      }
      switch(reviewContentStatus){
        case 1:
          subTitle = '已通过';
          break;
        case 2:
          subTitle = '未通过';
          break;
        case 3:
          subTitle = '已驳回';
          break;
      }
      if(reviewContentStatus != 1){
        content = messageMap['message'];
      }else{
        content = '您的$title$subTitle';
      }
      if(reviewContentStatus == 2 ||reviewContentStatus ==3){
        isShowGoSetting = true;
      }
    }
    return Container(
      constraints: BoxConstraints(
        maxWidth: 240.w, // 在这里指定最大宽度
      ),
      padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
      decoration: BoxDecoration(
        color: _appColorTheme.otherSideBubbleBackgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            systemTitleIconAndTitle(contentMap['type'],messageMap,title,content),
            Text(
              content,
              style: _appTextTheme.otherSideBubbleMessageTextStyle,
            ),
            (isShowGoSetting && targetWidget != null)?GestureDetector(
              child: Container(
                  width: 100.w,
                  margin: EdgeInsets.only(top: 10.h, bottom: 8.h),
                  padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(48),
                    gradient: AppColors.pinkLightGradientColors,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '前往设定',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp),
                      ),
                      Image(
                        width: 20.w,
                        height: 20.w,
                        image: const AssetImage(
                            'assets/images/icon_system_arrow.png'),
                      )
                    ],
                  )),
              onTap: (){
                BaseViewModel.pushPage(
                    context,
                    targetWidget!);
              },
            ):Container(),
          ],
        ),
      ),
    );
  }

  /// 訊息內容 - 文字訊息 - 官方訊息 - 官方訊息icon、title
  Widget systemTitleIconAndTitle(int type,Map messageMap,String title,String content) {
    List<String> targetList = ['0','1','2','3'];
    switch (type) {
    //官方公告
      case 1:
        return Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                gradient: _appLinearGradientTheme.officialAnnouncementLinearGradient,
              ),
              child: Text(
                '官方',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  '公告',
                  style: _appTextTheme.systemMessageTitleTextStyle,
                )),
          ],
        );
    //新用戶獎勵提醒
      case 2:
        return Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                gradient: _appLinearGradientTheme.officialRewardsLinearGradient,
              ),
              child: Text(
                '獎勵',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  '新用户奖励提示',
                  style: _appTextTheme.systemMessageTitleTextStyle,
                )),
          ],
        );
    //任務完成
      case 3:
        final String target = messageMap['target'];
        return Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                gradient: _appLinearGradientTheme.officialMissionCompletedLinearGradient,
              ),
              child: Text(
                '任务',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  (targetList.contains(target))?'新手任务完成':'每日任务完成',
                  style: _appTextTheme.systemMessageTitleTextStyle,
                )),
          ],
        );
    //審核
      case 4:
        return Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                gradient: _appLinearGradientTheme.officialReviewLinearGradient,
              ),
              child: Text(
                '审核',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  title,
                  style: _appTextTheme.systemMessageTitleTextStyle,
                )),
          ],
        );
    //魅力等級提升
      case 5:
        return Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                gradient: _appLinearGradientTheme.officialCharmLevelIncreaseLinearGradient,
              ),
              child: Text(
                '魅力值',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  '魅力值等级提升',
                  style: _appTextTheme.systemMessageTitleTextStyle,
                )),
          ],
        );
    //舉報
      case 6:
        return Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(48),
                  gradient: _appLinearGradientTheme.officialReportLinearGradient),
              child: Text(
                '举报',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  '举报提示',
                  style: _appTextTheme.systemMessageTitleTextStyle,
                )),
          ],
        );
    //凍結
      case 7:
        return Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                gradient: _appLinearGradientTheme.officialFreezeLinearGradient,
              ),
              child: Text(
                '冻结',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  '冻结提示',
                  style: _appTextTheme.systemMessageTitleTextStyle,
                )),
          ],
        );
      default:
        return Container();
    }
  }

  /// 訊息內容 - 圖片訊息
  Widget _imageMessageWidget() {
    ZIMImageMessage? zimImageMessage = widget.zimMessage as ZIMImageMessage?;
    return (widget.isMe)
        ? _buildMyChatImg(zimImageMessage!)
        : GestureDetector(
            child: AspectRatioImage(imagePath: zimImageMessage!.fileDownloadUrl, fileType: FileType.network, fromPage: FromPage.chatroom),
            onTap: () {
              final currentImage = Image.network(zimImageMessage.fileDownloadUrl, fit: BoxFit.cover);
              _onTapPreviewImage(currentImage);
            },
          );
  }

  Widget _buildMyChatImg(ZIMImageMessage zimImageMessage) {

    bool isFromNetwork = zimImageMessage.fileDownloadUrl.contains('http');

    if (isFromNetwork) {
      return GestureDetector(
        onTap: () {
          final currentImage = Image.network(zimImageMessage.fileDownloadUrl, fit: BoxFit.cover);
          _onTapPreviewImage(currentImage);
        },
        child: AspectRatioImage(imagePath: zimImageMessage.fileDownloadUrl, fileType: FileType.network, fromPage: FromPage.chatroom),
      );
    }

    return GestureDetector(
      onTap: () {
        final Image currentImage;
        if (zimImageMessage.fileDownloadUrl.startsWith("http")) {
          currentImage = Image.network(zimImageMessage.fileDownloadUrl, fit: BoxFit.cover);
        } else {
          currentImage = Image.file(File(zimImageMessage.fileDownloadUrl));
        }
        _onTapPreviewImage(currentImage);
      },
      child: AspectRatioImage(imagePath: zimImageMessage.fileLocalPath, fileType: FileType.file, fromPage: FromPage.chatroom),
    );


    // return (!zimImageMessage.fileDownloadUrl.contains('http'))
    //     ? GestureDetector(
    //         child: Container(
    //           width: 150.w,
    //           height: 150.w,
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(12),
    //             color: Colors.black,
    //             image: DecorationImage(
    //               image: FileImage(File(zimImageMessage.fileLocalPath)),
    //               fit: BoxFit.contain,
    //             ),
    //           ),
    //         ),
    //         onTap: () {
    //           final Image currentImage;
    //           if (zimImageMessage.fileDownloadUrl.startsWith("http")) {
    //             currentImage = Image.network(zimImageMessage.fileDownloadUrl, fit: BoxFit.cover);
    //           } else {
    //             currentImage = Image.file(File(zimImageMessage.fileDownloadUrl));
    //           }
    //           _onTapPreviewImage(currentImage);
    //         },
    //       )
    //     : GestureDetector(
    //         child: CachedNetworkImageUtil.load(
    //           zimImageMessage.fileDownloadUrl,
    //           radius: 12,
    //           fit: BoxFit.contain,
    //           background: Colors.black,
    //         ),
    //         onTap: () {
    //           final currentImage = Image.network(zimImageMessage.fileDownloadUrl, fit: BoxFit.cover);
    //           _onTapPreviewImage(currentImage);
    //         },
    //       );
  }

  /// 訊息內容 - 語音訊息
  Widget _audioMessageWidget(){
    ZIMTextMessage? zimTextMessage = widget.zimMessage as ZIMTextMessage?;
    final jsonObj = json.decode(zimTextMessage?.message ?? '');
    final ReviewAudioRes reviewAudioRes = ReviewAudioRes.fromJson(jsonObj['content']['message']);
    num audioTime = reviewAudioRes.audioTime ??0;
    String audioTimeString = formatMilliseconds(audioTime.toInt());

    return Container(
      padding: EdgeInsets.only(left: 4.w, top: 4.h, bottom: 4.h, right: 12.w),
      decoration: BoxDecoration(
        color: widget.isMe ? _appColorTheme.myBubbleBackgroundColor : _appColorTheme.otherSideBubbleBackgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: (getVoiceTimeLoading)
          ? const CircularProgressIndicator()
          : Row(
        children: [
          audioPlayWidget(zimTextMessage!),
          Container(
            margin: EdgeInsets.only(left: 8.w, right: 8.h),
            child: Image(
              width: 86.w,
              height: 32.h,
              image: const AssetImage('assets/images/icon_waveform.png'),
            ),
          ),
          Text(
            audioTimeString,
            style: TextStyle(
              color: widget.isMe ? Colors.white : AppColors.textFormBlack,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );

  }

  Widget audioPlayWidget(ZIMTextMessage zimTextMessage) {
    final jsonObj = json.decode(zimTextMessage.message);
    final ReviewAudioRes reviewAudioRes = ReviewAudioRes.fromJson(jsonObj['content']['message']);
    String playImage = widget.isMe?'assets/images/icon_record_play_self.png':'assets/images/icon_record_play_opposite.png';
    String pauseImage = widget.isMe?'assets/images/icon_record_pause_self.png':'assets/images/icon_record_pause_opposite.png';
    return ValueListenableBuilder(
        valueListenable: widget.currentAudioIndexNotifier,
        builder: (_, int? newValue, __) {
          bool isOnPlay = newValue == widget.index?true:false;
         return GestureDetector(
            child: Image(
              width: 24.w,
              height: 24.h,
              image: isOnPlay ? AssetImage(pauseImage)  :  AssetImage(playImage),
            ),
            onTap: () {
              if(isOnPlay){
                widget.currentAudioIndexNotifier.value = null;
              }else{
                widget.currentAudioUrlNotifier.value = reviewAudioRes.download_url!;
                widget.currentAudioIndexNotifier.value = widget.index;
              }
            },
          );

        }
    );
  }

  /// 審核失敗提示
  Widget _failReviewHint() {

    if (widget.chatMessageStatus != ChatMessageStatus.reviewFail) {
      return const SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(right: 48.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '违反协议内容',
            style: _appTextTheme.chatMessageReviewWarningTextStyle
          )
        ],
      ),
    );
  }

  //收益組件
  Widget pointsRow() {
    return Container(
      margin: EdgeInsets.only(left: 60.w),
      child: Row(
        children: [
          const Image(
            width: 24,
            height: 24,
            image: AssetImage('assets/images/icon_points.png'),
          ),
          Text(pointsHint,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 8.sp,
                  color: AppColors.textFormBlack)),
        ],
      ),
    );
  }



  ///---未使用---
  // //喵翻譯
  // String replaceTextWithMiao(String input) {
  //   // 修改正则表达式来匹配所有的汉字字符和英文字母
  //   final regex = RegExp(r'[\u4e00-\u9fa5]|[a-zA-Z]');
  //   // 遍历输入字符串的每个字符，如果是汉字或英文字母就替换为'喵'，否则保持不变
  //   String result = input.split('').map((char) {
  //     return regex.hasMatch(char) ? '喵' : char;
  //   }).join('');
  //
  //   return result;
  // }

  //取得自己發送的消息在哪個位置
  // void getZimMessageListIsMeIndex() {
  //   String? userName = ref.read(userInfoProvider).memberInfo?.userName;
  //   myReplyIndexList = widget.viewModel.zimMessageList
  //       .asMap()
  //       .entries
  //       .where((entry) => entry.value.senderUserID == userName)
  //       .map((entry) => entry.key)
  //       .toList();
  // }

  //算女生是否可以拿到收益
  // bool showIsGetCoin(ZIMMessage zimMessage) {
  //   bool canGetCoin = false;
  //   getZimMessageListIsMeIndex();
  //   Map<String, dynamic> extendedDataMap = {};
  //   try {
  //     extendedDataMap =
  //     json.decode(zimMessage!.extendedData) as Map<String, dynamic>;
  //   } on FormatException {
  //     debugPrint('The info.extendedData is not valid JSON');
  //     return false;
  //   }
  //   if(widget.zimMessage!.type == ZIMMessageType.text){
  //     ZIMTextMessage? zimTextMessage = widget.zimMessage as ZIMTextMessage?;
  //     Map<String, dynamic> messageDataMap = {};
  //     if(!zimTextMessage!.message.contains('[礼物]')){
  //       messageDataMap = json.decode(zimTextMessage!.message) as Map<String, dynamic>;
  //       if(messageDataMap['content'].toString().contains('chatType')){
  //         Map officialMessageInfoMap = json.decode(messageDataMap['content']);
  //         if(officialMessageInfoMap['chatType'] == null){
  //           officialMessageInfoMap = officialMessageInfoMap['content']['message'];
  //         }
  //         pointsHint = '+${officialMessageInfoMap['points']}';
  //         return true;
  //       }
  //     }
  //
  //   }
  //   if (extendedDataMap['incomeflag'] != null) {
  //     num incomeflag;
  //     DateTime expireTime;
  //     DateTime halfTime;
  //     num points;
  //     incomeflag = extendedDataMap['incomeflag'];
  //     expireTime = DateTime.fromMillisecondsSinceEpoch(
  //         extendedDataMap['expireTime'] ?? 0);
  //     halfTime =
  //         DateTime.fromMillisecondsSinceEpoch(extendedDataMap['halfTime'] ?? 0);
  //     points = extendedDataMap['points'];
  //     if (incomeflag == 1) {
  //       if (myReplyIndexList.isNotEmpty) {
  //         for (int i = 0; i < myReplyIndexList.length; i++) {
  //           if (widget.index < myReplyIndexList[i]) {
  //             DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(widget
  //                 .viewModel.zimMessageList[myReplyIndexList[i]].timestamp);
  //             if (dateTime.isBefore(halfTime)) {
  //               print('在時間內回傳');
  //               canGetCoin = true;
  //               pointsHint = "+$points";
  //               break;
  //             } else if (dateTime.isBefore(expireTime)) {
  //               if(widget.zimMessage!.type == ZIMMessageType.text){
  //                 Map<String, dynamic> extendedDataMap = {};
  //                 ZIMTextMessage? zimTextMessage = widget.zimMessage as ZIMTextMessage?;
  //                 extendedDataMap = json.decode(zimTextMessage!.extendedData) as Map<String, dynamic>;
  //                 if((extendedDataMap['giftUrl'] != null)){
  //                   canGetCoin = true;
  //                   pointsHint = "+$points";
  //                 }else{
  //                   print('在半衰期時間內回傳');
  //                   points = points / 2;
  //                   canGetCoin = true;
  //                   Duration difference = dateTime.difference(expireTime);
  //                   // int minutesDifference = difference.inMinutes;
  //                   num minutesDifference = extendedDataMap['halfDuration'] ?? difference.inMinutes;
  //                   pointsHint = '您未在$minutesDifference分钟内回复信息，仅得$points 积分';
  //                   // pointsHint = '您未在时限内回复信息，仅得$points 积分';
  //                 }
  //               }else{
  //                 print('在半衰期時間內回傳');
  //                 points = points!.toInt() / 2;
  //                 canGetCoin = true;
  //                 Duration difference = dateTime.difference(expireTime);
  //                 // int minutesDifference = difference.inMinutes;
  //                 num minutesDifference = extendedDataMap['halfDuration'] ?? difference.inMinutes;
  //                 // pointsHint = '您未在$minutesDifference分钟内回复信息，仅得$points 积分';
  //                 pointsHint = '您未在时限内回复信息，仅得$points 积分';
  //               }
  //               break;
  //             } else {
  //               print('未在時間內回傳');
  //               canGetCoin = true;
  //               Duration difference = dateTime.difference(halfTime);
  //               num minutesDifference = extendedDataMap['expireDuration'] ?? difference.inMinutes;
  //               pointsHint = '您未在$minutesDifference分钟内回复信息，未获得积分';
  //               // pointsHint = '您未在时限内回复信息，未获得积分';
  //             }
  //             break;
  //           }
  //         }
  //       }
  //     } else {
  //       for (int i = 0; i < myReplyIndexList.length; i++) {
  //         if (widget.index < myReplyIndexList[i]) {
  //           DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(widget
  //               .viewModel.zimMessageList[myReplyIndexList[i]].timestamp);
  //           if (dateTime.isBefore(halfTime)) {
  //             print('在時間內回傳');
  //             canGetCoin = true;
  //             pointsHint = "+$points";
  //             break;
  //           } else if (dateTime.isBefore(expireTime)) {
  //             if(widget.zimMessage!.type == ZIMMessageType.text){
  //               Map<String, dynamic> extendedDataMap = {};
  //               ZIMTextMessage? zimTextMessage = widget.zimMessage as ZIMTextMessage?;
  //               extendedDataMap = json.decode(zimTextMessage!.extendedData) as Map<String, dynamic>;
  //               if((extendedDataMap['giftUrl'] != null)){
  //                 canGetCoin = true;
  //                 pointsHint = "+$points";
  //               }else{
  //                 print('在半衰期時間內回傳');
  //                 points = points! / 2;
  //                 canGetCoin = true;
  //                 Duration difference = dateTime.difference(expireTime);
  //                 // int minutesDifference = difference.inMinutes;
  //                 num minutesDifference = extendedDataMap['halfDuration'] ?? difference.inMinutes;
  //                 pointsHint = "+$points";
  //                 // pointsHint = '您未在时限内回复信息，仅得$points 积分';
  //               }
  //             }else{
  //               print('在半衰期時間內回傳');
  //               points = points!.toInt() / 2;
  //               canGetCoin = true;
  //               Duration difference = dateTime.difference(expireTime);
  //               // int minutesDifference = difference.inMinutes;
  //               num minutesDifference = extendedDataMap['halfDuration'] ?? difference.inMinutes;
  //               // pointsHint = '您未在$minutesDifference分钟内回复信息，仅得$points 积分';
  //               pointsHint = "+$points";
  //             }
  //             break;
  //           } else {
  //             print('未在時間內回傳');
  //             canGetCoin = true;
  //             Duration difference = dateTime.difference(halfTime);
  //             num minutesDifference = extendedDataMap['expireDuration'] ?? difference.inMinutes;
  //             pointsHint = "+$points";
  //             // pointsHint = '您未在时限内回复信息，未获得积分';
  //           }
  //           break;
  //         }
  //       }
  //     }
  //   } else {
  //     canGetCoin = false;
  //   }
  //   return canGetCoin;
  // }

  // bool _isGift() {
  //   final ZIMMessageType? type = widget.zimMessage?.type;
  //   if(type == ZIMMessageType.text) {
  //     final ZIMTextMessage zimTextMsg = widget.zimMessage as ZIMTextMessage;
  //     final Map<String, dynamic> jsonObj = json.decode(zimTextMsg.message);
  //     if(jsonObj['type'] == 3) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }


  // // 取得當前時間24小時制
  // String getTimeNow_24() {
  //   DateTime now = DateTime.now();
  //   DateFormat formatter =
  //   DateFormat.Hm(); // H: hour (00-23), m: minute (00-59)
  //   String formattedTime = formatter.format(now);
  //   return formattedTime;
  // }
}
