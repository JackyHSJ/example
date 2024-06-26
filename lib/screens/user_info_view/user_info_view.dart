import 'dart:convert';
import 'dart:math';
import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_remark_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_list_res.dart';
import 'package:frechat/screens/activity/activity_post_detail.dart';
import 'package:frechat/screens/user_info_view/user_info_view_posts.dart';
import 'package:frechat/screens/user_info_view/user_info_view_view_model.dart';
import 'package:frechat/system/assets_path/assets_images_path.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/util/dialog_util.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/widgets/activity/cell/activity_video_player.dart';
import 'package:frechat/widgets/shared/bottom_sheet/common_bottom_sheet.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/media_thumbnail.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/shared/video_thumbnail_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:frechat/widgets/user_info_view/user_info_view_tags.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frechat/screens/image_links_viewer.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/list/main_wrap.dart';
import 'package:frechat/widgets/strike_up_list/strike_up_list_extension.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/models/ws_req/account/ws_account_follow_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_remark_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_leave_group_block_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_strike_up_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_fate_recommend_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/mission/ws_mission_search_status_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_strike_up_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/widgets/shared/dialog/recharge_dialog.dart';
import 'package:frechat/widgets/shared/buttons/gradient_button.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/user_info_view/buttons/user_info_view_play_bt.dart';
import 'package:frechat/widgets/user_info_view/user_info_view_data_cell.dart';
import 'package:frechat/widgets/user_info_view/user_info_view_states.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/screens/profile/edit/personal_edit.dart';
import 'package:frechat/screens/user_info_view/user_info_view_report_view.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';

// 功能類型
enum DisplayMode {
  friendSettingPage, // 好友設置
  personalInfo, // 我的
  strikeUp, // 緣分
  chatMessage, // 訊息
}

class UserInfoView extends ConsumerStatefulWidget {

  final WsMemberInfoRes? memberInfo; // 觀看自己需傳入
  final FateListInfo? fateListInfo; // 緣分頁傳入資料（包括搜尋）
  final SearchListInfo? searchListInfo; // 消息頁傳入資料，ChatMessage 傳入附帶資料
  final DisplayMode displayMode; // 功能類型

  const UserInfoView({
    super.key,
    this.memberInfo,
    this.fateListInfo, // 緣份頁
    this.searchListInfo, // 消息頁
    required this.displayMode,
  });

  @override
  ConsumerState<UserInfoView> createState() => _UserInfoState();
}

class _UserInfoState extends ConsumerState<UserInfoView> with TickerProviderStateMixin {
  late ChatRoomViewModel chatRoomViewModel;
  late UserInfoViewViewModel viewModel;
  late AppTheme _theme;
  late AppImageTheme appImageTheme;
  late AppColorTheme appColorTheme;
  late AppLinearGradientTheme appLinearGradientTheme;
  late AppTextTheme appTextTheme;
  late AppBoxDecorationTheme appBoxDecorationTheme;

  bool isChat = false;

  // 這個幾乎保證會有，只有例外狀況才會沒有。
  WsMemberInfoRes? _memberInfo;

  //[Neo]: 未必有東西，只有 widget.fateListInfo 搭訕清單資料非 null 才會有。
  //或者 ChatMessage 會直接給
  SearchListInfo? _searchListInfo;
  DisplayMode? displayMode;
  num? userId;

  // 初始化
  Future<void> _initializePage() async {
    //ChatMessage case. 直接給。
    if (widget.searchListInfo != null) {
      _searchListInfo = widget.searchListInfo;
    }

    ///TODO:暫時恢復，這邊邏輯要改，『getMemberInfoFromUserName』不應該重複打
    _memberInfo = await viewModel.getMemberInfoFromUserName(context, userName: widget.fateListInfo?.userName ?? widget.memberInfo?.userName ?? widget.searchListInfo?.userName ??'');
    //這邊判斷來源資料, 取得必要變數
    if (widget.memberInfo != null) {
      _memberInfo = widget.memberInfo;
    } else if (widget.fateListInfo != null) {
      //取得 memberInfo 資料
      _memberInfo = await viewModel.getMemberInfoFromUserName(context, userName: widget.fateListInfo?.userName ??  _searchListInfo?.userName ??'');
      //取得 _searchListInfo, 依賴 fateListInfo
      await _tryRefreshSearchListInfo();
      setState(() {});
    }

    //嘗試從 local 端 db 內找到已經搭訕過的證據 roomId
    //並以此來取得 _searchListInfo
    if (_searchListInfo == null) {
      num? foundExistRoomId;
      if (_memberInfo != null) {
        List<ChatUserModel> chatUserModels = ref.watch(chatUserModelNotifierProvider);
        for (ChatUserModel chatUserModel in chatUserModels) {
          if (chatUserModel.userName != null && chatUserModel.userName == _memberInfo!.userName) {
            foundExistRoomId = chatUserModel.roomId;
          }
        }
      }
      print('foundExistRoomId $foundExistRoomId');
      if (foundExistRoomId != null) {
        _searchListInfo = await _getSearchListInfoByRoomID(foundExistRoomId);
      }
    } else {
      print('_searchListInfo exist ${jsonEncode(_searchListInfo)}');
    }

    setState(() {});
  }


