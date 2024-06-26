
import 'dart:convert';
import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/screens/common_language.dart';
import 'package:frechat/screens/friend_setting/friend_setting_page.dart';
import 'package:frechat/screens/image_links_viewer.dart';
import 'package:frechat/system/assets_path/assets_images_path.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/chat_message_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/audio_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/util/svga_player_util.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/widgets/chat_message/chat_message.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/main_textfield.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/strike_up_list/top_bottom_pull_loader.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../widgets/shared/dialog/check_dialog.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:vibration/vibration.dart';

class ChatRoom extends ConsumerStatefulWidget {
  final SearchListInfo? searchListInfo;
  final num? unRead;
  final bool? isSystem;
  const ChatRoom(
      {Key? key, this.searchListInfo, this.unRead, this.isSystem = false})
      : super(key: key);

  @override
  ConsumerState<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends ConsumerState<ChatRoom> with TickerProviderStateMixin, AfterLayoutMixin{
  // 使用 FocusNode 來監聽鍵盤的顯示和隱藏，並執行對應的操作
  final FocusNode focusNode = FocusNode();
  List<String> stringList = [];
  bool doNotShowEmoji = true;
  String iconMicImagePath = "assets/images/icon_mic_not_recording.png";
  bool isRecording = false;
  late ChatRoomViewModel viewModel;
  String roomName = '';
  bool showPicture = true;
  List<ChatUserModel> _userModelList = [];

  // 0: 尚未錄音 - Not Recording
  // 1: 準備錄音 - Ready to Record
  // 2: 正在錄音 - Recording
  // 3: 錄音完成 - Recording Completed
  int micStatus = 0;
  bool isInputTextFilled = false;

  // 語音 index
  ValueNotifier<int?> currentAudioIndexNotifier = ValueNotifier(null);

  // 語音路徑
  ValueNotifier<String> currentAudioUrlNotifier = ValueNotifier('');

  late AppTheme _theme;
  late AppColorTheme appColorTheme;
  late AppImageTheme appImageTheme;
  late AppTextTheme appTextTheme;
  late AppLinearGradientTheme appLinearGradientTheme;
  bool? _isOnScrollBottom = true;


  void micStatusHandler(status) {
    micStatus = status;
  }

  // 審核開關
  bool showCallType = false; // 通話
  bool showIntimacyType = false; // 3. 亲密度
  bool showBlockType = false; // 10. 審核中

  @override
  void initState() {
    viewModel = ChatRoomViewModel(ref: ref, setState: setState, context: context, tickerProvider: this);
    _init();
    // ZIMService.deleteMessage(conversationID: widget.oppositeUserName!);
    if (widget.searchListInfo!.roomName != null && widget.searchListInfo!.roomName!.isNotEmpty) {
      roomName = widget.searchListInfo?.roomName ?? '';
    } else {
      roomName = widget.searchListInfo?.userName ?? '';
    }
    if (widget.searchListInfo!.remark != null) {
      if (widget.searchListInfo!.remark!.isNotEmpty) {
        roomName = widget.searchListInfo!.remark!;
      }
    }
    SvgaPlayerUtil.init(this);
    super.initState();
    getMessageTabList();

    showCallType = ref.read(userInfoProvider).buttonConfigList?.callType == 1 ? true : false;
    showIntimacyType = ref.read(userInfoProvider).buttonConfigList?.intimacyType == 1 ? true : false;
    showBlockType = ref.read(userInfoProvider).buttonConfigList?.blockType == 1 ? true : false;

    // 輸入框監聽器
    viewModel.textEditingController?.addListener(() {
      print('KeyBord addListener');
      final text = viewModel.textEditingController?.text ?? '';
      String inputText = text.trim();
      setState(() => isInputTextFilled = inputText.isNotEmpty);
      if (!isInputTextFilled) setState(() => micStatus = 0);
    });

    // 語音監聽器
    currentAudioIndexNotifier.addListener(() {
      int? updateIndex = currentAudioIndexNotifier.value;
      if (updateIndex == null) {
        AudioUtils.stopPlaying();
      } else {
        AudioUtils.startPlayingFromUrl(
            audioUrl: currentAudioUrlNotifier.value,)
            .then((value) {
          currentAudioIndexNotifier.value = null;
        });
      }
    });

    viewModel.scrollController.addListener(() {
      ///監聽ScrollView現在是否在最底部
      if (viewModel.scrollController.position.pixels == viewModel.scrollController.position.maxScrollExtent) {
        _isOnScrollBottom = true;
      }else{
        _isOnScrollBottom = false;
      }
    });
  }

  @override
  void afterFirstLayout(BuildContext context) async {
   // if(Platform.isIOS){
   //   BaseViewModel.showToast(context, '长按文字讯息可检视原文"');
   // }
  }

  void getMessageTabList() {
    final chatUserModel = ref.read(chatUserModelNotifierProvider);
    final chatBlockModel = ref.read(chatBlockModelNotifierProvider);
    final list = chatUserModel.where((info) => info.userName == 'java_system').toList();

    /// 判斷 最新訊息不為空 && 是否為blockUser
    _userModelList = chatUserModel.where((info) {
      final bool isNotEmpty = info.recentlyMessage?.isNotEmpty ?? false;

      /// 檢查 黑名單內用戶與列表內做比對移除、當chatBlockModel則直接給予true過
      final bool isNotBlock = chatBlockModel
              .any((blockUser) => blockUser.userName != info.userName) ||
          chatBlockModel.isEmpty;
      return isNotEmpty && isNotBlock;
    }).toList();
    _userModelList = viewModel.sortChatUserstest(_userModelList);
  }

  @override
  void deactivate() {
    final UserNotifier userUtil = ref.read(userUtilProvider.notifier);
    userUtil.setDataToPrefs(currentChatUser: '');
    userUtil.setDataToPrefs(currentPage: 0);
    userUtil.setDataToPrefs(isInChatroom: false);
    super.deactivate();
  }

  @override
  void dispose() {
    viewModel.dispose();
    if (ChatRoomViewModel.animationController != null) {
      ChatRoomViewModel.animationController?.dispose();
      ChatRoomViewModel.animationController = null;
    }

    AudioUtils.stopPlaying();
    viewModel.scrollController.dispose();
    super.dispose();
  }

  _init() async {
    viewModel.initTickerProvider();
    viewModel.init(widget.searchListInfo!.points ?? 0, widget.searchListInfo!.cohesionLevel ?? 0,widget.searchListInfo!.userName??'');
    // viewModel.listenerZimCallBack(oppositeUserName:widget.searchListInfo!.userName!);
    if (!widget.isSystem!) {
      viewModel.getCohesionPointsRule();
      await viewModel.initUserInfo(widget.searchListInfo!.userName!);
      viewModel.getCommonLanguage();
    }
    viewModel.readAllMessage(widget.searchListInfo!.userName!);
    await viewModel.getHistoryMessage(widget.searchListInfo!.userName!,
        searchListInfo: widget.searchListInfo!);

    viewModel.tidyMessage(widget.searchListInfo!.userName!);

    // animationController = SVGAAnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    _theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = _theme.getAppColorTheme;
    appImageTheme =_theme.getAppImageTheme;
    appTextTheme = _theme.getAppTextTheme;
    appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    return MainScaffold(
        isFullScreen: false,
        needSingleScroll: false,
        resizeToAvoidBottomInset: true,
        backgroundColor: appColorTheme.baseBackgroundColor,
        padding: EdgeInsets.only(top: paddingHeight),
        appBar: _buildAppBar(),
        child:GestureDetector(
          onTap: () {
            // 點擊空白處時，取消焦點
            if(focusNode.hasFocus){
              focusNode.unfocus();
            }
            viewModel.timeDistinctionList.clear();
            if (!doNotShowEmoji) {
              doNotShowEmoji = true;
              setState(() {});
            }

            ///判斷如果不是在最底，點擊空白處會刷新頁面
            if(_isOnScrollBottom == false){
              viewModel.scrollToEnd();
              viewModel.scrollController.animateTo(
                viewModel.scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }

          },
          child: (widget.isSystem! && showBlockType)
              ? SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 2.165,
              child: ImgUtil.buildFromImgPath(
                  'assets/mock/official_messages.png'),
            ),
          )
              : Consumer(
            builder:
                (BuildContext context, WidgetRef ref, Widget? child) {
              final allChatMessageModelList = ref.watch(chatMessageModelNotifierProvider);

              // 自己的訊息列表
              final mySendChatMessageList =
              allChatMessageModelList.where((info) {
                final senderName = info.senderName;
                final receiverName = info.receiverName;
                final userName =
                    ref.read(userInfoProvider).memberInfo?.userName;
                final searchUserName = widget.searchListInfo?.userName;
                return senderName == userName &&
                    receiverName == searchUserName;
              }).toList();

              // 對方的訊息列表
              final oppoSiteSendChatMessageList =
              allChatMessageModelList.where((info) {
                final senderName = info.senderName;
                final receiverName = info.receiverName;
                final searchUserName = widget.searchListInfo?.userName;
                final userName =
                    ref.read(userInfoProvider).memberInfo?.userName;
                return senderName == searchUserName &&
                    receiverName == userName;
              }).toList();

              // 根據時間重新排列訊息
              List<ChatMessageModel> chatMessageModelList = viewModel.sortChatMessages(mySendChatMessageList, oppoSiteSendChatMessageList);
              return FocusDetector(
                onFocusGained: () {
                  ref.read(userUtilProvider.notifier).setDataToPrefs(currentPage: 1);
                  ref.read(userUtilProvider.notifier).setDataToPrefs(isInChatroom: true);
                  ref.read(userUtilProvider.notifier).setDataToPrefs(
                      currentChatUser: widget.searchListInfo?.userName);
                  viewModel.timeDistinctionList.clear();
                },
                child: Stack(
                  children: [
                    Container(
                      color: appColorTheme.baseBackgroundColor,
                      child: Column(
                        children: [
                          Flexible(
                              fit: FlexFit.tight,
                              child: mainWidget(chatMessageModelList)),
                          // 使用 FutureBuilder 來等待 _getCommonLanguage() 完成
                          Visibility(
                            visible: widget.isSystem == false,
                            child: commomLanguageRowWidget(),
                          ),

                          Visibility(
                            visible: widget.isSystem == false,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: AppColors.mainWhite,
                              child: Column(
                                children: [
                                  textFieldAndRecordWidget(),
                                  functionRowWidget()
                                ],
                              ),
                            ),
                          ),
                          //emoji鍵盤
                          emojiKeyBoard(),
                          //底部兼具，鍵盤初時不顯示
                          Visibility(
                            visible:focusNode.hasFocus ==false,
                            child: Container(height: WidgetValue.bottomPadding,color: AppColors.mainWhite,),
                          ),

                        ],
                      ),
                    ),
                    (widget.isSystem!) ? Container() : intimacyWidget(),
                    Positioned(
                        right: 10.w,
                        bottom: 200.h,
                        child: InkWell(
                          child: Image(
                            width: 32.w,
                            height: 24.w,
                            image: const AssetImage(
                                'assets/images/icon_nextroom.png'),
                          ),
                          onTap: () {
                            int index = 0;
                            for (int i = 0; i < _userModelList.length; i++) {
                              if (_userModelList[i].userName ==
                                  widget.searchListInfo!.userName) {
                                index = i;
                                break;
                              }
                            }
                            int listLength = _userModelList.length - 1;
                            if (index == listLength) {
                              index = 0;
                            } else {
                              index++;
                            }

                            SearchListInfo? searchListInfo =
                            transferChatUserModelToSearchListInfo(
                                _userModelList[index]);
                            if (searchListInfo!.userName ==
                                'java_system') {
                              BaseViewModel.pushReplacement(
                                  context,
                                  ChatRoom(
                                      searchListInfo: searchListInfo,
                                      isSystem: true));
                            } else {
                              BaseViewModel.pushReplacement(
                                  context,
                                  ChatRoom(
                                      searchListInfo: searchListInfo));
                            }
                          },
                        )),
                    SVGAImage(SvgaPlayerUtil.animationController!),
                    // (animationController !=null)?SVGAImage(animationController!):
                    // Container(),
                    // SVGASimpleImage(resUrl: 'https://pic.gscjcplive.com/gift/4/giftSvga1694628129.svga'),
                  ],
                ),
              );
            },
          )),
    );
  }

  //將ChatUserModel轉成SearchListInfo
  SearchListInfo? transferChatUserModelToSearchListInfo(
      ChatUserModel chatUserModel) {
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
  _buildAppBar(){
    return MainAppBar(
      theme: _theme,
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
        title: '',
        titleWidget: _buildAppBarTitle(),
        backgroundColor: appColorTheme.appBarBackgroundColor,
        onTapLeading: (){
          viewModel.timeDistinctionList.clear();
        },
        actions: (widget.isSystem!)
            ? []
            : [
              GestureDetector(
          child: (viewModel.messageLoading)
              ? const SizedBox()
              : Container(
            // margin: EdgeInsets.only(right: 4.w),
            padding: EdgeInsets.all(16),
            child: Image(
              color: appColorTheme.iconFriendsettingColor,
              image: const AssetImage(
                  'assets/images/icon_friendsetting.png'),
            )),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendSettingPage(
                    oppositeUserName:
                    widget.searchListInfo!.userName!,
                    oppositeUserID: widget.searchListInfo!.userId!,
                    roomId: widget.searchListInfo!.roomId!,
                    searchListInfo: widget.searchListInfo!,
                    roomName: roomName),
              ),
            );
            if (result != null) {
              viewModel.timeDistinctionList.clear();
              setState(() {
                roomName = result;
              });
            }
          },
        )
        ]);
  }


  _buildAppBarTitle() {
    return Consumer(builder: (context, ref, _) {
      final List<ChatUserModel> chatUserModels = ref.watch(chatUserModelNotifierProvider);
      final String otherUserName = widget.searchListInfo?.userName ?? '';
      final ChatUserModel model = chatUserModels.firstWhere((info) => info.userName == otherUserName);
      final String name = (model.remark == null || model.remark == '')
          ? model.roomName ?? ''
          : model.remark ?? '';
      return Text(
        name,
        style: appTextTheme.appbarTextStyle,
      );
    });
  }

  //主要畫面
  Widget mainWidget(List<ChatMessageModel> chatMessageModelList) {
    viewModel.timeDistinctionList.clear();

    return TopBottomPullLoader(
        enableFetchMore: false,
        onRefresh: () => viewModel.getHistoryMessage(widget.searchListInfo!.userName!, searchListInfo: widget.searchListInfo!),
        onFetchMore: () {  },
        child: Container(
          color: appColorTheme.baseBackgroundColor,
          child:  SingleChildScrollView(
              controller: viewModel.scrollController,
              child: Column(
                children: [
                  Visibility(visible: widget.isSystem! == false, child: announcementWidget()),
                  Visibility(visible: widget.isSystem! == false, child: _friendInformationWidget()),
                  ListView.builder(
                    key:  Key( Uuid().v4()),
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true, // 让 ListView 根据内容自适应高度
                    physics: const NeverScrollableScrollPhysics(), // 禁止ListView滚动
                    itemCount: chatMessageModelList.length,
                    itemBuilder: (context, index) {
                      viewModel.scrollToEnd();
                      bool isShowGiftSvga = false;
                      if (chatMessageModelList[index].type == 3 && index == chatMessageModelList.length - 1) {
                        List<ZIMMessage> zimMessageQueriedResultList = viewModel.zimMessageQueriedResult?.messageList ?? [];
                        for (int i = 0; i < zimMessageQueriedResultList.length; i++) {
                          if (zimMessageQueriedResultList[i].type == ZIMMessageType.text) {
                            ZIMTextMessage? zimTextMessage = zimMessageQueriedResultList[i] as ZIMTextMessage?;
                            Map<String, dynamic> messageDataMap = {};
                            messageDataMap = json.decode(zimTextMessage!.message) as Map<String, dynamic>;
                            String uuid = messageDataMap['uuid'];
                            if (uuid == chatMessageModelList[index].messageUuid) {
                              if (zimTextMessage.receiptStatus != ZIMMessageReceiptStatus.done) {
                                isShowGiftSvga = true;
                              }
                            }
                          }
                        }
                      }

                      final ZIMMessage zimMessage = viewModel.transferToZimMessage(chatMessageModelList[index], isShowGiftSvga);
                      if (zimMessage.extendedData.isEmpty) {
                        return Container();
                      } else {
                        if (index == chatMessageModelList.length - 1) {
                          return bubbleMessage(zimMessage, index, true, chatMessageModelList);
                        } else {
                          return bubbleMessage(zimMessage, index, false, chatMessageModelList);
                        }
                      }
                    },
                  ),
                ],
              )),
        ));
  }

  //對話框
  Widget bubbleMessage(ZIMMessage zimMessage, int index, bool isLast, List<ChatMessageModel> chatMessageModelList) {
    ChatMessageModel model = chatMessageModelList[index];
    int status = model.sendStatus?.toInt() ?? 1;
    ChatMessageStatus chatMessageSendStatus = ChatMessageStatus.values[status];
    if(model.reviewStatus == 1){
      chatMessageSendStatus = ChatMessageStatus.reviewFail;
    }

    String messageTime = viewModel.formatDateTime(
        DateTime.fromMillisecondsSinceEpoch(zimMessage!.timestamp));
    bool showTimeDistinction = true;
    if (viewModel.timeDistinctionList.contains(messageTime) == true) {
      showTimeDistinction = false;
    }
    num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;


    if (zimMessage.senderUserID == widget.searchListInfo!.userName!) {
      if (viewModel.timeDistinctionList.contains(messageTime) == false) {
        viewModel.timeDistinctionList.add(messageTime);
      }
      return (isLast && viewModel.needShowCharmCharge && gender == 1)
          ? Column(
              children: [
                ChatMessage(
                  zimMessage: zimMessage,
                  isMe: false,
                  memberInfo: viewModel.memberInfoRes,
                  searchListInfo: widget.searchListInfo,
                  avatar: widget.searchListInfo!.roomIcon ?? "",
                  viewModel: viewModel,
                  index: index,
                  showTimeDistinction: showTimeDistinction,
                  currentAudioIndexNotifier: currentAudioIndexNotifier,
                  currentAudioUrlNotifier: currentAudioUrlNotifier,
                  chatMessageModelList: chatMessageModelList,
                  chatMessageStatus: chatMessageSendStatus,
                ),
                // charmChargeWidget()
              ],
            )
          : ChatMessage(
              zimMessage: zimMessage,
              isMe: false,
              memberInfo: viewModel.memberInfoRes,
              searchListInfo: widget.searchListInfo,
              avatar: widget.searchListInfo!.roomIcon ?? "",
              viewModel: viewModel,
              index: index,
              showTimeDistinction: showTimeDistinction,
              currentAudioIndexNotifier: currentAudioIndexNotifier,
              currentAudioUrlNotifier: currentAudioUrlNotifier,
              chatMessageModelList: chatMessageModelList,
              chatMessageStatus: chatMessageSendStatus,
            );
    } else {
      if (viewModel.timeDistinctionList.contains(messageTime) == false) {
        viewModel.timeDistinctionList.add(messageTime);
      }
      return (isLast && viewModel.needShowCharmCharge && gender == 1)
          ? Column(
              children: [
                ChatMessage(
                  zimMessage: zimMessage,
                  isMe: true,
                  viewModel: viewModel,
                  index: index,
                  searchListInfo: widget.searchListInfo,
                  showTimeDistinction: showTimeDistinction,
                  currentAudioIndexNotifier: currentAudioIndexNotifier,
                  currentAudioUrlNotifier: currentAudioUrlNotifier,
                  chatMessageModelList: chatMessageModelList,
                  chatMessageStatus: chatMessageSendStatus,
                ),
                // charmChargeWidget()
              ],
            )
          : ChatMessage(
              zimMessage: zimMessage,
              isMe: true,
              viewModel: viewModel,
              index: index,
              searchListInfo: widget.searchListInfo,
              showTimeDistinction: showTimeDistinction,
              currentAudioIndexNotifier: currentAudioIndexNotifier,
              currentAudioUrlNotifier: currentAudioUrlNotifier,
              chatMessageModelList: chatMessageModelList,
              chatMessageStatus: chatMessageSendStatus,
            );
    }
  }

  Widget charmChargeWidget() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
        alignment: Alignment(0, 0),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.05),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Row(
          children: [
            Image(
                width: 13.34.w,
                height: 13.34.h,
                image:
                    const AssetImage('assets/images/icon_exclamationmark.png')),
            Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Text("温馨提醒，发信息需消耗" + viewModel.textCharge + '金币/则',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.mainDark)))
          ],
        ));
  }

  //退回金幣訊息
  Widget returnCoinHintWidget(String text) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 68.5.w, vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 13.33.w, vertical: 11.33.h),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.05),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Row(
          children: [
            Image(
              width: 13.34.w,
              height: 13.34.h,
              image: const AssetImage('assets/images/icon_hint.png'),
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mainDark),
            )
          ],
        ));
  }

  //常用語數組滾動列
  Widget commomLanguageRowWidget() {
    return Container(
      height: 48.h,
      child: CustomList.separatedList(
        scrollDirection: Axis.horizontal,
        separator: const SizedBox(
          width: 0,
        ),
        childrenNum: viewModel.commonLanguageList.length,
        children: (context, index) {
          return commonLanguageButtonWidget(
              viewModel.commonLanguageList[index]);
        },
      ),
    );
  }

  // emoji鍵盤
  Widget emojiKeyBoard() {
    return Offstage(
      offstage: doNotShowEmoji,
      child: SizedBox(
          height: 250,
          child: EmojiPicker(
            textEditingController: viewModel.textEditingController,
            config: Config(
              columns: 7,
              emojiSizeMax: 32 *
                  (foundation.defaultTargetPlatform == TargetPlatform.iOS
                      ? 1.30
                      : 1.0),
              verticalSpacing: 0,
              horizontalSpacing: 0,
              gridPadding: EdgeInsets.zero,
              initCategory: Category.RECENT,
              bgColor: const Color(0xFFF2F2F2),
              indicatorColor: Colors.blue,
              iconColor: Colors.grey,
              iconColorSelected: Colors.blue,
              backspaceColor: Colors.blue,
              skinToneDialogBgColor: Colors.white,
              skinToneIndicatorColor: Colors.grey,
              enableSkinTones: true,
              recentTabBehavior: RecentTabBehavior.RECENT,
              recentsLimit: 28,
              replaceEmojiOnLimitExceed: false,
              noRecents: const Text(
                'No Recents',
                style: TextStyle(fontSize: 20, color: Colors.black26),
                textAlign: TextAlign.center,
              ),
              loadingIndicator: const SizedBox.shrink(),
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL,
              checkPlatformCompatibility: true,
            ),
          )),
    );
  }

  // 亲密度愛心顯示圖 Icon
  Widget intimacyWidget() {
    if (!showIntimacyType) return const SizedBox();
    return Positioned(
        top: 4.h,
        right: 8.w,
        child: GestureDetector(
          onTap: () => viewModel.showIntimacyDialog(widget.searchListInfo!.roomIcon),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildIntimacyLevelWidget(),
              Container(
                height: 16.w,
                alignment: const Alignment(0, 0),
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: viewModel.cohesionColor ?? Colors.transparent),
                  color: Colors.white,
                  borderRadius:
                  const BorderRadius.all(Radius.circular(48.0)),
                ),
                child: Text(
                  '${double.parse(viewModel.cohesionPoints.toStringAsFixed(1))}°C',
                  style: TextStyle(
                      fontSize: 10.sp, color: viewModel.cohesionColor ?? Colors.transparent),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildIntimacyLevelWidget() {
    String cohesionName =  viewModel.getCohesionName(viewModel.nowIntimacy);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 6, left: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: viewModel.intimacyLevelBgColor,
              stops: const [0.3265, 0.7491],
              transform: const GradientRotation(269.71),
            ),
          ),
          // width: nameWidth,
          height: 16,
          child: Text('$cohesionName',
            style: const TextStyle(color: Color(0xffFFFFFF), fontSize: 10, fontWeight: FontWeight.w500, height: 0.1),
          ),
        ),
        Positioned(
          top: -6,
          left: 0,
          child: ImgUtil.buildFromImgPath(viewModel.cohesionImagePath, size: 28),
        )
      ],
    );
  }

  //常用語按鈕
  Widget commonLanguageButtonWidget(String content) {
    return CommonButton(
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.circle,
        margin: EdgeInsets.only(left: 8.w, top: 8.h, bottom: 8.h),
        padding: EdgeInsets.only(top: 5.h, bottom: 5.h, right: 10.w, left: 10.w),
        isEnabledTapLimitTimer: true,
        colorBegin: appLinearGradientTheme.commonLanguageButtonColor.colors[0],
        colorEnd: appLinearGradientTheme.commonLanguageButtonColor.colors[1],
        colorAlignmentBegin: appLinearGradientTheme.commonLanguageButtonColor.begin,
        colorAlignmentEnd: appLinearGradientTheme.commonLanguageButtonColor.end,
        text: content,
        textStyle: appTextTheme.commonLanguageTextStyle,
        onTap: () {
          viewModel.sendTextMessage(
              searchListInfo: widget.searchListInfo,
              message: content,
              contentType: 0,);
        });
  }

  //輸入框和錄音
  Widget textFieldAndRecordWidget() {
    return Container(
        padding:  EdgeInsets.symmetric(vertical:4.h,horizontal: 10.w),
        width: double.infinity,
        height: 44.h,
        color: appColorTheme.chatRoomBottomBackgroundColor,
        child: Row(
          children: [
            micStatus == 0 ? inputTextField() : inputMicField(),
            const SizedBox(width: 7),
            isInputTextFilled ? iconTextButtonWidget() : iconMicButtonWidget()
          ],
        ));
  }

  // Text 輸入框
  Widget inputTextField() {
    return Expanded(
      child: Container(
        child: MainTextField(
          hintText: '请输入消息',
          controller: viewModel.textEditingController!,
          focusNode: focusNode,
          backgroundColor: appColorTheme.chatroomTextFieldBackGroundColor,
          radius: 99,
          fontColor: appColorTheme.chatroomTextFieldFontColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.text,
          borderEnable: false,
          contentPaddingTop:0,
          textFieldHeight: 36.h,
          vertical:0,
          onTap: ()=> viewModel.timeDistinctionList.clear(),
        ),
      ),
    );
  }

  // Text Icon
  Widget iconTextButtonWidget() {
    return GestureDetector(
      child: Image(
          width: 36.w,
          height: 36.w,
          image: AssetImage(appImageTheme.chatroomIconSend)),
      onTap: () {
        if (isInputTextFilled) {
          viewModel.sendTextMessage(
              searchListInfo: widget.searchListInfo,
              message: viewModel.textEditingController!.text,
              contentType: 0,);
          viewModel.timeDistinctionList.clear();
          setState(() => isInputTextFilled = false);
          focusNode.unfocus(); // 鍵盤隱藏
          doNotShowEmoji = true; // emoji 隱藏
        }
      },
    );
  }

  // Mic Icon
  Widget iconMicButtonWidget() {
    switch (micStatus) {
      case 0:
        iconMicImagePath = appImageTheme.chatroomIconMicNotRecording;
        break;
      case 1:
        AudioUtils.init();
        iconMicImagePath = appImageTheme.chatroomIconMicReadyToRecord;
        break;
      case 2:
        iconMicImagePath = appImageTheme.chatroomIconMicRecording;
        break;
      case 3:
        iconMicImagePath = appImageTheme.chatroomIconMicRecordingCompleted;
        break;
      default:
        break;
    }

    return GestureDetector(
      child: Image.asset(iconMicImagePath, width: 36, height: 36),
      onTap: () {
        // 您正在通话中，不可录音
        final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
        if (isPipMode) {
          BaseViewModel.showToast(context, '您正在通话中，不可录音');
          return;
        }
        setState(() {
          switch (micStatus) {
            case 0:
              micStatus = 1;
              doNotShowEmoji = true;
              break;
            case 1:
              micStatus = 0;
              break;
            case 2:
              break;
            case 3:
              micStatus = 0;
              viewModel.sendVoiceMessage(
                  searchListInfo: widget.searchListInfo,
                  unRead: widget.unRead ?? 0);
              break;
          }
        });
        viewModel.timeDistinctionList.clear();
      },
      onLongPressStart: (LongPressStartDetails longPressStartDetails) async {
        // 您正在通话中，不可录音
        final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
        if (isPipMode) {
          BaseViewModel.showToast(context, '您正在通话中，不可录音');
          return;
        }

        if (micStatus != 1) return;
        viewModel.timeDistinctionList.clear();
        setState(() => micStatus = 2);

        if (micStatus == 2) {
          Vibration.vibrate(duration: 100);
          viewModel.startRecordingTimer();
          AudioUtils.startRecording(60).then((result) {
            if (!result) {
              viewModel.recordingTimer?.cancel();
              viewModel.showMaximumRecordingDialog(
                searchListInfo: widget.searchListInfo,
                contentType: 1,
                unRead: widget.unRead,
                isVoice: true,
                micStatusCallback: (status) {
                  micStatusHandler(status);
                }
              );
            }
          });
        }
      },
      onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
        if (micStatus != 2) return;
        viewModel.timeDistinctionList.clear();
        setState(() => micStatus = 3);

        if (micStatus == 3) {
          AudioUtils.stopRecording();
          viewModel.recordingTimer?.cancel();
          if (viewModel.recordingSeconds < 1) {
            viewModel.timeDistinctionList.clear();
            setState(() {
              micStatus = 1;
              viewModel.recordingSeconds = 0;
              BaseViewModel.showToast(context, '录音时间至少需要 1 秒钟');
            });
          }
        }
      },
      onLongPressCancel: () {
        if (micStatus != 2) return;
        micStatus = 0;
        AudioUtils.stopRecording();
        viewModel.recordingSeconds = 0;
        viewModel.recordingTimer?.cancel();
        setState(() {});
      },
    );
  }

  // Mic 輸入框
  Widget inputMicField() {
    Widget micStatusWidgetHandler() {
      switch (micStatus) {
        case 0:
          return inputMicFieldNotRecording();
        case 1:
          return inputMicFieldReadyToRecord();
        case 2:
          return inputMicFieldRecording();
        case 3:
          return inputMicFieldRecordingCompleted();
        default:
          return inputMicFieldNotRecording();
      }
    }

    return Expanded(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            height: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                border: Border.all(
                  color: const Color(0xFFEAEAEA),
                  width: 1.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(99.0))),
            child: micStatusWidgetHandler()));
  }

  // inputMicFieldNotRecording
  Widget inputMicFieldNotRecording() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text('Not Recording'),
    );
  }

  // inputMicFieldReadyToRecord
  Widget inputMicFieldReadyToRecord() {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
              color: AppColors.mainDark,
              borderRadius: BorderRadius.all(Radius.circular(99.0))),
        ),
        const SizedBox(width: 4),
        const Text('0:00'),
        const SizedBox(width: 10),
        const Text('按住以开始录音')
      ],
    );
  }

  // inputMicFieldRecording
  Widget inputMicFieldRecording() {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
              gradient: AppColors.pinkLightGradientColors,
              borderRadius: BorderRadius.all(Radius.circular(99.0))),
        ),
        const SizedBox(width: 4),
        Text(viewModel.formatTime(viewModel.recordingSeconds)),
        const SizedBox(width: 10),
        const Text('录音中')
      ],
    );
  }

  // inputMicFieldRecordingCompleted
  Widget inputMicFieldRecordingCompleted() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            const SizedBox(width: 10),
            Text(viewModel.formatTime(viewModel.recordingSeconds)),
            const SizedBox(width: 10),
            ImgUtil.buildFromImgPath('assets/images/icon_waveform.png', width: 128, height: 32),
          ],
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              micStatus = 0;
              AudioUtils.stopRecording();
              viewModel.recordingSeconds = 0;
              viewModel.recordingTimer?.cancel();
            });
          },
          child: ImgUtil.buildFromImgPath('assets/images/icon_clear.png', size: 20),
        )
      ],
    );
  }

  //功能列
  Widget functionRowWidget() {

    return Container(
      height: 40.h,
      color: appColorTheme.chatRoomBottomBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CommonButton(
            btnType: CommonButtonType.icon,
            cornerType: CommonButtonCornerType.circle,
            isEnabledTapLimitTimer: false,
            iconWidget: Image(
              color: appColorTheme.chatRoomFunctionIconColor,
              width: 24.w,
              height: 24.w,
              image: const AssetImage('assets/images/icon_emoji.png'),
            ),
            onTap: () {
              viewModel.timeDistinctionList.clear();
              setState(() {
                FocusScope.of(context).requestFocus(FocusNode());
                doNotShowEmoji = false;
              });
            },
          ),
          CommonButton(
            btnType: CommonButtonType.icon,
            cornerType: CommonButtonCornerType.circle,
            isEnabledTapLimitTimer: false,
            iconWidget: Image(
              color: appColorTheme.chatRoomFunctionIconColor,
              width: 24.w,
              height: 24.w,
              image: const AssetImage('assets/images/icon_photo.png'),
            ),
            onTap: () {
              if (viewModel.cohesionLevel >= 2 || showBlockType) {
                viewModel.sendImageMessage(
                    searchListInfo: widget.searchListInfo!,
                    unRead: widget.unRead ?? 0);
              } else {
                CommDialog(context).build(
                  theme: _theme,
                  backgroundColor: appColorTheme.dialogBackgroundColor,
                  leftLinearGradient: appLinearGradientTheme.buttonSecondaryColor,
                  rightLinearGradient: appLinearGradientTheme.buttonPrimaryColor,
                  leftTextStyle: appTextTheme.buttonSecondaryTextStyle,
                  rightTextStyle: appTextTheme.buttonPrimaryTextStyle,
                  title: '温馨提示',
                  contentDes:
                  '双方亲密度需要达到2级才可以开启图片发送功能。给对方聊天和送礼可以快速提升亲密度～',
                  rightBtnTitle: '確認',
                  rightAction: () => BaseViewModel.popPage(context)
                );
              }
            },
          ),
          Visibility(
            visible: showCallType,
            child: CommonButton(
              btnType: CommonButtonType.icon,
              cornerType: CommonButtonCornerType.circle,
              isEnabledTapLimitTimer: false,
              iconWidget: Image(
                color: appColorTheme.chatRoomFunctionIconColor,
                width: 24.w,
                height: 24.w,
                image: const AssetImage('assets/images/icon_chatroom_call.png'),
              ),
              onTap: () async {
                final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
                if(isPipMode){
                  BaseViewModel.showToast(context, '您正在通话中，不可发起新通话');
                }else{
                  if (viewModel.cohesionLevel >= 2 || showBlockType) {
                    viewModel.callOrVideoBottomDialog(
                        memberInfo: viewModel.memberInfoRes!,
                        searchListInfo: widget.searchListInfo);
                    await viewModel.checkNetWorkTime();
                  } else {
                    CommDialog(context).build(
                      theme: _theme,
                      title: '温馨提示',
                      contentDes:
                      '双方亲密度需要达到2级才可以开启视频和语音通话功能。给对方聊天和送礼可以快速提升亲密度～',
                      rightBtnTitle: '去聊天',
                      rightAction: () => BaseViewModel.popPage(context)
                    );
                  }
                }
              },
            ),
          ),
          CommonButton(
            btnType: CommonButtonType.icon,
            cornerType: CommonButtonCornerType.circle,
            isEnabledTapLimitTimer: true,
            iconWidget: Image(
              color: appColorTheme.chatRoomFunctionIconColor,
              width: 24.w,
              height: 24.w,
              image: const AssetImage('assets/images/icon_gift.png'),
            ),
            onTap: () {
              viewModel.showBottomSheetGift(
                  widget.searchListInfo!, widget.unRead ?? 0);
            },
          ),
          CommonButton(
            btnType: CommonButtonType.icon,
            cornerType: CommonButtonCornerType.circle,
            isEnabledTapLimitTimer: false,
            iconWidget: Image(
              color: appColorTheme.chatRoomFunctionIconColor,
              width: 24.w,
              height: 24.w,
              image: const AssetImage('assets/images/icon_commonlanguage.png'),
            ),
            onTap: () async {
              await BaseViewModel.pushPage(context, CommonLanguage(
                  chatRoomViewModel: viewModel,
                  searchListInfo: widget.searchListInfo!,
                  unRead: widget.unRead ?? 0));
              viewModel.commonLanguageLoading = true;
              await viewModel.getCommonLanguage();
              viewModel.timeDistinctionList.clear();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  //公告
  Widget announcementWidget() {
    return Container(
      padding: EdgeInsets.only(left: 16.w),
      height: 32.h,
      color: appColorTheme.marqueeBackgroundColor,
      child: Row(
        children: [
          Image(
            width: 16.w,
            height: 16.w,
            color: appColorTheme.marqueeImageColor,
            image: const AssetImage('assets/images/icon_trumpet.png'),
          ),
          Expanded(child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: EdgeInsets.only(left: 4.w),
                child: Text(
                  "请文明聊天，严禁低俗、涉黄、涉政、诈欺行为！",
                  style: appTextTheme.marqueeTextStyle,
                ),
              )
          ))
        ],
      ),
    );
  }

  _friendInformationWidget() {
    final AnimationController expandController = viewModel.expandController ?? AnimationController(vsync: this);
    final Animation? heightAnimation = viewModel.heightAnimation;
    final bool isNullRealAuth = viewModel.memberInfoRes?.realNameAuth != 1 && viewModel.memberInfoRes?.realPersonAuth != 1;
    final bool isNullAlbum = viewModel.memberInfoRes?.albumsPath == null || viewModel.memberInfoRes!.albumsPath!.isEmpty;
    return GestureDetector(
      onTap: () => viewModel.dropDownFriendInfo(),
      child: AnimatedBuilder(
        animation: expandController,
        builder: (context, child) {
          final animateHeight = heightAnimation?.value;
          return Container(
            height: animateHeight,
            margin: EdgeInsets.all(WidgetValue.verticalPadding),
            padding: EdgeInsets.all(WidgetValue.verticalPadding),
            decoration: BoxDecoration(
              color: appColorTheme.chatroomInformationBackGroundColor,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: expandController.status == AnimationStatus.completed
                    ? _expandFriendInformationWidget()
                    : _collapseFriendInformationWidget()),
                const SizedBox(width: 10),
                Visibility(
                  visible: (!isNullRealAuth || !isNullAlbum),
                  child: expandController.status == AnimationStatus.completed
                    ? ImgUtil.buildFromImgPath(appImageTheme.chatroomIconCollapse, size: 24)
                    : ImgUtil.buildFromImgPath(appImageTheme.chatroomIconExpand, size: 24),)
              ],
            ),
          );
        },
      ),
    );
  }

  //好友訊息
  Widget _expandFriendInformationWidget() {
    final bool isRealName = viewModel.memberInfoRes?.realNameAuth == 1 ? true : false;
    final bool isRealPerson = viewModel.memberInfoRes?.realPersonAuth == 1 ? true : false;
    return Column(
      children: [
        basicInformationWidget(),
        certifiedStatusWidget(isRealName, isRealPerson),
        recentPictureWidget(),
      ],
    );
  }

  _collapseFriendInformationWidget() {
    return basicInformationWidget();
  }

  //認證狀態內容
  Widget certifiedStatusWidget(bool isRealName, bool isRealPerson) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      child: Row(
        children: [
          (isRealName || isRealPerson)?labelTitleWidget(appImageTheme.certificationStatusIcon, "认证状态"):Container(),
          (isRealName)
              ? labelContentWidget(
              "assets/images/icon_realname.png",
              '实名认证',
              appLinearGradientTheme.chatroomRealNameTagColor,
              8)
              : Container(),
          (isRealPerson)
              ? labelContentWidget(
              "assets/images/icon_realperson.png",
              '真人认证',
              appLinearGradientTheme.chatroomRealPersonTagColor,
              4)
              : Container(),
        ],
      ),
    );
  }

  //認證標題
  Widget labelTitleWidget(String image, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          width: 16.w,
          height: 16.w,
          image: AssetImage(image),
        ),
        Container(
          margin: EdgeInsets.only(left: 2.w),
          child: Text(
            title,
            style: appTextTheme.chatroomFriendInformationTitleTextStyle,
          ),
        )
      ],
    );
  }

  //認證標籤
  Widget labelContentWidget(String image, String title,LinearGradient linearGradient, double marginLeft) {
    return Container(
      margin: EdgeInsets.only(left: marginLeft),
      padding: EdgeInsets.only(right: 6.w, left: 4.w, top: 1.h, bottom: 1.h),
      decoration: BoxDecoration(
        gradient: linearGradient,
        borderRadius: const BorderRadius.all(Radius.circular(48)),
      ),
      child: Row(
        children: [
          Image(
            width: 14.w,
            height: 14.w,
            image: AssetImage(image),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  //基本訊息內容
  Widget basicInformationWidget() {
    String age = '${viewModel.memberInfoRes?.age}'; // 一定會有值
    String occupation = '${viewModel.memberInfoRes?.occupation}'; // 選填的
    String height = '${viewModel.memberInfoRes?.height}'; // 選填的
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

    return Visibility(
      visible: result.isNotEmpty,
      child: Container(
        height: 20.h,
        margin: EdgeInsets.only(top: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            labelTitleWidget(appImageTheme.basicInformationIcon, "基本信息"),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(result,
                    style: appTextTheme.chatroomFriendInformationTitleTextStyle,
                  ),
                ),
              )),
          ],
        ),
      ),
    );
  }

  //近期照片
  Widget recentPictureWidget() {
    final bool noAlbumsPath = viewModel.memberInfoRes?.albumsPath == null || viewModel.memberInfoRes!.albumsPath!.isEmpty;
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (noAlbumsPath)
              ? Container()
              : labelTitleWidget(appImageTheme.recentPhotosIcon, "近期靓照"),
          (noAlbumsPath)?Container():Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: roundedPictureWidget(),
            ),
          ))
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              '温馨提示',
              style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.textFormBlack,
                  fontWeight: FontWeight.w500),
            ),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 214.h, // 设置弹窗内容的宽度
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32.w),
                  width: 278.w,
                  height: 60.h,
                  child: Text(
                    content,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: AppColors.textFormBlack,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32.h),
                  alignment: const Alignment(0, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: AppColors.pinkLightGradientColors,
                  ),
                  child: Text(
                    '去聊天',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget limitDialog() {
  //   return AlertDialog(
  //     backgroundColor: AppColors.whiteBackGround,
  //     insetPadding:
  //         EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
  //     title: Text(
  //       '温馨提示',
  //       style: TextStyle(
  //           fontWeight: FontWeight.w500,
  //           fontSize: 18.sp,
  //           color: AppColors.textFormBlack),
  //     ),
  //     content: Container(
  //       decoration: isBackGroundGradient
  //           ? const BoxDecoration(
  //               gradient: LinearGradient(
  //                 colors: [
  //                   Color.fromRGBO(169, 224, 255, 1),
  //                   Color.fromRGBO(228, 200, 255, 1)
  //                 ], // 渐变色
  //                 begin: Alignment.centerLeft,
  //                 end: Alignment.centerRight,
  //               ),
  //             )
  //           : null,
  //       child: Text(),
  //     ),
  //     contentPadding:
  //         EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
  //   );
  // }

  //Label近期靓照、圓角圖片
  List<Widget> roundedPictureWidget() {
    List<AlbumsPathInfo>? picture = viewModel.memberInfoRes!.albumsPath;
    List<ImageProvider> imageProviders = _avatarAndAlbumImageProviders();

    List<Widget> pictureListWidget = [];
    for (int i = 0; i < picture!.length; i++) {
      pictureListWidget.add(
        Padding(
            padding: EdgeInsets.only(left: 9.w),
            child: InkWell(
                onTap: () {
                  ImageLinksViewer.show(
                      context,
                      ImageLinksViewerArgs(
                          imageLinks: imageProviders, initialPage: i));
                },
                child: CachedNetworkImageUtil.load(
                    HttpSetting.baseImagePath + picture[i].filePath!,
                    size: 50,
                    radius: 6))),
      );
    }
    return pictureListWidget;
  }

  List<ImageProvider> _avatarAndAlbumImageProviders() {
    List<ImageProvider> returnList = [];
    List<AlbumsPathInfo>? picture = viewModel.memberInfoRes!.albumsPath;
    for (int i = 0; i < picture!.length; i++) {
      returnList.add(CachedNetworkImageProvider(
          HttpSetting.baseImagePath + picture[i].filePath!));
    }
    return returnList;
  }
}
