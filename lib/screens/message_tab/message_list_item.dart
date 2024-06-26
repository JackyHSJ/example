import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frechat/models/ws_req/account/ws_account_remark_req.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/provider/chat_message_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/avatar_icon_util.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/widgets/shared/bottom_sheet/common_bottom_sheet.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

////消息頁籤單行組件

class MessageListItem extends ConsumerStatefulWidget {

  final SearchListInfo? searchListInfo;
  final String? recentlyMessage;
  final int timeStamp;
  final int? unRead;
  final bool? isSystem;
  final num? isPinTop;
  final num? points;
  final num sendStatus;

  const MessageListItem({
    super.key,
    this.recentlyMessage,
    required this.timeStamp,
    this.unRead,
    this.searchListInfo,
    this.isPinTop,
    this.isSystem,
    this.points,
    required this.sendStatus,
  });

  @override
  ConsumerState<MessageListItem> createState() => _MessageListItemTabState();
}

class _MessageListItemTabState extends ConsumerState<MessageListItem> {
  TextEditingController textEditingController = TextEditingController();
  String _roomName = '';
  SearchListInfo? searchListInfo;

  // 審核開關
  bool showIntimacyType = false; // 3. 亲密度

  late AppTheme _theme;
  late AppColorTheme appColorTheme;
  late AppTextTheme appTextTheme;
  late AppLinearGradientTheme appLinearGradientTheme;
  late AppImageTheme appImageTheme;