  // 查詢消息清單(取得亲密度)API 4-1
  Future<SearchListInfo?> _getSearchListInfoByRoomID(num roomID) async {
    String resultCodeCheck = '';
    final WsNotificationSearchListReq req = WsNotificationSearchListReq.create(page: '1', roomId: roomID, type: 0);
    try {
      final WsNotificationSearchListRes res = await ref.read(notificationWsProvider).wsNotificationSearchList(req,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
      );

      if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
        ref.read(userUtilProvider.notifier).loadNotificationListInfo(res);
        if (res.list != null) {
          if (res.list!.isNotEmpty) {
            setState(() {});
            return res.list![0];
          }
        }
      } else {
        // ignore: avoid_print
        print('wsNotificationSearchList 失敗:$resultCodeCheck');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }

    return null;
  }

  Future<SearchListInfo?> _tryRefreshSearchListInfo() async {
    if (widget.fateListInfo != null && widget.fateListInfo!.roomId != null) {
      _searchListInfo = await _getSearchListInfoByRoomID(widget.fateListInfo!.roomId!);
      return _searchListInfo;
    } else if (_searchListInfo != null && _searchListInfo!.roomId != null) {
      _searchListInfo = await _getSearchListInfoByRoomID(_searchListInfo!.roomId!);
      return _searchListInfo;
    }
    print('[_tryRefreshSearchListInfo] return null?!');
    return null;
  }

