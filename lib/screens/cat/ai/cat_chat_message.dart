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
import 'package:frechat/system/extension/duration.dart';
import 'package:frechat/system/extension/json.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/audio_util.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/model/review_audio_res.dart';
import 'package:intl/intl.dart';


// 發送消息泡泡框
class CatChatMessage extends ConsumerStatefulWidget {
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
  final bool needReplaceTextWithMeow;

  const CatChatMessage({
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
    this.needReplaceTextWithMeow = true,
    super.key,
  });

  @override
  ConsumerState<CatChatMessage> createState() => _CatChatMessageState();
}

class _CatChatMessageState extends ConsumerState<CatChatMessage> {

  Duration? time;
  bool getVoiceTimeLoading = true;
  List<int> myReplyIndexList = [];
  String pointsHint = '';
  Map? officialMessageInfoMap;
  bool showFemalePoints = false;
  bool contentEmptyShow = true;

  @override
  void initState() {
    super.initState();
    initVoiceTime();
    getZimMessageListIsMeIndex();
    if(ref.read(userInfoProvider).memberInfo?.gender == 0 && widget.zimMessage!.type == ZIMMessageType.text && widget.isMe){
      ZIMTextMessage? zimTextMessage = widget.zimMessage as ZIMTextMessage?;
      Map<String, dynamic> messageDataMap = {};
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

  Future<void> initVoiceTime() async {
    if(!_isAudio()) {
      return;
    }

    ZIMTextMessage? zimTextMessage = widget.zimMessage as ZIMTextMessage?;
    final jsonObj = json.decode(zimTextMessage?.message ?? '');
    final ReviewAudioRes reviewAudioRes = ReviewAudioRes.fromJson(jsonObj['content']['message']);

    time = await AudioUtils.getAudioTime(
        audioUrl: reviewAudioRes.download_url ?? '',
        addBaseImagePath: false
    );

    getVoiceTimeLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool showGetCoin = false;
    if (ref.read(userInfoProvider).memberInfo!.gender == 0) {
      if(showFemalePoints == false && !widget.isMe){
        showGetCoin = showIsGetCoin(widget.zimMessage!);
      }

    }
    return (!contentEmptyShow && !widget.isMe)?Container():Column(
      children: [
        (widget.showTimeDistinction)?Padding(padding: EdgeInsets.symmetric(vertical: 8.h),child: Text(formatDateTime(DateTime.fromMillisecondsSinceEpoch(
            widget.zimMessage!.timestamp)),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 10.sp,color:  const Color.fromRGBO(204, 204, 204, 1)))):Container(),
        Container(
          margin: widget.isMe
              ? EdgeInsets.only(right: 8.w, top: 4.h)
              : EdgeInsets.only(top: 4.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              //頭像
              avatarWidget(),
              //自己的時間戳
              (widget.isMe)
                  ? Container(
                      margin: EdgeInsets.only(right: 4.w),
                      child: timeAndReadWidget(),
                    )
                  : Container(),
              _isText()
                  ? textMessageWidget()
                  : Container(),
              (widget.zimMessage!.type == ZIMMessageType.image)
                  ? imageMessageWidget()
                  : Container(),
              _isAudio()
                  ? audioMessageWidget()
                  : Container(),
              //對方的時間戳
              (widget.isMe)
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(left: 4.w),
                      child: timeAndReadWidget(),
                    )
            ],
          ),
        ),
        (showFemalePoints)? Padding(padding: EdgeInsets.only(right: 20.w),child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Image(
            width: 24.w,
            height: 24.w,
            image: AssetImage('assets/images/icon_points.png'),
          ), Text(pointsHint,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 8.sp,
                  color: const Color.fromRGBO(68, 70, 72, 1)))],
        )):Container(),
        (showGetCoin && !widget.isMe) ? (widget.searchListInfo?.userName == 'java_system')?Container():pointsRow() : Container()
      ],
    );
  }

  bool _isAudio() {
    try {
      final ZIMMessageType? type = widget.zimMessage?.type;
      if(type == ZIMMessageType.text) {
        final ZIMTextMessage zimTextMsg = widget.zimMessage as ZIMTextMessage;
        final Map<String, dynamic> jsonObj = json.decode(zimTextMsg.message);
        if(jsonObj['type'] == 9) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  bool _isText() {
    final ZIMMessageType? type = widget.zimMessage?.type;
    if(type == ZIMMessageType.text) {
      final ZIMTextMessage zimTextMsg = widget.zimMessage as ZIMTextMessage;
      if(zimTextMsg.message.contains('[礼物]')) {
        return true;
      }
      final Map<String, dynamic> jsonObj = json.decode(zimTextMsg.message);
      if(jsonObj['type'] == 0) {
        return true;
      }
    }
    return false;
  }

  bool _isGift() {
    final ZIMMessageType? type = widget.zimMessage?.type;
    if(type == ZIMMessageType.text) {
      final ZIMTextMessage zimTextMsg = widget.zimMessage as ZIMTextMessage;
      final Map<String, dynamic> jsonObj = json.decode(zimTextMsg.message);
      if(jsonObj['type'] == 3) {
        return true;
      }
    }
    return false;
  }

  //頭像(自己不顯示)
  Widget avatarWidget() {
    // final bool avatarIsEmpty = (widget.memberInfo?.avatarPath == null || widget.memberInfo?.avatarPath == '');
    // final num avatarAuth = widget.memberInfo?.avatarAuth ?? 0;
    // final CertificationType avatarType = CertificationModel.getType(authNum: avatarAuth);
    // final num gender = widget.memberInfo?.gender ?? 0;
    //
    // return (widget.isMe)
    //     ? Container()
    //     : (widget.searchListInfo!.userName == 'java_system')
    //         ? Container(
    //             margin: EdgeInsets.only(left: 8.w, right: 8.w),
    //             width: 32.w,
    //             height: 32.h,
    //             decoration: const BoxDecoration(shape: BoxShape.circle),
    //             child: (widget.avatar.isNotEmpty)
    //                 ? AvatarUtil.localAvatar('assets/avatar/system_avatar.png', size: 32.w)
    //                 : AvatarUtil.defaultAvatar(gender == 1 ? 0 : 1, size: 32.w)
    //           )
    //         : GestureDetector(
    //             child: (avatarIsEmpty == false && avatarType == CertificationType.done)
    //               ? Padding(padding: EdgeInsets.only(left: 8.w, right: 8.w),child: AvatarUtil.userAvatar(HttpSetting.baseImagePath + widget.avatar, size: 32.w))
    //               : Padding(padding: EdgeInsets.only(left: 8.w, right: 8.w),child: AvatarUtil.defaultAvatar(gender, size: 32.w)),
    //             onTap: () {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (context) => UserInfoView(
    //                     memberInfo: widget.memberInfo,
    //                     searchListInfo: widget.searchListInfo,
    //                     //forProfile: false,
    //                     displayMode: DisplayMode.chatMessage,
    //                   ),
    //                 ),
    //               );
    //             },
    //           );

    return (widget.isMe)?Container(): InkWell(
      child: Container(
          margin: EdgeInsets.only(left: 13.w,right: 11.w),
          width: 34.w,
          height: 34.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/image_cat_container.png')
              )
          ),
          child: Align(
              alignment: Alignment.center,
              child: roomAvatarWidget(widget.searchListInfo?.roomIcon ?? '')
          )
      ),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserInfoView(
                memberInfo: widget.memberInfo,
                searchListInfo: widget.searchListInfo,
                //forProfile: false,
                displayMode: DisplayMode.chatMessage)),
        );
      },
    );



    // return (widget.isMe)?Container():Padding(padding: EdgeInsets.only(left: 13.w,right: 11.w),
    //     child: InkWell(
    //       child: Image(
    //         width: 34.w,
    //         height: 34.w,
    //         image:
    //         const AssetImage('assets/images/image_cat_container.png'),
    //       ),
    //       onTap: (){
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => UserInfoView(
    //                 memberInfo: widget.memberInfo,
    //                 searchListInfo: widget.searchListInfo,
    //                 //forProfile: false,
    //                 displayMode: DisplayMode.chatMessage,)),
    //         );
    //       },
    //     ));
  }

  Widget roomAvatarWidget(String avatar){
    final num gender = ref.read(userInfoProvider).memberInfo?.gender == 0 ? 1 : 0;
    return (avatar != '')
        ? AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatar, size: 25.w,radius: 12)
        : AvatarUtil.defaultAvatar(gender, size: 25.w,radius: 12);
  }


  // //預設男女大頭貼
  // Widget maleOrFemaleAvatarWidget() {
  //   String imagePath = 'assets/images/default_male_avatar.png';
  //   num? gender = ref.read(userInfoProvider).memberInfo!.gender;
  //   if (gender == 1) {
  //     imagePath = 'assets/images/default_female_avatar.png';
  //   }
  //   return CircleAvatar(
  //     backgroundImage: AssetImage(imagePath),
  //   );
  // }

  //時間戳和已讀
  Widget timeAndReadWidget() {
    return Column(
      crossAxisAlignment:
          (widget.isMe) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          (!widget.isMe)
              ? ''
              : (widget.zimMessage!.receiptStatus ==
                      ZIMMessageReceiptStatus.done)
                  ? '已读'
                  : '',
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey,
          ),
        ),
        Text(
          transferTimeStamp(widget.zimMessage!.timestamp),
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey,
          ),
        )
      ],
    );
  }

  // 取得當前時間24小時制
  String getTimeNow_24() {
    DateTime now = DateTime.now();
    DateFormat formatter =
        DateFormat.Hm(); // H: hour (00-23), m: minute (00-59)
    String formattedTime = formatter.format(now);
    return formattedTime;
  }

  //文字訊息
  Widget textMessageWidget() {
    String content = '';
    ZIMTextMessage? zimTextMessage = widget.zimMessage as ZIMTextMessage?;
    Map<String, dynamic> messageDataMap = {};
    Map<String, dynamic> extendedDataMap = {};
    if (zimTextMessage!.message.toString().isNotEmpty && !zimTextMessage!.message.contains('[礼物]')) {
      messageDataMap = json.decode(zimTextMessage!.message) as Map<String, dynamic>;
    }
    extendedDataMap = json.decode(zimTextMessage!.extendedData) as Map<String, dynamic>;
    try {
      if (extendedDataMap['giftUrl'] != null) {
        return GiftBubbleWidet(extendedDataMap['giftUrl'], extendedDataMap['giftName'], extendedDataMap['giftSendAmount']);
      } else if (messageDataMap['content'].toString().contains('chatType')) {
        officialMessageInfoMap = json.decode(messageDataMap['content']);
        Map<String, dynamic> m =json.decode(zimTextMessage.message);
        String c = m['content'];
        return callTimeWidget(officialMessageInfoMap!);
      } else {
        if (widget.searchListInfo!=null && widget.searchListInfo!.userName == 'java_system') {
          final contentMap = json.decode(messageDataMap['content']);
          return systemMessageWidget(contentMap);
        } else {
          messageDataMap = json.decode(zimTextMessage.message);
          content = messageDataMap['content'];
        }
      }
    } on FormatException {
      debugPrint('The info.extendedData is not valid JSON');
    }
    if (messageDataMap.isEmpty) {
      content = zimTextMessage.message;
    }
    if(content.isEmpty){
      contentEmptyShow = false;
      setState(() {});
    }
    return (content.isEmpty)?Container():Container(
      constraints: BoxConstraints(
        maxWidth: 240.w, // 在这里指定最大宽度
      ),
      // padding: EdgeInsets.only(top: 6.h, bottom: 6.h, left: 12.w, right: 12.w),
      padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
      decoration: BoxDecoration(
        color: widget.isMe ? const Color.fromRGBO(217,206,193, 1) : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: textContent(content),
    );
  }

  // 文字內容
  Widget textContent(String content) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 12.w, right: 12.w),
        child: Text(
          (widget.isMe && widget.needReplaceTextWithMeow)?replaceTextWithMeow(content):content,
          overflow: TextOverflow.clip,
          style: TextStyle(
            fontSize: 16.0.sp,
            color: const Color.fromRGBO(79,33,21, 1),
          ),
        ),
      ),
      onTap: (){
        BaseViewModel.showToast(context, '翻译: '+content);
      },
    );
  }

  String replaceTextWithMeow(String input) {
    return input.replaceAllMapped(
      RegExp(r'[\u4e00-\u9fa5a-zA-Z]'),
          (match) {
        return '喵';
      },
    );
  }


  //圖片訊息
  Widget imageMessageWidget() {
    ZIMImageMessage? zimImageMessage = widget.zimMessage as ZIMImageMessage?;
    return (widget.isMe)
        ? _buildMyChatImg(zimImageMessage!)
        : GestureDetector(
            child: Container(
              width: 150.w,
              height: 150.w,
              child: CachedNetworkImageUtil.load(
                  zimImageMessage!.fileDownloadUrl,
                  radius: 20),
            ),
            onTap: () {
              final currentImage = Image.network(
                  zimImageMessage.fileDownloadUrl,
                  fit: BoxFit.cover);
              previewImage(currentImage);
            },
          );
  }

  _buildMyChatImg(ZIMImageMessage zimImageMessage) {
    return (!zimImageMessage.fileDownloadUrl.contains('http'))
        ? GestureDetector(
            child: Container(
              width: 150.w,
              height: 150.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: FileImage(File(zimImageMessage.fileLocalPath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: () {
              final Image currentImage;
              if (zimImageMessage.fileDownloadUrl.startsWith("http")) {
                currentImage = Image.network(zimImageMessage.fileDownloadUrl,
                    fit: BoxFit.cover);
              } else {
                currentImage =
                    Image.file(File(zimImageMessage.fileDownloadUrl));
              }
              previewImage(currentImage);
            },
          )
        : GestureDetector(
            child: Container(
                width: 150.w,
                height: 150.w,
                child: CachedNetworkImageUtil.load(
                    zimImageMessage.fileDownloadUrl,
                    radius: 20)),
            onTap: () {
              final currentImage = Image.network(
                  zimImageMessage.fileDownloadUrl,
                  fit: BoxFit.cover);
              previewImage(currentImage);
            },
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
                  color: const Color.fromRGBO(68, 70, 72, 1))),
        ],
      ),
    );
  }

  //通話時間
  Widget callTimeWidget(Map officialMessageInfoMap) {
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
        color: widget.isMe ? const Color.fromRGBO(235, 94, 143, 1) : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              width: 24.w,
              height: 24.w,
              color: widget.isMe
                  ? Colors.white
                  : const Color.fromRGBO(68, 70, 72, 1),
              image: AssetImage(icon),
            ),
            Container(
              margin: EdgeInsets.only(left: 4.w, right: 8.w),
              child: Text(content,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: widget.isMe
                          ? Colors.white
                          : const Color.fromRGBO(68, 70, 72, 1),
                      fontWeight: FontWeight.w400)),
            )
          ],
        ),
      ),
    );
  }

  //官方訊息
  Widget systemMessageWidget(Map contentMap) {
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
        color: Colors.white,
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
              style: TextStyle(
                  color: const Color.fromRGBO(68, 70, 72, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp),
            ),
            (isShowGoSetting)?GestureDetector(
              child: Container(
                  width: 100.w,
                  margin: EdgeInsets.only(top: 10.h, bottom: 8.h),
                  padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(48),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(235, 93, 142, 1),
                        Color.fromRGBO(240, 138, 191, 1)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
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

  //官方訊息icon、title
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
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(100, 125, 246, 1),
                    Color.fromRGBO(89, 187, 224, 1)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
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
                  style: TextStyle(
                      color: const Color.fromRGBO(68, 70, 72, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp),
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
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(92, 193, 138, 1),
                    Color.fromRGBO(150, 254, 198, 1)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
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
                  style: TextStyle(
                      color: const Color.fromRGBO(68, 70, 72, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp),
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
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(245, 195, 112, 1),
                    Color.fromRGBO(238, 129, 59, 1)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
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
                  style: TextStyle(
                      color: const Color.fromRGBO(68, 70, 72, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp),
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
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(235, 93, 142, 1),
                    Color.fromRGBO(240, 138, 191, 1)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
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
                  style: TextStyle(
                      color: const Color.fromRGBO(68, 70, 72, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp),
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
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(205, 157, 251, 1),
                    Color.fromRGBO(55, 175, 243, 1)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
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
                  style: TextStyle(
                      color: const Color.fromRGBO(68, 70, 72, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp),
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
                  color: const Color.fromRGBO(68, 70, 72, 1),
                  borderRadius: BorderRadius.circular(48)),
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
                  style: TextStyle(
                      color: const Color.fromRGBO(68, 70, 72, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp),
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
                  color: const Color.fromRGBO(0,40,87, 1),
                  borderRadius: BorderRadius.circular(48)),
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
                  style: TextStyle(
                      color: const Color.fromRGBO(68, 70, 72, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp),
                )),
          ],
        );
      default:
        return Container();
    }
  }

  // 語音訊息框
  Widget audioMessageWidget(){
    ZIMTextMessage? zimTextMessage = widget.zimMessage as ZIMTextMessage?;
    final jsonObj = json.decode(zimTextMessage?.message ?? '');
    final ReviewAudioRes reviewAudioRes = ReviewAudioRes.fromJson(jsonObj['content']['message']);
    return Visibility(
      visible: reviewAudioRes.reviewResult == true,
      child: Container(
        padding: EdgeInsets.only(left: 4.w, top: 4.h, bottom: 4.h, right: 12.w),
        decoration: BoxDecoration(
          color: widget.isMe ? const Color.fromRGBO(235, 94, 143, 1) : Colors.white,
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
              '${time?.toFormat()}',
              style: TextStyle(
                color: widget.isMe ? Colors.white : const Color.fromRGBO(68, 70, 72, 1),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget audioPlayWidget(ZIMTextMessage zimTextMessage) {
    final jsonObj = json.decode(zimTextMessage.message);
    final ReviewAudioRes reviewAudioRes = ReviewAudioRes.fromJson(jsonObj['content']['message']);
    return ValueListenableBuilder(
        valueListenable: widget.currentAudioIndexNotifier,
        builder: (_, int? newValue, __) {
          return (newValue == widget.index) ? GestureDetector(
            child: Image(
              width: 24.w,
              height: 24.h,
              image: widget.isMe
                  ? const AssetImage('assets/images/icon_record_pause_self.png')
                  : const AssetImage('assets/images/icon_record_pause_opposite.png'),
            ),
            onTap: () {
              widget.currentAudioIndexNotifier.value = null;
            },
          ) : GestureDetector(
            child: Image(
              width: 24.w,
              height: 24.h,
              image: widget.isMe
                  ? const AssetImage('assets/images/icon_record_play_self.png')
                  : const AssetImage('assets/images/icon_record_play_opposite.png'),
            ),
            onTap: () {
              widget.currentAudioUrlNotifier.value = reviewAudioRes.download_url!;
              widget.currentAudioIndexNotifier.value = widget.index;
            },
          );
        }
    );
  }

  //預覽圖片
  void previewImage(Image currentImage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreen(
          image: currentImage,
        ),
      ), //
    );
  }

  //送出禮物框
  Widget GiftBubbleWidet(
      String imagePath, String giftName, num giftSendAmount) {
    return Column(
      children: [
        SizedBox(
          width: 100.w,
          height: 100.w,
          child: CachedNetworkImageUtil.load(
              HttpSetting.baseImagePath + imagePath),
        ),
        Container(
            constraints: BoxConstraints(
              maxWidth: 240.w, // 在这里指定最大宽度
            ),
            // padding: EdgeInsets.only(top: 6.h, bottom: 6.h, left: 12.w, right: 12.w),
            padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
            decoration: BoxDecoration(
              color: widget.isMe
                  ? const Color.fromRGBO(235, 94, 143, 1)
                  : Colors.white,
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
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      color: (widget.isMe)
                          ? Colors.white
                          : const Color.fromRGBO(68, 70, 72, 1),
                    ),
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

  //取得自己發送的消息在哪個位置
  void getZimMessageListIsMeIndex() {
    String? userName = ref.read(userInfoProvider).memberInfo?.userName;
    myReplyIndexList = widget.viewModel.zimMessageList
        .asMap()
        .entries
        .where((entry) => entry.value.senderUserID == userName)
        .map((entry) => entry.key)
        .toList();
  }

  //算女生是否可以拿到收益
  bool showIsGetCoin(ZIMMessage zimMessage) {
    bool canGetCoin = false;
    getZimMessageListIsMeIndex();
    Map<String, dynamic> extendedDataMap = {};
    try {
      extendedDataMap =
          json.decode(zimMessage!.extendedData) as Map<String, dynamic>;
    } on FormatException {
      debugPrint('The info.extendedData is not valid JSON');
      return false;
    }
    if(widget.zimMessage!.type == ZIMMessageType.text){
      ZIMTextMessage? zimTextMessage = widget.zimMessage as ZIMTextMessage?;
      Map<String, dynamic> messageDataMap = {};
      if(!zimTextMessage!.message.contains('[礼物]')){
        messageDataMap = json.decode(zimTextMessage!.message) as Map<String, dynamic>;
        if(messageDataMap['content'].toString().contains('chatType')){
          Map officialMessageInfoMap = json.decode(messageDataMap['content']);
          if(officialMessageInfoMap['chatType'] == null){
            officialMessageInfoMap = officialMessageInfoMap['content']['message'];
          }
          pointsHint = '+${officialMessageInfoMap['points']}';
          return true;
        }
      }

    }
    if (extendedDataMap['incomeflag'] != null) {
      num incomeflag;
      DateTime expireTime;
      DateTime halfTime;
      num points;
      incomeflag = extendedDataMap['incomeflag'];
      expireTime = DateTime.fromMillisecondsSinceEpoch(
          extendedDataMap['expireTime'] ?? 0);
      halfTime =
          DateTime.fromMillisecondsSinceEpoch(extendedDataMap['halfTime'] ?? 0);
      points = extendedDataMap['points'];
      if (incomeflag == 1) {
        if (myReplyIndexList.isNotEmpty) {
          for (int i = 0; i < myReplyIndexList.length; i++) {
            if (widget.index < myReplyIndexList[i]) {
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(widget
                  .viewModel.zimMessageList[myReplyIndexList[i]].timestamp);
              if (dateTime.isBefore(halfTime)) {
                print('在時間內回傳');
                canGetCoin = true;
                pointsHint = "+$points";
                break;
              } else if (dateTime.isBefore(expireTime)) {
                if(widget.zimMessage!.type == ZIMMessageType.text){
                  Map<String, dynamic> extendedDataMap = {};
                  ZIMTextMessage? zimTextMessage = widget.zimMessage as ZIMTextMessage?;
                  extendedDataMap = json.decode(zimTextMessage!.extendedData) as Map<String, dynamic>;
                  if((extendedDataMap['giftUrl'] != null)){
                    canGetCoin = true;
                    pointsHint = "+$points";
                  }else{
                    print('在半衰期時間內回傳');
                    points = points! / 2;
                    canGetCoin = true;
                    Duration difference = dateTime.difference(expireTime);
                    // int minutesDifference = difference.inMinutes;
                    int minutesDifference = extendedDataMap['halfDuration'] ?? difference.inMinutes;
                    pointsHint = '您未在$minutesDifference分钟内回复信息，仅得$points 积分';
                    // pointsHint = '您未在时限内回复信息，仅得$points 积分';
                  }
                }else{
                  print('在半衰期時間內回傳');
                  points = points!.toInt() / 2;
                  canGetCoin = true;
                  Duration difference = dateTime.difference(expireTime);
                  // int minutesDifference = difference.inMinutes;
                  int minutesDifference = extendedDataMap['halfDuration'] ?? difference.inMinutes;
                  // pointsHint = '您未在$minutesDifference分钟内回复信息，仅得$points 积分';
                  pointsHint = '您未在时限内回复信息，仅得$points 积分';
                }
                break;
              } else {
                print('未在時間內回傳');
                canGetCoin = true;
                Duration difference = dateTime.difference(halfTime);
                int minutesDifference = extendedDataMap['expireDuration'] ?? difference.inMinutes;
                pointsHint = '您未在$minutesDifference分钟内回复信息，未获得积分';
                // pointsHint = '您未在时限内回复信息，未获得积分';
              }
              break;
            }
          }
        }
      } else {
        pointsHint = "+$points";
        canGetCoin = true;
      }
    } else {
      canGetCoin = false;
    }
    return canGetCoin;
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
          msg = '语音通话:'+duration;
        }else{
          msg = '视频通话:'+duration;
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
          icon = 'assets/images/icon_calltime.png';
        }else{
          icon = 'assets/images/icon_videotime.png';
        }
        break;
      case 1:
        if(chatType == 1 || chatType == 7){
          icon = 'assets/images/icon_cancel_call.png';
        }else{
          icon =  'assets/images/icon_cancel_viedo.png';
        }
        break;
      case 2:
        if(chatType == 1 || chatType == 7){
          icon = 'assets/images/icon_cancel_call.png';
        }else{
          icon =  'assets/images/icon_cancel_viedo.png';
        }
        break;
      default:
        break;
    }

    return icon;
  }
}