  @override
  void initState() {
    super.initState();
    showIntimacyType = ref.read(userInfoProvider).buttonConfigList?.intimacyType == 1 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    searchListInfo = widget.searchListInfo;
    _roomName = searchListInfo?.roomName??'';
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = _theme.getAppColorTheme;
    appTextTheme = _theme.getAppTextTheme;
    appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    appImageTheme = _theme.getAppImageTheme;
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(top: 8.h, bottom: 8.h, right: 16.w, left: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    //聊天室消息頭像
                    roomAvatarWidget(),
                    //未讀數量
                    unReadWidget(),
                    //是否上線
                    AvatarIconUtil.onlineIconWidget(widget.searchListInfo?.isOnline ?? 0),
                    //是否置頂
                    AvatarIconUtil.pinTopWidget(widget.isPinTop ?? 0, appImageTheme.iconPinTop)
                  ],
                ),
                //聊天室名稱和最近消息
                roomNameAndRecentlyMessage(),
              ],
            ),
            //時間戳和亲密度

            timeStampAndPointsWidget(),
          ],
        ),
      ),
      onTap: () => BaseViewModel.pushPage(context, ChatRoom(
        searchListInfo: searchListInfo,
        unRead:widget.unRead,
        isSystem: widget.isSystem,
      )),
      onLongPress: () {

        // java_system 不會有作用
        if (searchListInfo?.userName == "java_system") return;

        bottomSheet();
      },
    );
  }

  //聊天室頭像
  Widget roomAvatarWidget(){
    if(widget.searchListInfo!.userName == 'java_system'){
      return AvatarUtil.localAvatar(appImageTheme.javaSystemIcon, size: 64.w);
    } else {
      final String avatar = widget.searchListInfo?.roomIcon ?? '';
      final num gender = ref.read(userInfoProvider).memberInfo?.gender == 0 ? 1 : 0;
      return (avatar != '')
        ? AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatar, size: 64.w)
        : AvatarUtil.defaultAvatar(gender, size: 64.w);
    }
  }

  //未讀數量
  Widget unReadWidget(){
    return  (widget.unRead != 0 && widget.unRead!=null)?Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: appLinearGradientTheme.unReadBackGroundColor,
          ),
          child: Center(
            child: Text(
              widget.unRead!.toString(),
              style: const TextStyle(
                  fontSize: 10, color: Colors.white, height: 1),
            ),
          ),
        )):Container();
  }

  //是否在線
  // Widget isOnlineWidget(){
  //   return (widget.searchListInfo!.isOnline == 1)
  //       ? Positioned(
  //       bottom: 0,
  //       right: 0,
  //       child: Container(
  //         width: 8,
  //         height: 8,
  //         decoration: const BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: Color.fromRGBO(146, 209, 72, 1),
  //         ),
  //       ))
  //       : Container();
  // }

  //是否置頂
  // Widget isPinTopWidget(){
  //   return (widget.isPinTop == 1)
  //       ? Positioned(
  //       bottom: 0,
  //       left: 0,
  //       child: Image(
  //         width: 16.w,
  //         height: 16.w,
  //         image: const AssetImage('assets/images/icon_pin_top.png'),
  //       ))
  //       : Container();
  // }

  //聊天室名稱、最近訊息
  Widget roomNameAndRecentlyMessage() {

    final String userName = widget.searchListInfo?.userName ?? '';
    final String roomName = widget.searchListInfo?.roomName ?? '';
    final String remarkName = widget.searchListInfo?.remark ?? '';
    final String displayName = ConvertUtil.displayName(userName, roomName, remarkName);
    final String recentlyMessage = widget.recentlyMessage ?? '';

    return Container(
      margin: const EdgeInsets.only(left: 10),
      width: 190.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(displayName, style: appTextTheme.messageTabItemRoomNameTextStyle,),
              messageSendStatus(),
            ],
          ),
          Container(
            width: 260.w,
            margin: const EdgeInsets.only(top: 4),
            child: Text(
              recentlyMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appTextTheme.messageTabItemRecentlyMessageTextStyle
            ),
          )
        ],
      ),
    );
  }
  // 訊息傳送狀態（顯示傳送失敗提醒）
  Widget messageSendStatus(){
    return Visibility(
      visible: widget.sendStatus == 2,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        child: ImgUtil.buildFromImgPath(appImageTheme.iconChatMessageError,
            size: 15),
      ),
    );
  }
  // 時間戳和亲密度
  Widget timeStampAndPointsWidget() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          (widget.timeStamp != 0)
              ? Text(
                  formatDateTime(
                      DateTime.fromMillisecondsSinceEpoch(widget.timeStamp)),
                  style: appTextTheme.messageTabItemTimeStampTextStyle,
                )
              : Container(),

          Visibility(
            visible: (widget.timeStamp != 0 && widget.points != 0 && showIntimacyType),
            child: const SizedBox(height: 5),
          ),
          (widget.points != 0 && showIntimacyType)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        double.parse(widget.points!.toStringAsFixed(1))
                            .toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: getIntimacyLevelColor(widget.points!),
                            height: 1),
                      ),
                    )),
                    iconHeartWidget(widget.points ?? 0)
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  //時間格式
  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime beginningOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = beginningOfWeek.add(const Duration(days: 6));

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      // 同一天
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
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

  void bottomSheet() {
    final allChatUserModelList = ref.read(chatUserModelNotifierProvider);
    final list = allChatUserModelList.where((info) => info.userName == widget.searchListInfo!.userName).toList();
    ChatUserModel chatUserModel = list[0];
    CommonBottomSheet.show(
      context,
      actions: [
        CommonBottomSheetAction(
          title: '修改备注名',
          titleStyle: TextStyle(fontSize: 16, color: appColorTheme.intimacyRuleContentTitleTextColor, fontWeight: FontWeight.w400),
          onTap: () async{
            Navigator.pop(context);
            await _editName();
          },
        ),
        CommonBottomSheetAction(
          title: (chatUserModel.pinTop==0)?'置顶聊天':'取消置顶',
          titleStyle: TextStyle(fontSize: 16, color: appColorTheme.intimacyRuleContentTitleTextColor, fontWeight: FontWeight.w400),
          onTap: () {
            if(chatUserModel.pinTop == 0){
              final chatUserModelList = ref.read(chatUserModelNotifierProvider);
              final list = chatUserModelList!.where((info) => info.pinTop == 1).toList();
              if(list.length == 10){
                BaseViewModel.showToast(context, '置顶消息数量已达上限，请取消置顶后继续添加');
              }else{
                ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList:[
                  ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
                      isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points,
                      remark: chatUserModel.remark, unRead: chatUserModel.unRead, recentlyMessage:chatUserModel.recentlyMessage, timeStamp: chatUserModel.timeStamp, pinTop:  (chatUserModel.pinTop==0)?1:0, sendStatus: chatUserModel.sendStatus,
                  )
                ]);
                BaseViewModel.showToast(context, (chatUserModel.pinTop==0)?'已置顶消息':'已取消置顶');
              }
            }else{
              ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList:[
                ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
                    isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points,
                    remark: chatUserModel.remark, unRead: chatUserModel.unRead, recentlyMessage:chatUserModel.recentlyMessage, timeStamp: chatUserModel.timeStamp, pinTop:  (chatUserModel.pinTop==0)?1:0,
                  sendStatus: chatUserModel.sendStatus
                ),
              ]);
              BaseViewModel.showToast(context, (chatUserModel.pinTop==0)?'已置顶消息':'已取消置顶');
            }
            Navigator.pop(context);
          },
        ),
        CommonBottomSheetAction(
          title: '删除聊天',
          titleStyle: TextStyle(fontSize: 16, color:  appColorTheme.commonButtonDeleteTextColor, fontWeight: FontWeight.w400),
          onTap: () async {

            final String userName = widget.searchListInfo?.userName ?? '';
            final String roomName = widget.searchListInfo?.roomName ?? '';
            final String remarkName = widget.searchListInfo?.remark ?? '';
            final String displayName = ConvertUtil.displayName(userName, roomName, remarkName);

            if (context.mounted) {

              CommDialog(context).build(
                theme: _theme,
                backgroundColor: appColorTheme.dialogBackgroundColor,
                leftLinearGradient: appLinearGradientTheme.buttonSecondaryColor,
                rightLinearGradient: appLinearGradientTheme.buttonPrimaryColor,
                leftTextStyle: appTextTheme.buttonSecondaryTextStyle,
                rightTextStyle: appTextTheme.buttonPrimaryTextStyle,
                title: '删除聊天',
                contentDes: '确定删除 $displayName 的聊天纪录？\n删除后数据无法恢复，请谨慎操作',
                leftBtnTitle: '取消',
                rightBtnTitle: '确定',
                leftAction: () {
                  BaseViewModel.popPage(context);
                },
                rightAction: () {
                  //Todo: Jerry's work.
                  ///清除極構歷史資料
                  final zimService = ref.read(zimServiceProvider);
                  zimService.deleteMessage(conversationID: widget.searchListInfo!.userName!);
                  ///將此人從消息列表清除
                  final userModel = ref.read(chatUserModelNotifierProvider);
                  final list = userModel.where((info) => info.userName ==  widget.searchListInfo!.userName!).toList();
                  ChatUserModel chatUserModel = list[0];
                  ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
                    ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
                        isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points,
                        remark: chatUserModel.remark, unRead: 0, recentlyMessage: '', timeStamp: chatUserModel.timeStamp, pinTop: chatUserModel.pinTop,sendStatus: 1)]);
                  ///將此人訊息删除
                  final allChatMessageModelList = ref.watch(chatMessageModelNotifierProvider);
                  final mySendChatMessagelist = allChatMessageModelList.where((info) => info.senderName == ref.read(userInfoProvider).memberInfo?.userName && info.receiverName == widget.searchListInfo!.userName!).toList();
                  final oppoSiteSendChatMessagelist = allChatMessageModelList.where((info) => info.senderName == widget.searchListInfo!.userName && info.receiverName == ref.read(userInfoProvider).memberInfo?.userName).toList();
                  List<ChatMessageModel> mergedList = [...mySendChatMessagelist, ...oppoSiteSendChatMessagelist];
                  if(mergedList.isNotEmpty){
                    for(int i =0;i<mergedList.length;i++){
                      ref.read(chatMessageModelNotifierProvider.notifier).clearSql(whereModel: mergedList[i]);
                    }
                  }
                  BaseViewModel.popPage(context);
                  BaseViewModel.popPage(context);
                }
              );
            }
          },
        ),
      ],
    );
  }

  //預設男女生頭像
  // Widget maleOrFemaleAvatarWidget() {
  //   String imagePath = 'assets/images/default_male_avatar.png';
  //   if (ref.read(userInfoProvider).memberInfo!.gender == 1) {
  //     imagePath = 'assets/images/default_female_avatar.png';
  //   }
  //   return CircleAvatar(
  //     backgroundImage: AssetImage(imagePath),
  //   );
  // }

  //亲密值愛心圖
  Widget iconHeartWidget(num points) {
    Color color = getIntimacyLevelColor(points);
    return Container(
      margin: const EdgeInsets.only(left: 2),
      child: Image(
        color: color,
        width: 12.w,
        height: 12.w,
        image: const AssetImage('assets/images/icon_heart.png'),
      ),
    );
  }

  Color getIntimacyLevelColor(num points){
    final WsNotificationSearchIntimacyLevelInfoRes? intimacyLevelInfo = ref.read(userInfoProvider).notificationSearchIntimacyLevelInfo;
    List<IntimacyLevelInfo> intimacyLevelList = intimacyLevelInfo!.list!;
    intimacyLevelList.sort((a, b) => a.cohesionLevel!.compareTo(b.cohesionLevel!));
    List<num?> pointsList = intimacyLevelList.map((info) => info.points).toList();
    int index = 0;
    for(int i =0;i<pointsList.length;i++){
      if(points < pointsList[i]!){
        index = i-1;
        break;
      }else if(points == pointsList[i]!){
        index = i;
        break;
      }
    }
    if(points >= pointsList.last!){
      index = 7;
    }
    Color color = const Color.fromRGBO(172, 189, 238, 1);
    switch (index) {
      case 0:
        color = const Color.fromRGBO(172, 189, 238, 1);
        break;
      case 1:
        color = const Color.fromRGBO(129, 179, 233, 1);
        break;
      case 2:
        color = const Color.fromRGBO(98, 189, 130, 1);
        break;
      case 3:
        color = const Color.fromRGBO(247, 177, 184, 1);
        break;
      case 4:
        color = const Color.fromRGBO(231, 201, 233, 1);
        break;
      case 5:
        color = const Color.fromRGBO(223, 138, 146, 1);
        break;
      case 6:
        color = const Color.fromRGBO(204, 33, 26, 1);
        break;
      case 7:
        color = const Color.fromRGBO(243, 166, 89, 1);
        break;
      default:
        color = const Color.fromRGBO(172, 189, 238, 1);
        break;
    }
    return color;
  }

  Future _editName() async {
    await CheckDialog.show(context,
        appTheme: _theme,
        titleText: '设置备注名',
        barrierDismissible: false,
        showInputField: true,
        inputFieldHintText: '请输入备注名…',
        showCancelButton: true,
        cancelButtonText: '取消',
        confirmButtonText: '确定',
        inputFieldMaxLength: 10,
        onInputConfirmPress: (text) async {
          final String trimText = text.trim();
          if(trimText.isNotEmpty){
            String resultCodeCheck = '';
            String errorMsgCheck = '';
            final reqBody = WsAccountRemarkReq.create(
                friendId: widget.searchListInfo!.userId,
                remark: trimText); //???
            await ref.read(accountWsProvider).wsAccountRemark(
                reqBody,
                onConnectSuccess: (succMsg) =>
                resultCodeCheck = succMsg,
                onConnectFail: (errMsg) =>
                errorMsgCheck = errMsg);

            final userModel = ref.read(chatUserModelNotifierProvider);
            final chatUserModel = userModel.firstWhere((info) => info.userName == widget.searchListInfo!.userName);
            ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(
                chatUserModelList: [
                  ChatUserModel(userId: chatUserModel.userId,
                      roomIcon: chatUserModel.roomIcon,
                      cohesionLevel: chatUserModel.cohesionLevel,
                      userCount: chatUserModel.userCount,
                      isOnline: chatUserModel.isOnline,
                      userName: chatUserModel.userName,
                      roomId: chatUserModel.roomId,
                      roomName: chatUserModel.roomName,
                      points: chatUserModel.points,
                      remark: trimText,
                      unRead: chatUserModel.unRead,
                      recentlyMessage: chatUserModel.recentlyMessage,
                      timeStamp: chatUserModel.timeStamp,
                      pinTop: chatUserModel.pinTop,
                      sendStatus: chatUserModel.sendStatus)
                ]);

            //不知道為何會錯，彈一下視窗
            if (errorMsgCheck.isNotEmpty && mounted) {
              await CheckDialog.show(context,
                  appTheme: _theme,
                  titleText: '错误',
                  messageText: errorMsgCheck);
            }
          }
        });
  }

}
