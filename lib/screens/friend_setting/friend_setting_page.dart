
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_req/account/ws_account_remark_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_remark_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/friend_setting/friend_setting_view_model.dart';
import 'package:frechat/screens/user_info_view/user_info_view_report_view.dart';
import 'package:frechat/screens/user_info_view/user_info_view.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/shared/switch_button.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class FriendSettingPage extends ConsumerStatefulWidget {
  final String oppositeUserName;
  final num oppositeUserID;
  final num roomId;
  final String roomName;
  final SearchListInfo searchListInfo;
  const FriendSettingPage({Key? key, required this.oppositeUserName, required this.oppositeUserID, required this.roomId, required this.roomName, required this.searchListInfo}) : super(key: key);

  @override
  ConsumerState<FriendSettingPage> createState() => _FriendSettingPageState();
}

class _FriendSettingPageState extends ConsumerState<FriendSettingPage> {
  bool stickyChat_status = false;
  bool addBlackList_status = false;
  late FriendSettingViewModel viewModel;
  WsMemberInfoRes? memberInfoRes;
  bool isLoadingMemberInfo = true;
  TextEditingController textEditingController = TextEditingController();
  String name = '';
  late AppTheme _theme;
  late AppColorTheme appColorTheme;
  late AppImageTheme appImageTheme;
  late AppTextTheme appTextTheme;
  late AppLinearGradientTheme appLinearGradientTheme;

