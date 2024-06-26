import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/message_tab/message_list_item.dart';
import 'package:frechat/screens/message_tab/message_tab_viewmodel.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_call_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/chat_call_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/buttons/gradient_button.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:uuid/uuid.dart';

/// 訊息列表(通话页签)
class CallHistToryTab extends ConsumerStatefulWidget {
  final ScrollController? scrollController;

  const CallHistToryTab({super.key, this.scrollController});

  @override
  ConsumerState<CallHistToryTab> createState() => _CallHistToryTabState();
}

class _CallHistToryTabState extends ConsumerState<CallHistToryTab> {
  late MessageTabViewModel viewModel;
  List<String> list = [];

  @override
  void initState() {
    viewModel = MessageTabViewModel(ref: ref, setState: setState, context: context);

  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        List<ChatUserModel> userModel = [];
        /// chatUserModel & chatBlockModel只要內容有更新就會泫染畫面
        final chatUserModel = ref.watch(chatUserModelNotifierProvider);
        final chatBlockModel = ref.watch(chatBlockModelNotifierProvider);
        /// 判斷 最新訊息不為空 && 是否為blockUser
        userModel = chatUserModel.where((info) {
          final bool isNotEmpty = info.recentlyMessage?.isNotEmpty ?? false;
          /// 檢查 黑名單內用戶與列表內做比對移除、當chatBlockModel則直接給予true過
          final bool isNotBlock = chatBlockModel.any((blockUser) => blockUser.userName != info.userName) || chatBlockModel.isEmpty;
          return isNotEmpty && isNotBlock;
        }).toList();

        return callHistToryTab(userModel);
      },
    );
  }

  Widget callHistToryTab(List<ChatUserModel> userModel) {
    final List<ChatCallModel> chatCallList = ref.read(chatCallModelNotifierProvider);
    if (userModel.isEmpty || chatCallList.isEmpty) {
      return emptyTabContent(MessageTabType.call);
    }
    userModel = viewModel.sortChatUsers(userModel);
    final List<ChatUserModel> list = userModel.where((user) {
      final bool isContain = chatCallList.any((call) => call.callerName == user.userName || call.receiverName == user.userName);
      return isContain;
    }).toList();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      controller: widget.scrollController,
      itemBuilder: (context, index) {
        ChatUserModel chatUserModel = list[index];
        return _buildMessageListItem(chatUserModel);
      },
    );
  }

  Widget _buildMessageListItem(ChatUserModel chatUserModel) {
    SearchListInfo? searchListInfo = viewModel.transferChatUserModelToSearchListInfo(chatUserModel);
    return MessageListItem(
      isSystem: false,
      searchListInfo: searchListInfo,
      recentlyMessage: chatUserModel.recentlyMessage,
      unRead: (chatUserModel.unRead ?? 0).toInt(),
      isPinTop: chatUserModel.pinTop,
      points: chatUserModel.points,
      timeStamp: (chatUserModel.timeStamp ?? 0).toInt(),
      sendStatus: chatUserModel.sendStatus ?? 1,
    );
  }

  //空內容頁籤內容
  Widget emptyTabContent(MessageTabType type) {
    String contentTitle = "您目前暂无消息纪录";
    String contentSubtitle = "快去聊天吧";
    bool showButton = true;
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppImageTheme appImageTheme = theme.getAppImageTheme;
    final AppTextTheme appTextTheme = theme.getAppTextTheme;
    String image = appImageTheme.imageMessageEmpty;
    if (type == MessageTabType.cohesion) {
      contentTitle = "亲密度≥2的亲密关系会在这里显示哦";
      contentSubtitle = '立即聊天，遇见亲密的Ta';
      showButton = true;
      image = appImageTheme.imageCohesionEmpty;
    } else if (type == MessageTabType.call) {
      contentTitle = '暂无通话纪录';
      contentSubtitle = '快去通话吧';
      showButton = false;
      image = appImageTheme.imageCallEmpty;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          width: 150.w,
          height: 150.w,
          image: AssetImage(image),
        ),
        Container(
          margin: EdgeInsets.only(top: 14.h),
          child: Text(
            contentTitle,
            style: appTextTheme.messageTabEmptyTitleTextStyle,
          ),
        ),
        Text(
          contentSubtitle,
          style: appTextTheme.messageTabEmptySubTitleTextStyle,
        ),
        (showButton)
            ? CommonButton(
            btnType: CommonButtonType.text,
            cornerType: CommonButtonCornerType.circle,
            isEnabledTapLimitTimer: false,
            width: 148.w,
            height: 44.h,
            text: '去聊天',
            textStyle: TextStyle(
                color: AppColors.textWhite,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp),
            colorBegin: AppColors.mainPink,
            colorEnd: AppColors.mainPetalPink,
            onTap: () {})
            : Container()
      ],
    );
  }
}