  // 搭訕 API 4-2
  _strikeUp(bool sendMsg) async {

    if (_memberInfo != null && _memberInfo!.userName != null && _memberInfo!.userName!.isNotEmpty) {
      String resultCodeCheck = '';
      final WsNotificationStrikeUpReq reqBody = WsNotificationStrikeUpReq.create(userName: _memberInfo!.userName!, type: 0);
      final WsNotificationStrikeUpRes res = await ref.read(notificationWsProvider).wsNotificationStrikeUp(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
      );

      if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
        if (res.chatRoom != null && res.chatRoom!.roomId != null) {
          _searchListInfo = await _getSearchListInfoByRoomID(res.chatRoom!.roomId!);
          displayMode = DisplayMode.chatMessage;
          if (_searchListInfo != null) {
            //立即在搭訕成功後將這個資料存下至 local db
            ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList:[
              //ChatUserModel 與 ChatRoomInfo 是大部分對的上的, 這邊直接用 json 轉
              ChatUserModel.fromWsModel(res.chatRoom!, _searchListInfo!)
            ]);

            //Riverpod notify this searchListInfo. This will update StrikeUpListMemberCard's strikeUp button.
            ref.read(strikeUpUpdatedProvider.notifier).state = _searchListInfo;
          }
        }

        //搭訕/心動發送常用語
        if (sendMsg) {
          if (_searchListInfo != null) {
            if (ref.read(userInfoProvider).memberInfo!.gender == 0) {
              _sendCommonPhrases(_searchListInfo!);
            } else {
              _sendPickUpPhrases(_searchListInfo!);
            }
          }
          if (!context.mounted) return;
          String name = _memberInfo!.nickName ?? _memberInfo!.userName!;
          BaseViewModel.showToast(context, '您已${ref.read(userInfoProvider).memberInfo!.gender.asLoveLabel()} $name！');
        }
        setState(() {
          // _fateListUserId = wns.chatRoom!.userId!;
          //_userName = wns.chatRoom!.userName!;
          // _roomId = wns.chatRoom!.roomId!;
          isChat = true;
        });
      } else if (resultCodeCheck == ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH) {
        _showRechargeDialog();
      }
    }
  }

  // 取得動態貼文
  Future<void> _getActivityPost() async {
    String? userName = _searchListInfo?.userName ?? widget.fateListInfo?.userName;
    num personalGender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    num? oppositeGender = personalGender == 1 ? 0 : 1;
    String personalUserName = ref.read(userInfoProvider).memberInfo?.userName ?? '';

    if (personalUserName != _memberInfo?.userName && userName == null) {
      userName = _memberInfo?.userName;
      oppositeGender = _memberInfo?.gender;
    }

    // 看自己不用帶 userName, gender
    if (displayMode == DisplayMode.personalInfo) {
      userName = null;
      oppositeGender = null;
    }

    // 看自己不用帶 userName, gender（暫解）
    if (_memberInfo?.userName == personalUserName) {
      userName = null;
      oppositeGender = null;
    }

    WsActivitySearchInfoType type = WsActivitySearchInfoType.personal;
    String typeString = WsActivitySearchInfoType.values.indexOf(type).toString();
    String resultCodeCheck = '';
    final WsActivitySearchInfoReq reqBody = WsActivitySearchInfoReq.create(type: typeString, condition: '0', userName: userName, gender: oppositeGender);
    final WsActivitySearchInfoRes res = await ref.read(activityWsProvider).wsActivitySearchInfo(
      reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      res.type = type;
      _refreshActivityAllLikePostIdList(res.likeList??[]);
      if (displayMode == DisplayMode.personalInfo) {
        await ref.read(userUtilProvider.notifier).loadActivityInfoPersonal(res);
      } else {
        // 只取審核過的貼文 list
        final List<ActivityPostInfo>? verifyActivityList = res.list?.where((item) => item.status != 0).toList();
        res.list = verifyActivityList;
        await ref.read(userUtilProvider.notifier).loadActivityInfoOthers(res);
      }
    }
  }
  /// 更新至 全部已按讚動態貼文ID清單
  Future<void> _refreshActivityAllLikePostIdList(List<dynamic> likeList) async{
    List<dynamic> allLikeList = await ref.read(userInfoProvider).activityAllLikePostIdList?? [];
    Set<dynamic> mergedSet = {};
    mergedSet.addAll(allLikeList);
    mergedSet.addAll(likeList);
    List<dynamic> mergedList = mergedSet.toList();
    ref.read(userUtilProvider.notifier).loadActivityAllLikePostIdList(mergedList);
  }

  void insertToChatUserDb(SearchListInfo searchInfo,String recentlyMessage){
    ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(
        chatUserModelList: [
          ChatUserModel(userId: searchInfo.userId,
              roomIcon: searchInfo.roomIcon,
              cohesionLevel: 0,
              userCount: searchInfo.userCount,
              isOnline: searchInfo.isOnline,
              userName: searchInfo.userName,
              roomId: searchInfo.roomId,
              roomName: searchInfo.roomName,
              points: 0,
              remark: searchInfo.roomName,
              unRead: 0,
              recentlyMessage: recentlyMessage,
              timeStamp:  DateTime.now().millisecondsSinceEpoch,
              pinTop: 0,
              charmCharge: '',
          sendStatus:searchInfo.sendStatus??1 )
        ]);
  }

  @override
  void initState() {
    _initChatRoomViewModelForPhoneCall();
    super.initState();
  }

  Future<void> _initChatRoomViewModelForPhoneCall() async {
    chatRoomViewModel = ChatRoomViewModel(ref: ref, setState: setState, context: context, tickerProvider: this);
    chatRoomViewModel.init(_searchListInfo?.points ?? 0, _searchListInfo?.cohesionLevel ?? 0, _searchListInfo?.userName ?? '');
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    displayMode = widget.displayMode;
    if (widget.fateListInfo != null) {
      userId = widget.fateListInfo?.id;
    } else if (widget.searchListInfo != null) {
      userId = widget.searchListInfo?.userId;
    }
    // print('FateListInfo: ${widget.fateListInfo?.id}');
    // print('searchListInfo: ${widget.searchListInfo?.userId}');
    // print('displayMode: ${displayMode}');
    // print('memberInfo: ${widget.memberInfo?}');
    viewModel = UserInfoViewViewModel(ref: ref, setState: setState, context: context, userId: userId);
    viewModel.init(context);
    await _initializePage();
    _getActivityPost();
  }

  @override
  Widget build(BuildContext context) {
    SearchListInfo? searchListInfo = ref.watch(strikeUpUpdatedProvider);
    if (searchListInfo != null && widget.fateListInfo != null && searchListInfo.userId == widget.fateListInfo!.id) {
      _searchListInfo = searchListInfo;
      setState(() {});
    }
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = _theme.getAppColorTheme;
    appImageTheme = _theme.getAppImageTheme;
    appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    appTextTheme = _theme.getAppTextTheme;
    appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    return Scaffold( //
      backgroundColor: appColorTheme.appBarBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: MainAppBar(
          theme: _theme,
          title: '',
          defaultIconColor: Colors.white,
          // backgroundColor: AppColors.globalBackGround.withOpacity(0.2),
          leading: _buildLeading(),
          actions: _buildActions()),
      body: Stack(
        children: [
          _memberInfoGallery(),
          _buildDraggableSheet(),
        ],
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Widget _buildDraggableSheet() {
    final double sheetSize = viewModel.getDraggableScrollableSheetSize();
    return DraggableScrollableSheet(
      initialChildSize: sheetSize,
      minChildSize: sheetSize,
      maxChildSize: 1.0,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          physics: ClampingScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(WidgetValue.btnRadius / 2), topRight: Radius.circular(WidgetValue.btnRadius / 2)),
              color: appColorTheme.appBarBackgroundColor
            ),
            child: Column(
              children: [
                _memberInfoTitle(),
                _memberInfoPost(),
                _memberInfoBody(),
                // _memberDataInfo(),
              ],
            ),
          ),
        );
      },
    );
  }

  // 相冊
  Widget _memberInfoGallery() {
    return Stack(
      children: [
        // 照片
        _buildAvatarPhotoView(),
        // 在線狀態
        onlineStatus(),
        // 頁籤狀態指示
        _buildPhotoTabIndication(),
        // _buildMask(),
      ],
    );
  }

  // 動態牆
  Widget _memberInfoPost() {


    return Consumer(builder: (context, ref, _) {

      List<ActivityPostInfo> feedingList = [];

      if (displayMode == DisplayMode.personalInfo) {
        feedingList = ref.watch(userInfoProvider).activitySearchInfoPersonal?.list ?? [];
      } else {
        feedingList = ref.watch(userInfoProvider).activitySearchInfoOthers?.list ?? [];
      }

      final bool hasPost = feedingList.isNotEmpty ? true : false;

      if (!hasPost) return const SizedBox();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('最新动态', style: TextStyle(color: appColorTheme.userInfoViewCellTitleTextColor, fontSize: 12, fontWeight: FontWeight.w400)),
                InkWell(
                  onTap: () {

                    DisplayMode? displayMode;
                    String personalUserName = ref.read(userInfoProvider).memberInfo?.userName ?? '';

                    if (_memberInfo?.userName == personalUserName) {
                      displayMode = DisplayMode.personalInfo;
                    } else {
                      displayMode = DisplayMode.strikeUp;
                    }

                    BaseViewModel.pushPage(context, UserInfoViewPosts(feedingList: feedingList, displayMode: displayMode!));
                  },
                  child: const Text('查看更多 >', style: TextStyle(color: Color(0xff7282FF), fontSize: 12)),
                )
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50.w,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return _memberPost(feedingList[index], index);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(width: 6.w);
                  },
                  itemCount: feedingList.length
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  // 單一動態貼文
  Widget _memberPost(ActivityPostInfo postInfo, int index) {
    final num type = postInfo.type ?? 0;
    return GestureDetector(
        onTap: () => BaseViewModel.pushPage(context, ActivityPostDetail(postInfo: postInfo)),
        child: type == 0 ? _memberPostPhoto(postInfo, index) : _memberPostVideo(postInfo, index)
    );
  }


  // 相片貼文
  Widget _memberPostPhoto(ActivityPostInfo data, int index) {
    final String contentUrl = data.contentUrl ?? '';
    List<String> contentUrls = contentUrl.split(',');
    final url = HttpSetting.baseImagePath + contentUrls.first;
    return Container(
      key: ValueKey(index),
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppColors.mainGrey,
      ),
      child: CachedNetworkImageUtil.load(url, radius: 6),
    );
  }

  // 影片貼文
  Widget _memberPostVideo(ActivityPostInfo data, int index) {
    final String displayUrl = data.contentUrl ?? '';
    final url = HttpSetting.baseImagePath + displayUrl;
    return MediaThumbnail(
      key: ValueKey(index),
      videoUrl: url,
      borderRadius: 6,
    );
  }

  // 底部導覽列
  Widget _bottomNavBar() {

    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppBoxDecorationTheme appBoxDecorationTheme = theme.getAppBoxDecorationTheme;
    final AppColorTheme appColorTheme = theme.getAppColorTheme;

    List<Widget> rowChildren = [];
    if (displayMode == DisplayMode.personalInfo) {
      rowChildren.add(Expanded(child: _editPersonalInfoButton()));
    } else {
      // 按鈕: 可能為 私聊 or 搭訕 / 心動
      if (displayMode == DisplayMode.friendSettingPage ||
          displayMode == DisplayMode.chatMessage ||
          isChat) {
        if (_searchListInfo != null) {
          rowChildren.add(Expanded(child: _chatButton()));
        }
      } else {
        // 這應該是心動 or 搭訕按鈕
        if (_memberInfo != null) {
          if (_searchListInfo != null) {
            rowChildren.add(Expanded(child:_chatButton()));
          } else {
            String buttonText = '--';
            buttonText = _memberInfo!.gender == 0 ? '搭讪' : '心动';
            rowChildren.add(Expanded(child: _strikeUpButton(buttonText)));
          }
        }
      }
      if (viewModel.showCallType) {
        // 通話按鈕
        if (_searchListInfo != null) {
          if (rowChildren.isNotEmpty) rowChildren.add(const SizedBox(width: 16));

          rowChildren.add(_bottomBarIconButton(
            icon: Image.asset('assets/user_info_view/icon_phone_call.png', width: 24, height: 24,),
              text: '通话',
              onTap: () async {

                // 通話中不可發起新通話
                final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
                if (isPipMode) {
                  BaseViewModel.showToast(context, '您正在通话中，不可发起新通话');
                  return;
                }

                // 親密度等級不足二級會跳親密度彈窗
                if (_searchListInfo!.cohesionLevel! < 2) {
                  showCohesionDialog();
                  return;
                }

                // 正常流程
                chatRoomViewModel.memberInfoRes = _memberInfo;
                chatRoomViewModel.callOrVideoBottomDialog(memberInfo: _memberInfo, searchListInfo: _searchListInfo);
              }));
        }
      }

      // 禮物/關注 按鈕
      if (_searchListInfo != null && _memberInfo != null) {
        if (rowChildren.isNotEmpty) rowChildren.add(const SizedBox(width: 16));

        // 正在關注(follow)，會變成禮物按鈕，反之關注按鈕
        if (_memberInfo?.isFollow == true) {
          // 禮物
          rowChildren.add(_bottomBarIconButton(
            icon: Image.asset('assets/user_info_view/icon_gift.png', width: 24, height: 24),
            text: '礼物',
            onTap: () => BaseViewModel.pushPage(context, ChatRoom(unRead: 0,searchListInfo: _searchListInfo,))));
        } else {
          // 關注
          rowChildren.add(_bottomBarIconButton(
            icon: Image.asset('assets/user_info_view/icon_follow.png', width: 24, height: 24),
            text: '关注',
            onTap: () => _follow()));
        }
      }
    }

    return BottomAppBar(
      padding: EdgeInsets.zero,
      surfaceTintColor: Colors.white,
      color: Colors.white,
      shadowColor: Colors.black,
      elevation: 10, // 设置阴影高度
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        color: appColorTheme.userInfoViewNavigatorBgColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowChildren,
        ),
      ),
    );
  }

  Widget _bottomBarIconButton({
    required Widget icon,
    required String text,
    Function()? onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 44,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            Text(
              text,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.mainDark,),),
          ],
        ),
      ),
    );
  }

  Widget _memberInfoTitle() {
    if (_memberInfo != null) {
      String displayNickName = '--';
      if (_memberInfo!.nickNameAuth == 1 &&
          _memberInfo!.nickName != null &&
          _memberInfo!.nickName!.isNotEmpty) {
        displayNickName = _memberInfo!.nickName!;
      } else {
        if (widget.fateListInfo != null) {
          if (widget.fateListInfo!.nickName != null) {
            displayNickName = widget.fateListInfo!.nickName!;
          } else {
            displayNickName = _memberInfo!.userName ?? '';
          }
        } else {
          displayNickName = _memberInfo!.nickName!;
        }
      }

      String remark = '';
      if (_searchListInfo != null && _searchListInfo!.remark != null) {
        remark = _searchListInfo!.remark!;
      }

      bool showAudioBt = true;
      if(_memberInfo!.audioPath == '' || _memberInfo!.audioPath == null ){
        showAudioBt =  false;
      }



      if (remark.isEmpty) {

      }

      return ListTile(
        // 暱稱、VIP
        title: Row(
          children: [
            // 暱稱
            _buildDisplayName(displayNickName),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                // 性別年齡、魅力、实名认证、真人认证
                UserInfoStates(memberInfo: _memberInfo!),
              ],
            ),
            _buildRemarkName(remark),
          ],
        ),
        // 播放按鈕(如果有录音档则直接显示，没有的话则隐藏)
        // trailing: (_memberInfo!.audioAuth == 1 || _memberInfo!.audioAuth == 2)
        trailing: (showAudioBt)
            ? UserInfoPlayBt(audioPath: _memberInfo!.audioPath)
            : const SizedBox(),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildRemarkName(String remark) {

    if (remark.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          remark,
          style: const TextStyle(
            color: AppColors.textFormBlack,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayName(String displayNickName) {

    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppColorTheme appColorTheme = theme.getAppColorTheme;

    return Text(
      displayNickName,
      style: TextStyle(
        color: appColorTheme.userInfoViewCellNameTextColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _memberInfoBody() {

    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppBoxDecorationTheme appBoxDecorationTheme = theme.getAppBoxDecorationTheme;
    final AppColorTheme appColorTheme = theme.getAppColorTheme;

    if (_memberInfo == null) {
      return const SizedBox();
    }

    String selfIntroduction = _memberInfo?.selfIntroduction ?? '';
    selfIntroduction = selfIntroduction.replaceAll("\n", " ");

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 3),
          Text('个人讯息', style: TextStyle(color: appColorTheme.userInfoViewCellTitleTextColor, fontSize: 12, fontWeight: FontWeight.w400)),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              UserInfoViewDataCell(title: '性別', text: asGender(_memberInfo?.gender)),
              SizedBox(width: 6),
              UserInfoViewDataCell(title: '年龄', text: _memberInfo!.age.toString()),
              SizedBox(width: 6),
              UserInfoViewDataCell(title: '情感', text: asMaritalStatus(_memberInfo?.maritalStatus)),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              UserInfoViewDataCell(title: '身高', text: asHeight(_memberInfo?.height)),
              SizedBox(width: 6),
              UserInfoViewDataCell(title: '体重', text: asWeight(_memberInfo?.weight)),
              SizedBox(width: 6),
              UserInfoViewDataCell(title: '家乡', text: _memberInfo!.hometown ?? ''),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              UserInfoViewDataCell(title: '学历', text: _memberInfo!.education ?? ''),
              SizedBox(width: 6),
              UserInfoViewDataCell(title: '职业', text: _memberInfo!.occupation ?? ''),
              SizedBox(width: 6),
              UserInfoViewDataCell(title: '收入', text: _memberInfo!.annualIncome ?? ''),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            width: 300,
            height: 46.h,
            decoration: appBoxDecorationTheme.userInfoViewDataCellBoxDecoration,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 3, 0),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('ID', style: TextStyle(fontSize: 10, color: AppColors.mainDark)),
                          Text(_memberInfo!.userName ?? '', style: TextStyle(fontSize: 12, color: appColorTheme.userInfoViewCellSecondaryTextColor, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => BaseViewModel.copyText(context, copyText: _memberInfo!.userName ?? ''),
                    icon: ImgUtil.buildFromImgPath('assets/user_info_view/icon_copy.png', size: 24),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('个性标签', style: TextStyle(color: appColorTheme.userInfoViewCellTitleTextColor, fontSize: 12, fontWeight: FontWeight.w400)),
          const SizedBox(height: 6),
          _memberTags(),
          const SizedBox(height: 16),
          Text('个性签名', style: TextStyle(color: appColorTheme.userInfoViewCellTitleTextColor, fontSize: 12, fontWeight: FontWeight.w400)),
          const SizedBox(height: 6),
          Text(selfIntroduction.trim(), style: TextStyle(color: appColorTheme.userInfoViewCellPrimaryTextColor, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _memberTags() => UserInfoViewTags(memberInfo: _memberInfo);

  // 關注 API
  _follow() async {
    if (_searchListInfo != null && _searchListInfo!.userId != null) {
      String resultCodeCheck = '';
      final WsAccountFollowReq reqBody = WsAccountFollowReq.create(isFollow: true, friendId: _searchListInfo!.userId);

      await ref.read(accountWsProvider).wsAccountFollow(reqBody,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => resultCodeCheck = errMsg
      );

      if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
        await _tryRefreshSearchListInfo();
        _memberInfo?.isFollow = true;
        if (context.mounted) BaseViewModel.showToast(context, '关注成功');
        setState(() {});
      } else {
        if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }

    } else {
      await CheckDialog.show(context, titleText: '錯誤', messageText: '_userInfo 不存在，無亲密等級可用', appTheme: _theme);
    }
  }

  Widget _buildLeading() {
    return InkWell(
      child: Icon(
        Icons.arrow_back_ios_new_outlined,
        color: AppColors.btnConfirmTextColor,
        size: WidgetValue.smallIcon,
      ),
      onTap:() => BaseViewModel.popPage(context),
    );
  }

  // 右上按鈕：更多（選項）
  List<Widget> _buildActions() {
    List<Widget> buttonsList = [];
    // 只有有 userID (int _searchListInfo) 的人可以被修改註記.
    if (_searchListInfo != null) {
      // 修改备注名
      buttonsList.add(remarkButton());
    }
    // 举报
    // 只有有 userID 的人 (int _searchListInfo) 可以被舉報
    if (_searchListInfo != null) {
      // 修改备注名
      buttonsList.add(reportButton());
    }

    // 拉黑
    // 只有有 roomID 的人 (int _searchListInfo) 可以被拉黑
    if (_searchListInfo != null) {
      buttonsList.add(ignoreButton());
    }

    if (buttonsList.isNotEmpty) {
      return [
        displayMode == DisplayMode.personalInfo
            ? const SizedBox()
            : IconButton(
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                ),
                onPressed: () {
                  CommonBottomSheet.show(
                    context,
                    actions: buttonsList
                  );
                }
              ),
      ];
    } else {
      return [];
    }
  }

  // 修改備註名
  Widget remarkButton() {
    return CommonBottomSheetAction(
      title: '修改备注名',
      titleStyle: TextStyle(fontSize: 16, color: appColorTheme.userInfoViewRemarkTextColor, fontWeight: FontWeight.w400),
      onTap: () async{
        Navigator.pop(context);
        await CheckDialog.show(context,
          appTheme: _theme,
          titleText: '设置备注名',
          barrierDismissible: false,
          showInputField: true,
          inputFieldHintText: '请输入备注名…',
          inputFieldMaxLength: 10,
          showCancelButton: true,
          onInputConfirmPress: (text) async {
            final String trimText = text.trim();
            if (trimText.isEmpty) return;

            String resultCodeCheck = '';
            final WsAccountRemarkReq reqBody = WsAccountRemarkReq.create(
                friendId: widget.searchListInfo!.userId,remark: trimText
            );
            final WsAccountRemarkRes res = await ref.read(accountWsProvider).wsAccountRemark(reqBody,
                onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
                onConnectFail: (errMsg) => resultCodeCheck = errMsg
            );

            if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
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
                    sendStatus: chatUserModel.sendStatus
                  )
                ]
              );
            } else {
              if(context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
            }
          },
        );
      },
    );
  }

  // 舉報
  Widget reportButton() {
    return CommonBottomSheetAction(
      title: '举报',
      titleStyle: TextStyle(fontSize: 16, color: appColorTheme.userInfoViewReportTextColor, fontWeight: FontWeight.w400),
      onTap: () {
        if (_searchListInfo != null && _searchListInfo!.userId != null) {
          Navigator.pop(context);
          BaseViewModel.pushPage(context, UserInfoViewReportView(userId: _searchListInfo!.userId!,));
        }
      },
    );

  }

  // 拉黑按鈕
  Widget ignoreButton() {
    return CommonBottomSheetAction(
      title: '拉黑',
      titleStyle: TextStyle(fontSize: 16, color: appColorTheme.userInfoViewBlockTextColor, fontWeight: FontWeight.w400),
      onTap: () async{
        // 通話中不可發起新通話
        final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
        if (isPipMode) {
          BaseViewModel.showToast(context, "您现在正在通话中，无法将他人加入黑名单");
          return;
        }

        // 正常流程
        BaseViewModel.popPage(context);
        showBlockDialog();
      },
    );
  }

  List<ImageProvider> _avatarAndAlbumImageProviders() {
    List<ImageProvider> returnList = [];

    if (_memberInfo != null) {
      //First: Avatar.
      if (_memberInfo!.avatarPath != null &&
          _memberInfo!.avatarPath!.isNotEmpty) {
        returnList.add(CachedNetworkImageProvider(
            HttpSetting.baseImagePath + _memberInfo!.avatarPath!));
      } else {
        returnList.add(AssetImage(_defaultAvatarFilePath(_memberInfo!.gender)));
      }

      //And: AlbumPaths
      if (_memberInfo!.albumsPath != null) {
        for (AlbumsPathInfo albumsPathInfo in _memberInfo!.albumsPath!) {
          if (albumsPathInfo.filePath != null &&
              albumsPathInfo.filePath!.isNotEmpty) {
            returnList.add(CachedNetworkImageProvider(
                HttpSetting.baseImagePath + albumsPathInfo.filePath!));
          }
        }
      }
    }

    return returnList;
  }

  // 用戶相冊
  Widget _buildAvatarPhotoView() {
    List<ImageProvider> imageProviders = _avatarAndAlbumImageProviders();

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () {
          // Open the ImageLinksViewer
          ImageLinksViewer.show(
            context,
            ImageLinksViewerArgs(
              imageLinks: imageProviders,
              initialPage: viewModel.currentPageIndex
            )
          );
        },
        child: PhotoViewGallery.builder(
          backgroundDecoration: const BoxDecoration(color: Colors.transparent),
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              //Check if the link has already been downloaded. (has a fullImageRawInfo data)
              imageProvider: imageProviders[index],
              initialScale: PhotoViewComputedScale.covered,
              tightMode: true,
              minScale: PhotoViewComputedScale.covered,
              maxScale: PhotoViewComputedScale.covered,
              disableGestures: true,
            );
          },
          itemCount: imageProviders.length,
          loadingBuilder: (context, event) => Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null ||
                        event.expectedTotalBytes == null ||
                        event.expectedTotalBytes == 0
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
          pageController: viewModel.photoViewPageController,
          onPageChanged: viewModel.onPhotoViewerPageChanged,
        ),
      ),
    );
  }

  // 在線狀態
  Widget onlineStatus() {

    if (viewModel.isOnline == 0) return const SizedBox();

    return Positioned(
      bottom: 64,
      right: 16,
      child: IconTag.online(),
    );
  }

  // 照片頁籤狀態指示(畫面上灰色長條)
  Widget _buildPhotoTabIndication() {
    List<ImageProvider> imageProviders = _avatarAndAlbumImageProviders();

    return Positioned(
      top: MediaQuery.of(context).viewPadding.top,
      left: 15,
      child: SizedBox(
        height: 4,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: imageProviders.length,
          itemBuilder: (context, index) {
            return Container(
              width: (MediaQuery.of(context).size.width - 30) /
                  imageProviders.length,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                color: index == viewModel.currentPageIndex
                    ? const Color.fromRGBO(255, 255, 255, 0.8)
                    : const Color.fromRGBO(255, 255, 255, 0.3),
              ),
              margin: const EdgeInsets.only(right: 3),
            );
          },
        ),
      ),
    );
  }



  Widget _chatButton(){
    return CommonButton(
        btnType: CommonButtonType.text_icon,
        cornerType: CommonButtonCornerType.circle,
        isEnabledTapLimitTimer: false,
        height: 48.h,
        colorBegin: appBoxDecorationTheme.userInfoViewChatBtnBoxDecoration.gradient?.colors[0],
        colorEnd: appBoxDecorationTheme.userInfoViewChatBtnBoxDecoration.gradient?.colors[1],
        // colorBegin: AppColors.btnDeepBlue,
        // colorEnd: AppColors.btnSkyBlue,
        text: '私聊',
        textStyle: TextStyle(
          color: AppColors.mainWhite,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        iconWidget: ImgUtil.buildFromImgPath(appImageTheme.iconChat, size: 24),
        onTap: () {
          _goChatRoomPage();
        });
  }

  Widget _strikeUpButton(String title) {
    return CommonButton(
        btnType: CommonButtonType.text_icon,
        cornerType: CommonButtonCornerType.circle,
        margin: EdgeInsets.zero,
        isEnabledTapLimitTimer: false,
        height: 48.h,
        colorBegin: appBoxDecorationTheme.userInfoViewStrikeBtnBoxDecoration.gradient?.colors[0],
        colorEnd: appBoxDecorationTheme.userInfoViewStrikeBtnBoxDecoration.gradient?.colors[1],
        text: title,
        textStyle: appTextTheme.buttonPrimaryTextStyle,
        iconWidget: ImgUtil.buildFromImgPath(appImageTheme.iconStrikeUp, size: 24),
        onTap: () {
          // 真人認證彈窗
          final gender = ref.read(userInfoProvider).memberInfo!.gender;
          final realPersonAuth =
              ref.read(userInfoProvider).memberInfo!.realPersonAuth;
          final realNameAuth =
              ref.read(userInfoProvider).memberInfo!.realNameAuth;
          final CertificationType personAuthType =
              CertificationModel.getType(authNum: realPersonAuth);
          final CertificationType nameAuthType =
              CertificationModel.getType(authNum: realNameAuth);

          // 女生必須 真人與實名認證 才可搭訕
          if (gender == 0) {
            if (personAuthType == CertificationType.done &&
                nameAuthType == CertificationType.done) {
              _strikeUp(true);
            } else {
              DialogUtil.popupRealPersonDialog(theme:_theme,context: context, description: '您还未通过真人认证与实名认证，认证完毕后方可传送心动 / 搭讪');

            }
          } else {
            _strikeUp(true);
          }
        });
  }

  Widget _editPersonalInfoButton(){

    Border? border = appBoxDecorationTheme.userInfoViewEditBtnBoxDecoration.border as Border?;


    return CommonButton(
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.circle,
        margin: EdgeInsets.zero,
        isEnabledTapLimitTimer: false,
        height: 48.h,
        colorBegin: appBoxDecorationTheme.userInfoViewEditBtnBoxDecoration.color,
        colorEnd: appBoxDecorationTheme.userInfoViewEditBtnBoxDecoration.color,
        broder: border,
        text: '编辑个人资料',
        textStyle: TextStyle(color: appColorTheme.userInfoViewEditTextColor, fontSize: 14, fontWeight: FontWeight.w500),
        onTap: () => BaseViewModel.pushPage(context, const PersonalEdit())
    );
  }

  _goChatRoomPage() {

    ///當頁面是由『聊天室』開啟，需前往聊天室時，是執行返回，而非開啟新頁
    if(widget.displayMode == DisplayMode.chatMessage){
      BaseViewModel.popPage(context);
      BaseViewModel.popPage(context);
      return;
    }
    // 更新資料 start
    final List<ChatUserModel> chatUserModelList = ref.watch(chatUserModelNotifierProvider);
    final ChatUserModel currentChatUserModel = chatUserModelList.firstWhere((info) {
      return info.userId == _searchListInfo?.userId;
    });
    SearchListInfo? updateSearchListInfo = transferChatUserModelToSearchListInfo(currentChatUserModel);
    _searchListInfo = updateSearchListInfo;
    // 更新資料 end

    if (_searchListInfo != null) {
      BaseViewModel.pushPage(context, ChatRoom(unRead: 0, searchListInfo: _searchListInfo));
    } else {
      //Todo: 目前有這問題，搭訕過後近來無法私聊
      // CheckDialog.show(context, titleText: '錯誤', messageText: '_searchListInfo not exist!');
    }
  }

  String _defaultAvatarFilePath(num? gender) {

    return gender == 0
      ? appImageTheme.defaultFemaleAvatar
      : appImageTheme.defaultMaleAvatar;
  }

  // 充值彈窗
  void _showRechargeDialog() {
    // 充值次數
    final num rechargeCounts =  ref.read(userInfoProvider).memberPointCoin?.depositCount ?? 0;
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    // 如果充值次數為 0
    if (rechargeCounts == 0) {
      RechargeUtil.showFirstTimeRechargeDialog('余额不足，请先充值'); // 開啟首充彈窗
    } else {
      RechargeUtil.showRechargeBottomSheet(theme: theme); // 開啟充值彈窗
    }
  }

  // 親密度彈窗
  showCohesionDialog() {
    CommDialog(context).build(
      theme: _theme,
      title: '温馨提示',
      contentDes: '双方亲密度需要达到2级才可以开启视频和语音通话功能。给对方聊天和送礼可以快速提升亲密度～',
      rightBtnTitle: '去聊天',
      rightAction: () {
        BaseViewModel.popPage(context);
        _goChatRoomPage();
      },
    );
  }

  // 黑名單彈窗
  showBlockDialog() {
    CommDialog(context).build(
      theme: _theme,
      title: '提示',
      contentDes: '拉黑后，你将不再收到对方的消息，并且你们互相看不到对方的动态更新，可以在 "设置 - 黑名单" 中解除。',
      leftBtnTitle: '取消',
      rightBtnTitle: '确定',
      leftAction: () => BaseViewModel.popPage(context),
      rightAction: () async {
        final num roomId = _searchListInfo?.roomId ?? 0;
        String? resultCodeCheck;
        await viewModel.wsNotificationLeaveGroupBlock(
            roomId: roomId,
            onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
            onConnectFail: (errMsg) {
              BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
            });
        if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
          viewModel.insertBlockInfoToSqfLite(_searchListInfo!);
          if(context.mounted) {
            BaseViewModel.popPage(context);
            BaseViewModel.popPage(context);
            BaseViewModel.popPage(context);
            BaseViewModel.popPage(context);
            BaseViewModel.showToast(context, '已将对方拉黑！');
          }
        }
      }
    );
  }

  // 搭訕常用語
  _sendPickUpPhrases(SearchListInfo searchInfo) async {
    String data = await rootBundle.loadString('assets/txt/strike_up_list_pick_up_phrases.txt');
    List<String> list = const LineSplitter().convert(data);
    Random random = Random();
    // Api 3-1
    chatRoomViewModel.sendTextMessage(searchListInfo: searchInfo, message: list[random.nextInt(list.length)], contentType: 3);
  }

  // 心動常用語
  _sendCommonPhrases(SearchListInfo searchInfo) async {
    // String data = await rootBundle.loadString('assets/txt/strike_up_list_common_phrases.txt');
    // List<String> list = const LineSplitter().convert(data);
    // Random random = Random();
    // // Api 3-1
    // chatRoomViewModel.sendTextMessage(searchListInfo: searchInfo, text: list[random.nextInt(list.length)], contentType: 3, unRead: 0);


    // http://redmine.zyg.com.tw/issues/1536
    /// 判斷是否有招呼與設置
    final List<GreetModuleInfo> greetList = ref.read(userInfoProvider).greetModuleList?.list ?? [];
    ChatRoomViewModel viewModel = ChatRoomViewModel(ref: ref, setState: setState, context: context);

    final girlGreet = greetList.where((greet) {
      final authType = CertificationModel.getGreetType(authNum: greet.status ?? 0);
      return CertificationType.using == authType;
    }).toList();

    /// 無設置招呼語
    if (girlGreet.isEmpty) {
      String data = await rootBundle.loadString('assets/txt/strike_up_list_common_phrases.txt');
      List<String> list = const LineSplitter().convert(data);
      Random random = Random();
      // Api 3-1
      viewModel.sendTextMessage(searchListInfo: searchInfo, message: list[random.nextInt(list.length)],
        isStrikeUp: true, contentType: 3);
      insertToChatUserDb(searchInfo, list[random.nextInt(list.length)]);
      return;
    }

    String recentlyMessage = '';

    /// 待補上
    if (girlGreet.first.greetingPic != null) {
      viewModel.sendImageMessage(searchListInfo: searchInfo, unRead: 1, isStrikeUp: true, imgUrl: girlGreet.first.greetingPic);
      recentlyMessage = '[图片]';
    }
    if (girlGreet.first.greetingText != null) {
      viewModel.sendTextMessage(searchListInfo: searchInfo, message: girlGreet.first.greetingText, isStrikeUp: true);
      recentlyMessage = girlGreet.first.greetingText!;
    }
    if (girlGreet.first.greetingAudio != null) {
      viewModel.sendVoiceMessage(searchListInfo: searchInfo, unRead: 1, isStrikeUp: true, audioUrl: girlGreet.first.greetingAudio?.filePath);
      recentlyMessage = '[录音]';
    }
    insertToChatUserDb(searchInfo, recentlyMessage);
  }
}

//將ChatUserModel轉成SearchListInfo
SearchListInfo? transferChatUserModelToSearchListInfo(ChatUserModel chatUserModel){
  SearchListInfo? searchListInfo;
  if (chatUserModel != null) {
    searchListInfo = SearchListInfo(
      roomId: chatUserModel.roomId,
      roomName: chatUserModel.roomName,
      roomIcon: chatUserModel.roomIcon,
      userCount: chatUserModel.userCount,
      cohesionLevel: chatUserModel.cohesionLevel,
      points: chatUserModel.points,
      isOnline: chatUserModel.isOnline,
      userName: chatUserModel.userName,
      userId: chatUserModel.userId,
      remark: chatUserModel.remark,
    );
  }
  return searchListInfo;
}


//
class FullScreen extends StatelessWidget {
  final Image image;

  const FullScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Center(child: image));
  }
}