  @override
  void initState() {
    viewModel = FriendSettingViewModel(ref: ref, setState: setState);
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = _theme.getAppColorTheme;
    appImageTheme = _theme.getAppImageTheme;
    appTextTheme = _theme.getAppTextTheme;
    appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    return Scaffold(
      appBar: _buildMainAppbar(),
      backgroundColor: appColorTheme.baseBackgroundColor,
      body: GestureDetector(
        onTap: () => BaseViewModel.clearAllFocus(),
        child: Column(
          children: [
            friendInformationWidget(),
            switchItem(title:"置顶聊天", status:stickyChat_status, onToggle:(val) =>_updateStickyChatStatus(val)),
            arrowItem(title: "设置备注名",onTap:()=> _editName(),),
            switchItem(title:"加入黑名单",status:addBlackList_status, onToggle:(val) =>_updateAddBlackListStatus(val)),
            arrowItem(title: "举报",onTap:()=> BaseViewModel.pushPage(context, UserInfoViewReportView(userId: widget.oppositeUserID)),)
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildMainAppbar() {
    return MainAppBar(
      theme: _theme,
      backgroundColor: appColorTheme.appBarBackgroundColor,
      title: '好友设置',
      leading: GestureDetector(
        child: Container(
          margin: EdgeInsets.only(left: 14.w),
          // padding: EdgeInsets.all(4),
          child: Image(
            image: AssetImage(appImageTheme.iconBack),
          ),
        ),
        onTap: () => BaseViewModel.popPage(context),
      ),
    );
  }

  //好友資訊
  Widget friendInformationWidget() {
    if(isLoadingMemberInfo){
      return const Center(child: CircularProgressIndicator());
    }
    String age = '${memberInfoRes!.age}';
    String occupation = '${memberInfoRes!.occupation}';
    String height = '${memberInfoRes!.height}';
    String result = '';
    if (age != "null") {
      result = "$age岁";
    }
    if (occupation != "null") {
      result += "、$occupation";
    }
    if (height != "null") {
      result += "、${height}cm";
    }
    final String avatarPath = memberInfoRes!.avatarPath ?? '';
    final num gender = memberInfoRes!.gender ?? 0 ;
    String selfIntroduction = memberInfoRes?.selfIntroduction ?? '';
    selfIntroduction = selfIntroduction.replaceAll("\n", " ");

    List<Widget> contentList = [];
    
    contentList.add(_buildName());
    contentList.add(
      Text(
        result,
        overflow:TextOverflow.ellipsis,
        style: appTextTheme.friendSettingPageUserInfoTextStyle,
      ),
    );

    if (selfIntroduction.isNotEmpty) {
      contentList.add(
        Text(
          selfIntroduction.trim(),
          overflow: TextOverflow.ellipsis,
          style: appTextTheme.friendSettingPageUserSelfIntroductionTextStyle,
        ),
      );
    }


    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 24.h, bottom: 24.h),
        child: Row(
          children: [
            (avatarPath != '')
                ? AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatarPath, size: 64.w)
                : AvatarUtil.defaultAvatar(gender, size: 64.w),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: contentList,
              ),
            ),
            const SizedBox(width: 10),
            ImgUtil.buildFromImgPath(appImageTheme.iconRightArrow, size: 20.h, fit: BoxFit.scaleDown)
          ],
        ),
      ),
      onTap: () => BaseViewModel.pushPage(context,
        UserInfoView(
          memberInfo: memberInfoRes,
          searchListInfo: widget.searchListInfo,
          displayMode: DisplayMode.chatMessage,
        )),
    );
  }

  _buildName() {
    return Consumer(builder: (context, ref, _){
      final List<ChatUserModel> chatUserModels = ref.watch(chatUserModelNotifierProvider);
      final ChatUserModel model = chatUserModels.firstWhere((model) => model.userName == widget.oppositeUserName);
      final String userName = model.userName ?? '';
      final String roomName = model.roomName ?? '';
      final String remarkName = model?.remark ?? '';
      final String displayName = ConvertUtil.displayName(userName, roomName, remarkName);
      return Text(
        displayName,
        style: appTextTheme.friendSettingPageUserNameTextStyle,
      );
    });
  }

  //選項item(有開關)
  Widget switchItem({required String title, required bool status,required Function (bool) onToggle}) {
    return Container(
        height: 55.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 4.h),
        padding:  EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: appColorTheme.freindSettingPageItemBackGroundColor,
          border: Border.all(
            color: appColorTheme.freindSettingPageItemBorderColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: appTextTheme.friendSettingPageItemTextStyle,
            ),
            SwitchButton(
              enable: status,
              onChange: (val) => onToggle.call(val),
            ),
          ],
        ));
  }

  //選項item(無開關)
  Widget arrowItem({required String title,required Function () onTap}) {
    return GestureDetector(
      onTap:()=> onTap.call(),
      child:  Container(
          height: 55.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 4.h),
          padding:  EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: appColorTheme.freindSettingPageItemBackGroundColor,
            border: Border.all(
              color: appColorTheme.freindSettingPageItemBorderColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12.w)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: appTextTheme.friendSettingPageItemTextStyle,
              ),
              ImgUtil.buildFromImgPath(appImageTheme.iconRightArrow, size: 24.h, fit: BoxFit.scaleDown)
            ],
          )),
    );
  }

  //改變置頂聊天狀態
  void _updateStickyChatStatus(bool newValue) {
    final allChatUserModelList = ref.read(chatUserModelNotifierProvider);
    final list = allChatUserModelList.where((info) => info.userName == memberInfoRes!.userName).toList();
    ChatUserModel chatUserModel = list[0];
    if(newValue) {
      ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList:[
        ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
            isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points,
            remark: chatUserModel.remark, unRead: chatUserModel.unRead, recentlyMessage:chatUserModel.recentlyMessage, timeStamp: chatUserModel.timeStamp, pinTop: 1,sendStatus:chatUserModel.sendStatus )
      ]);
    } else {
      ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList:[
        ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
            isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points,
            remark: chatUserModel.remark, unRead: chatUserModel.unRead, recentlyMessage:chatUserModel.recentlyMessage, timeStamp: chatUserModel.timeStamp, pinTop: 0,sendStatus:chatUserModel.sendStatus, )
      ]);
    }
    setState(() {
      stickyChat_status = newValue;
    });
  }

  //改變黑名單狀態
  Future<void> _updateAddBlackListStatus(bool newValue) async {
    // 通話中不可發起新通話
    final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
    if (isPipMode){
      BaseViewModel.showToast(context, "您现在正在通话中，无法将他人加入黑名单");
      return;
    }
    CommDialog(context).build(
      theme: _theme,
      backgroundColor: appColorTheme.dialogBackgroundColor,
      leftLinearGradient: appLinearGradientTheme.buttonDisableColor,
      rightLinearGradient: appLinearGradientTheme.buttonPrimaryColor,
      leftTextStyle: appTextTheme.buttonDisableTextStyle,
      rightTextStyle: appTextTheme.buttonPrimaryTextStyle,
      title: '提示',
      contentDes: '拉黑后，你将不再收到对方的消息，并且你们互相看不到对方的动态更新，可以在 "设置 - 黑名单" 中解除。',
      leftBtnTitle: '取消',
      rightBtnTitle: '确定',
      leftAction: () {
        BaseViewModel.popPage(context);
        setState(() {addBlackList_status = false;});
      },
      rightAction: () async {
        String? resultCodeCheck;
        await viewModel.wsNotificationLeaveGroupBlock(
            roomId: widget.roomId,
            onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
            onConnectFail: (errMsg) {
              BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
              setState(() {addBlackList_status = false;});
            });
        if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
          viewModel.insertBlockInfoToSqfLite(widget.searchListInfo);
          if(context.mounted) {
            BaseViewModel.popPage(context);
            BaseViewModel.popPage(context);
            BaseViewModel.popPage(context);
            BaseViewModel.showToast(context, '已将对方拉黑！');
          }
        }
      }
    );
  }

  //取得用戶資料
  Future<void> getUserInfo() async {
    final reqBody = WsMemberInfoReq.create(
      userName: widget.oppositeUserName,
    );
    memberInfoRes = await ref.read(memberWsProvider).wsMemberInfo(reqBody, onConnectSuccess: (succMsg) {}, onConnectFail: (errMsg) {
      BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
    });
    if (memberInfoRes!.nickName != null) {
      name = memberInfoRes!.nickName!;
    } else {
      name = memberInfoRes!.userName!;
    }
    if(name != widget.roomName){
      name = widget.roomName;
    }

    final allChatUserModelList = ref.read(chatUserModelNotifierProvider);
    final list = allChatUserModelList.where((info) => info.userName == memberInfoRes!.userName).toList();
    if(list[0].pinTop == 1){
      stickyChat_status = true;
    }
    setState(() {
      isLoadingMemberInfo = false;
    });
  }



  //預設男女大頭貼
  // Widget maleOrFemaleAvatarWidget() {
  //   String imagePath = 'assets/images/default_female_avatar.png';
  //   if (memberInfoRes!.gender == 1) {
  //     imagePath = 'assets/images/default_male_avatar.png';
  //   }
  //   return SizedBox(
  //     width: 64.w,
  //     height: 64.w,
  //     child: CircleAvatar(
  //       backgroundImage: AssetImage(imagePath),
  //     ),
  //   );
  // }

  Future _editName() async {
    await CheckDialog.show(context,
        titleText: '设置备注名',
        barrierDismissible: false,
        showInputField: true,
        inputFieldHintText: '请输入备注名…',
        showCancelButton: true,
        cancelButtonText: '取消',
        confirmButtonText: '确定',
        inputFieldMaxLength: 10,
        appTheme: _theme,
        onInputConfirmPress: (text) async {
          final String trimText = text.trim();
          if(trimText.isNotEmpty){
            String resultCodeCheck = '';
            String errorMsgCheck = '';
            final WsAccountRemarkReq reqBody = WsAccountRemarkReq.create(friendId: widget.oppositeUserID, remark: trimText);
            final WsAccountRemarkRes res = await ref.read(accountWsProvider).wsAccountRemark(reqBody,
                onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
                onConnectFail: (errMsg) => errorMsgCheck = errMsg
            );

            if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
              setRemarkInDB(trimText);
            }
            if (errorMsgCheck.isNotEmpty && mounted) {
              //不知道為何會錯，彈一下視窗
              await CheckDialog.show(context, titleText: '错误', messageText: errorMsgCheck, appTheme: _theme);
            }
          }
        });
  }

  void setRemarkInDB(String remark){
    final List<ChatUserModel> chatUserModelList = ref.read(chatUserModelNotifierProvider);
    ChatUserModel chatUserModel = chatUserModelList.firstWhere((info) => info.userName == widget.oppositeUserName);
    final ChatUserModel model = ChatUserModel(
      userId: chatUserModel.userId,
      roomIcon: chatUserModel.roomIcon,
      cohesionLevel: chatUserModel.cohesionLevel,
      userCount: chatUserModel.userCount,
      isOnline: chatUserModel.isOnline,
      userName: chatUserModel.userName,
      roomId: chatUserModel.roomId,
      roomName: chatUserModel.roomName,
      points: chatUserModel.points,
      remark: remark,
      recentlyMessage: chatUserModel.recentlyMessage,
      unRead: chatUserModel.unRead,
      timeStamp: chatUserModel.timeStamp,
      pinTop: chatUserModel.pinTop,
      sendStatus:chatUserModel.sendStatus
    );
    ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [model]);
  }
}
